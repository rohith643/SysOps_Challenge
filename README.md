**User Account Automation — create_users.sh**
Automate Linux user provisioning with secure password generation, group assignment, home directory setup, and detailed logging — all from a simple input file.

**Project Summary**

This Bash script streamlines the onboarding process for new developers or team members by reading a structured input file (Users.txt) and automatically:

- Creating user accounts
- Assigning groups
- Generating secure passwords
- Setting up home directories
- Logging all actions
- Storing credentials securely

**Files and Structure**

user_setup/
├── create_users.sh           # Main automation script
├── Users.txt                 # Input file with usernames and group memberships
├── /var/secure/              # Stores generated passwords (created by script)
└── /var/log/                 # Stores action logs (created by script)

**Input File Format: Users.txt**

Each line must follow this format:
username; group1,group2,group3

- Lines starting with # are ignored
- Whitespace is trimmed automatically
- Groups must be comma-separated

**Example**
**Team onboarding list**

Rohith; sudo,dev,www-data
Sneha; dev
Deepak; sudo,dev

**How to Use**

1. Prepare the Environment
Make sure you're running in a Linux shell (WSL, Ubuntu, or native Linux).
2. Place Files
Ensure create_users.sh and Users.txt are in the same directory.
3. Make the Script Executable
chmod +x create_users.sh
4. Run the Script
sudo ./create_users.sh Users.txt

**Security Features**

- Passwords are randomly generated (12 characters) using OpenSSL
- Stored securely in /var/secure/user_passwords.txt with chmod 600
- Logs all actions to /var/log/user_management.log with chmod 600
- Home directories are created with chmod 700 for privacy

**Script Logic Breakdown**

- Setup: Creates secure directories and files
- Input Parsing: Reads each line, skips comments and blank lines
- Group Handling: Creates missing groups
- User Creation: Adds user, assigns groups, sets shell and home
- Password Generation: Creates and sets a secure password
- Logging: Records success, errors, and skipped users

**Troubleshooting**

| Issue                                | Solution                                        |
|-------------------------------------|--------------------------------------------------|
| `Error: Input file '' not found.`   | Run with filename: `./create_users.sh Users.txt` |
| `line 89: syntax error`             | Check for missing `}` in functions               |
| Script won’t run on Windows         | Use WSL or Git Bash                              |
| Users not created                   | Ensure script is run with `sudo`                 |

**Customization Ideas**

- Add email notifications for each user
- Support dry-run mode for testing
- Integrate with LDAP or Active Directory
- Add rollback on failure

**Author**

Rohith C
MCA Graduate | Bash Automation Enthusiast
