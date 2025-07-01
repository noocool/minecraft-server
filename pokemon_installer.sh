#!/bin/bash
# A robust script to install a Cobblemon server on Linux, with user confirmation for deletion.

# --- Variables (Easy to update here) ---
JAVA_VERSION="21.0.3-tem"
FABRIC_URL="https://meta.fabricmc.net/v2/versions/loader/1.21.1/0.16.14/1.0.3/server/jar"
# You can find the latest URLs from CurseForge or Modrinth by right-clicking the download button and copying the link address.
COBBLEMON_URL="https://cdn.modrinth.com/data/MdwFAVRL/versions/v77SHSXW/Cobblemon-fabric-1.6.1%2B1.21.1.jar"

# --- 1. Set Java Version ---
echo "INFO: Checking if Java ${JAVA_VERSION} is installed via SDKMAN..."

# Check if version is installed
if sdk list java | grep -q "$JAVA_VERSION"; then
    echo "INFO: Java ${JAVA_VERSION} is available."
else
    echo "INFO: Java ${JAVA_VERSION} not found. Installing..."
    sdk install java "$JAVA_VERSION"
fi

# Set as default
echo "INFO: Setting Java ${JAVA_VERSION} as the default..."
sdk default java "$JAVA_VERSION"

# Confirm
echo "INFO: Current Java version is:"
java -version

# --- 2. Safely Set Up Server Directory with User Confirmation ---
echo "INFO: Checking for existing server directory..."
if [ -d "server" ]; then
    # Prompt the user for confirmation. -p displays the prompt without a newline.
    read -p "WARN: Existing 'server' directory found. Do you want to delete it and reinstall? (y/n): " confirm
    
    # Convert the user's input to lowercase for easier comparison
    confirm_lower=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')

    # Check if the user's response starts with 'y'. This accepts 'y', 'yes', 'Y', etc.
    if [[ "$confirm_lower" == y* ]]; then
        echo "INFO: User confirmed. Deleting existing server directory..."
        rm -rf server
    else
        echo "INFO: Installation cancelled by user."
        exit 0 # Exit the script cleanly without an error.
    fi
fi

# --- 3. Create Directory and Install NeoForge Server ---
echo "INFO: Creating new 'server' directory..."
mkdir server
cd server

# echo "INFO: Downloading and installing Fabric Server..."
# wget "${FABRIC_URL}" -O "fabric-server.jar"
cp ../cobblemon/fabric-server.jar .
java -jar "fabric-server.jar" --installServer

# --- 4. Accept EULA (Crucial Step for Linux) ---
echo "INFO: Automatically accepting the Minecraft EULA..."
# The run.sh script is created by the installer. We run it once.
# It is EXPECTED to fail because the EULA is false. The `|| true` prevents the script from stopping here.
./run.sh nogui || true 
echo "eula=true" > eula.txt

# --- 5. Download and Install Mods ---
echo "INFO: Creating 'mods' directory and downloading mods..."
# Copy all file instead
cp -r ../cobblemon/* .

# mkdir mods
echo "INFO: Downloading Cobblemon..."
wget -P mods/ "${COBBLEMON_URL}"

# --- 6. Final Instructions ---
echo ""
echo "SUCCESS: Server installation is complete!"
echo "Your previous server was deleted as requested."
echo "To start your new server, run the following commands:"
echo "./start_server.sh"