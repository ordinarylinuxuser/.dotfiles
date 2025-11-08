#!/bin/bash

# Function to open a port
open_port() {
    echo "Opening port..."
    read -p "Enter the port number: " port_number
    read -p "Enter protocol (tcp/udp): " protocol
    sudo firewall-cmd --permanent --add-port="$port_number/$protocol"
    if [ $? -eq 0 ]; then
        echo "Port $port_number ($protocol) opened successfully."
    else
        echo "Failed to open port. Check if firewalld is running or use sudo."
    fi
    sudo firewall-cmd --reload
}

# Function to close a port
close_port() {
    echo "Closing port..."
    read -p "Enter the port number: " port_number
    read -p "Enter protocol (TCP/UDP): " protocol
    sudo firewall-cmd --permanent --remove-port="$port_number/$protocol"
    if [ $? -eq 0 ]; then
        echo "Port $port_number ($protocol) closed successfully."
    else
        echo "Failed to close port. The port might not exist or firewalld isn't running."
    fi
    sudo firewall-cmd --reload
}

# Check if firewalld is active
firewalld_status() {
    systemctl status firewalld | grep 'Active: yes' > /dev/null
    return $?
}

# Menu interface
while true; do
    clear
    echo "Firewalld Port Manager"
    echo "------------------------"
    echo "1. Open a port"
    echo "2. Close a port"
    echo "3. Check firewalld status"
    echo "0. Exit"
    
    read -p "Enter your choice: " choice
    
    case $choice in
        1)
            open_port
            read -p "Press Enter to continue..."
            ;;
        2)
            close_port
            read -p "Press Enter to continue..."
            ;;
        3)
            if firewalld_status; then
                echo -e "\nFirewalld is running."
            else
                echo -e "\nFirewalld is not running."
            fi
            read -p "Press Enter to continue..." 
            ;;
        0)
            exit
            ;;
        *)
            echo "Invalid choice. Please enter a number between 0 and 3."
            sleep 1
            read -p "Press Enter to continue..."
            ;;
    esac
done
