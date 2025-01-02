#!/bin/bash

# Immediately exit if any command has a non-zero exit status
set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install Lua
install_lua() {
    echo "Checking if Lua is installed..."
    if command_exists lua; then
        echo "Lua is already installed"
        lua -v
    else
        echo "Lua is not installed"
        echo "Updating package list and upgrading packages..."
        if sudo apt-get update > /dev/null 2>&1 && sudo apt-get upgrade -y > /dev/null 2>&1; then
            echo "Package list updated and packages upgraded"
        else
            echo "An error occurred during the update and upgrade process"
            exit 1
        fi

        echo "Installing Lua..."
        if sudo apt-get install -y lua5.3 > /dev/null 2>&1; then
            echo "Lua has been installed"
            lua -v
        else
            echo "An error occurred while installing Lua"
            exit 1
        fi
    fi
}

# Call the function to install Lua
install_lua

# Call the Lua setup file
echo "Running Lua setup file..."
lua ./setup.lua
