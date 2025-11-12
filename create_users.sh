#!/bin/bash

# Constants
INPUT_FILE="$1"
PASSWORD_FILE="/var/secure/user_passwords.txt"
LOG_FILE="/var/log/user_management.log"

setup_environment() {
    mkdir -p /var/secure
    mkdir -p /var/log
    touch "$PASSWORD_FILE" "$LOG_FILE"
    chmod 600 "$PASSWORD_FILE" "$LOG_FILE"
}

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

generate_password() {
    openssl rand -base64 16 | tr -dc 'A-Za-z0-9' | head -c12
}

create_groups() {
    local group_list="$1"
    IFS=',' read -ra groups <<< "$group_list"
    for group in "${groups[@]}"; do
        if ! getent group "$group" &>/dev/null; then
            groupadd "$group"
            log_action "INFO: Group '$group' created."
        fi
    done
}

create_user() {
    local username="$1"
    local group_list="$2"

    if id "$username" &>/dev/null; then
        log_action "SKIPPED: User '$username' already exists."
        echo "User '$username' already exists. Skipping."
        return
    fi

    create_groups "$group_list"

    useradd -m -s /bin/bash -G "$group_list" "$username"
    if [[ $? -ne 0 ]]; then
        log_action "ERROR: Failed to create user '$username'."
        echo "Failed to create user '$username'."
        return
    fi

    chown "$username:$username" "/home/$username"
    chmod 700 "/home/$username"

    local password
    password=$(generate_password)
    echo "$username:$password" | chpasswd
    echo "$username:$password" >> "$PASSWORD_FILE"

    log_action "SUCCESS: User '$username' created and added to [$group_list]."
    echo "User '$username' created successfully."
}

process_users_file() {
    while IFS= read -r line; do
        line=$(echo "$line" | xargs)
        [[ -z "$line" || "$line" =~ ^# ]] && continue

        IFS=';' read -r username groups <<< "$line"
        username=$(echo "$username" | xargs)
        groups=$(echo "$groups" | tr -d ' ')

        create_user "$username" "$groups"
    done < "$INPUT_FILE"
}

main() {
    if [[ ! -f "$INPUT_FILE" ]]; then
        echo "Error: Input file '$INPUT_FILE' not found."
        log_action "ERROR: Input file '$INPUT_FILE' not found."
        exit 1
    fi

    setup_environment
    process_users_file
}
main