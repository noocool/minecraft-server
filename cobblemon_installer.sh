echo "Installing sdk java 21.0.3-tem"
sdk install java 21.0.3-tem
sdk use java 21.0.3-tem

echo "Installing neoforge 21.1.113"
rm -rf ./server
mkdir server
cd server
wget https://maven.neoforged.net/releases/net/neoforged/neoforge/21.1.113/neoforge-21.1.113-installer.jar
java -jar neoforge-21.1.113-installer.jar --installServer

cp -r ../cobblemon/gameFiles/* .