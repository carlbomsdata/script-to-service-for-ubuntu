This repository contains scripts for setting up and managing custom systemd services for Python and Bash scripts. These services are designed to run continuously in the background on systems using systemd, such as many modern Linux distributions.

## Features

- **Python and Bash script service installation**: Automates the setup of Python and Bash scripts as systemd services.
- **Automatic logging**: Configures services to log output to systemd's journal, making it easy to monitor and troubleshoot.
- **Flexible script handling**: Supports both Python scripts (with unbuffered output) and Bash scripts.

## Prerequisites

Before you start using these scripts, make sure you have:
- A Linux system with systemd installed.
- Python 3 installed if you are setting up Python scripts.
- Sudo privileges for setting up and managing systemd services.

## Installation

#### Clone the Repository and make script executable:
   ```bash
   git clone https://github.com/manprinsen/script-to-service-for-ubuntu.git
   ```
   ```bash
   cd script-to-service-for-ubuntu
   ```
   ```bash
   chmod +x install.sh
   ```

## Usage
Ensure that your Python or Bash script file is in the script-to-service-for-ubuntu directory before executing the command below:
#### To start installing your script, run:
   ```bash
   sudo ./install.sh
   ```
