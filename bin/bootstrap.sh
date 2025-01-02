#!/bin/bash

# Immediately exit if any command has a non-zero exit status
set -e

# Luarocks verison
LUA_VERSION=5.3
LUAROCKS_VERSION=3.8.0

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install Lua
install_lua() {
    echo "Checking if Lua is installed"
    if command_exists lua; then
        echo "Lua is already installed"
        lua -v
    else
        echo "Lua is not installed"
        echo "Updating package list and upgrading packages"
        if sudo apt-get update > /dev/null 2>&1 && sudo apt-get upgrade -y > /dev/null 2>&1; then
            echo "Package list updated and packages upgraded"
        else
            echo "An error occurred during the update and upgrade process"
            exit 1
        fi

        echo "Installing Lua"
        if sudo apt-get install -y lua${LUA_VERSION} > /dev/null 2>&1; then
            echo "Lua has been installed"
            lua -v
        else
            echo "An error occurred while installing Lua"
            exit 1
        fi
    fi
}

# Install luax.x-dev if it is not installed
install_lua_dev() {
    echo "Checking if Lua development package is installed"
    if dpkg -l | grep -q lua${LUA_VERSION}-dev; then
        echo "Lua development package is already installed"
    else
        echo "Installing Lua development package"
        if sudo apt-get install -y lua${LUA_VERSION}-dev > /dev/null 2>&1; then
            echo "Lua development package has been installed"
        else
            echo "An error occurred while installing Lua development package"
            exit 1
        fi
    fi
}

install_luarocks() {
    echo "Check if LuaRocks is installed"

    if command_exists luarocks; then
        echo "LuaRocks is already installed"
        luarocks --version
    else
        echo "LuaRocks is not installed"

        echo "Checking if wget is installed"
        if command -v wget > /dev/null 2>&1; then
            echo "wget is installed"
        else
            echo "wget is not installed"
            sudo apt-get install -y wget
        fi

        # Assuming you have wget installed
        wget -q https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz
        tar zxpf luarocks-${LUAROCKS_VERSION}.tar.gz > /dev/null 2>&1
        cd luarocks-${LUAROCKS_VERSION}

        # Adjust the installation prefix and Lua interpreter as needed
        ./configure --prefix=/usr/local --with-lua-include=/usr/include/lua5.3
        make -s
        sudo make -s install

        # Clean up
        cd ..
        rm -rf luarocks-${LUAROCKS_VERSION} luarocks-${LUAROCKS_VERSION}.tar.gz

        echo "LuaRocks installation completed."
    fi
}

# Call the function to install Lua
install_lua

# call the function to install Lua development package
install_lua_dev

# Call the function
install_luarocks

# Call the Lua setup file
echo "Running Lua setup file..."
lua ./setup.lua
