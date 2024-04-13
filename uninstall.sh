#!/bin/bash

# Accept the service name from the user
read -p "Enter the name of the service you want to uninstall: " SERVICE_NAME

# Define the path to the systemd service file
SERVICE_PATH="/etc/systemd/system/$SERVICE_NAME.service"

# Check if the service file exists before attempting to stop or disable
if [ ! -f "$SERVICE_PATH" ]; then
    echo "Error: Service file $SERVICE_PATH does not exist."
    exit 1
fi

# Stop the service if it is running
echo "Stopping $SERVICE_NAME..."
sudo systemctl stop $SERVICE_NAME
if [ $? -ne 0 ]; then
    echo "Warning: Failed to stop $SERVICE_NAME. It may not have been running."
fi

# Disable the service to prevent it from starting on boot
echo "Disabling $SERVICE_NAME..."
sudo systemctl disable $SERVICE_NAME
if [ $? -ne 0 ]; then
    echo "Warning: Failed to disable $SERVICE_NAME. It may not have been enabled."
fi

# Remove the systemd service file
echo "Removing service file $SERVICE_PATH..."
sudo rm -f $SERVICE_PATH
if [ $? -ne 0 ]; then
    echo "Error: Failed to remove the service file. Please check your permissions."
    exit 1
fi

# Reload systemd to apply changes
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload
if [ $? -ne 0 ]; then
    echo "Error: Failed to reload systemd daemon."
    exit 1
fi

echo "Service $SERVICE_NAME has been successfully uninstalled."
