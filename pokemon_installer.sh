#!/bin/bash

COBBLEMON_URL="https://cdn.modrinth.com/data/MdwFAVRL/versions/v77SHSXW/Cobblemon-fabric-1.6.1%2B1.21.1.jar"

# --- 1. Kiểm tra và xử lý thư mục server ---
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

# --- 2. Tạo thư mục server và cài đặt Fabric ---
echo "INFO: Creating new 'server' directory..."
mkdir server
cd server

echo "INFO: Installing Fabric Server..."
cp ../cobblemon/fabric-server.jar .
java -jar "fabric-server.jar" --installServer

# --- 3. Chấp nhận EULA ---
echo "INFO: Automatically accepting the Minecraft EULA..."
./run.sh nogui || true 
echo "eula=true" > eula.txt

# --- 4. Cài mod và copy toàn bộ dữ liệu từ cobblemon ---
echo "INFO: Copying all modpack files from ../cobblemon/ ..."
cp -r ../cobblemon/* .

echo "INFO: Ensuring 'mods' folder exists..."
mkdir -p mods

echo "INFO: Downloading latest Cobblemon jar..."
wget -nc -P mods/ "${COBBLEMON_URL}"

# --- 5. Copy datapacks nếu có ---
echo "INFO: Preparing datapacks..."
mkdir -p world/datapacks

if [ -d "../cobblemon/datapacks" ]; then
    echo "INFO: Copying datapacks into world/datapacks..."
    cp -r ../cobblemon/datapacks/* world/datapacks/
else
    echo "WARN: No datapacks folder found in ../cobblemon/"
fi

# --- 6. Hoàn tất ---
cd ..
echo "SUCCESS: Server installation is complete!"
echo "You can now start your server with:"
echo "./start_server.sh"
