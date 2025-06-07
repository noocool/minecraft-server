#!/bin/bash
# A robust script to install a Cobblemon server on Linux, with user confirmation for deletion.

# --- Variables (Easy to update here) ---
JAVA_VERSION="21.0.3-tem"
NEOFORGE_VERSION="21.1.113"
# You can find the latest URLs from CurseForge or Modrinth by right-clicking the download button and copying the link address.
COBBLEMON_URL="https://mediafilez.forgecdn.net/files/5608/969/cobblemon-neoforge-1.5.2%2B1.21.1.jar"
ARCHITECTURY_URL="https://mediafilez.forgecdn.net/files/5460/807/architectury-12.0.9-neoforge.jar"

# --- 1. Set Java Version ---
echo "INFO: Checking if Java ${JAVA_VERSION} is installed via SDKMAN..."

# Load SDKMAN (assumes it's already installed)
source "$HOME/.sdkman/bin/sdkman-init.sh"

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
cd server || exit # Exit with an error if we can't enter the new directory

echo "INFO: Downloading and installing NeoForge ${NEOFORGE_VERSION}..."
wget "https://maven.neoforged.net/releases/net/neoforged/neoforge/${NEOFORGE_VERSION}/neoforge-${NEOFORGE_VERSION}-installer.jar"
java -jar "neoforge-${NEOFORGE_VERSION}-installer.jar" --installServer

# --- 4. Accept EULA (Crucial Step for Linux) ---
echo "INFO: Automatically accepting the Minecraft EULA..."
# The run.sh script is created by the installer. We run it once.
# It is EXPECTED to fail because the EULA is false. The `|| true` prevents the script from stopping here.
./run.sh nogui || true 
echo "eula=true" > eula.txt

# --- 5. Download and Install Mods ---
echo "INFO: Creating 'mods' directory and downloading mods..."
# Move mods instead
cp -r ../cobblemon/gameFiles/* .
# mkdir mods
# echo "INFO: Downloading Cobblemon..."
# wget -P mods/ "${COBBLEMON_URL}"
# echo "INFO: Downloading Architectury API..."
# wget -P mods/ "${ARCHITECTURY_URL}"

# --- 6. Final Instructions ---
echo ""
echo "SUCCESS: Server installation is complete!"
echo "Your previous server was deleted as requested."
echo "To start your new server, run the following commands:"
echo "cd server"
echo "java -Xmx4G -Xms2G -jar run.sh nogui"