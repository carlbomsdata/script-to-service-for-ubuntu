#!/bin/bash

# Accept the service name from the user
read -p "Enter the name of your service: " SERVICE_NAME

# Accept the filename from the user
read -p "Enter the filename of your script (Python or Shell): " FILENAME

# Construct the full path to the script
SCRIPT_PATH="$(pwd)/$FILENAME"

# Check if the file exists
if [ ! -f "$SCRIPT_PATH" ]; then
    echo "Error: File $SCRIPT_PATH not found!"
    exit 1
fi

# Set execute permissions on the script
chmod +x "$SCRIPT_PATH"
if [ $? -ne 0 ]; then
    echo "Error: Failed to set execute permissions on $SCRIPT_PATH."
    exit 1
fi

# Determine the file type and set the appropriate interpreter
case "$FILENAME" in
    *.py)
        # Ensure Python runs in unbuffered mode
        INTERPRETER="/usr/bin/python3 -u $SCRIPT_PATH"
        ;;
    *.sh)
        INTERPRETER="/bin/bash $SCRIPT_PATH"
        ;;
    *)
        echo "Error: Unsupported file type. Please provide a .py or .sh file."
        exit 1
        ;;
esac

# Accept the username from the user
read -p "Enter the username of the user who will run the service: " USERNAME

# Check if the user exists
if ! id "$USERNAME" &>/dev/null; then
    echo "Error: User $USERNAME does not exist!"
    exit 1
fi

# Provide a brief description of your service
DESCRIPTION="Your Custom Service Description"

# Create the systemd service file
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"
echo "[Unit]
Description=$DESCRIPTION
After=network.target

[Service]
ExecStart=$INTERPRETER
WorkingDirectory=$(dirname "$SCRIPT_PATH")
StandardOutput=journal
StandardError=journal
Restart=always
User=$USERNAME

[Install]
WantedBy=multi-user.target" | sudo tee $SERVICE_FILE > /dev/null

if [ $? -ne 0 ]; then
    echo "Error: Failed to create systemd service file."
    exit 1
fi

# Reload systemd to read the new service file
sudo systemctl daemon-reload

# Enable the service
sudo systemctl enable $SERVICE_NAME
if [ $? -ne 0 ]; then
    echo "Error: Failed to enable $SERVICE_NAME."
    exit 1
fi

echo "Enabled $SERVICE_NAME."

# Start the service
sudo systemctl start $SERVICE_NAME
if [ $? -ne 0 ]; then
    echo "Error: Failed to start $SERVICE_NAME."
    exit 1
fi

echo "Started $SERVICE_NAME."

# Print success message
echo "Service $SERVICE_NAME setup successful!"
echo "To view the service status, use: sudo systemctl status $SERVICE_NAME"
echo "To view the detailed service logs, use: sudo journalctl -u $SERVICE_NAME --since \"1 minute ago\""
