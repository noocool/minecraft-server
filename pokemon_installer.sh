#!/bin/bash
COBBLEMON_URL="https://cdn.modrinth.com/data/MdwFAVRL/versions/v77SHSXW/Cobblemon-fabric-1.6.1%2B1.21.1.jar"

# --- 2. Safely Set Up Server Directory with User Confirmation ---
echo "INFO: Checking for existing server directory..."
if [ -d "server" ]; then
    read -p "WARN: Existing 'server' directory found. Do you want to delete it and reinstall? (y/n): " confirm
    confirm_lower=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')
    if [[ "$confirm_lower" == y* ]]; then
        echo "INFO: User confirmed. Deleting existing server directory..."
        rm -rf server
    else
        echo "INFO: Installation cancelled by user."
        exit 0
    fi
fi

# --- 3. Create Directory and Install NeoForge Server ---
echo "INFO: Creating new 'server' directory..."
mkdir server
cd server

cp ../cobblemon/fabric-server.jar .
java -jar "fabric-server.jar" --installServer

# --- 4. Accept EULA (Crucial Step for Linux) ---
echo "INFO: Automatically accepting the Minecraft EULA..."
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
cd ..
./start_server.sh
echo "SUCCESS: Server installation is complete!"