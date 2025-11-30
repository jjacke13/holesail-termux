#!/bin/sh

# Install dependencies
pkg update && pkg upgrade -y && pkg install wget unzip -y

# Download and setup holesail
echo "Setting up holesail..."
wget -q https://github.com/holesail/holesail/releases/download/2.4.1/android-arm64.zip
unzip -q android-arm64.zip && rm android-arm64.zip
chmod +x holesail

# Move binary to PATH
mv holesail $PREFIX/bin/

# Get holesail key
echo "Paste your holesail key:"
read key

# Create connection script
echo "holesail $key" > ~/hole
chmod +x ~/hole

# Create shortcuts
mkdir -p ~/.shortcuts
echo '#!/bin/sh
if [ -f ~/hole ]; then ~/hole; else echo "Run setup first"; fi' > ~/.shortcuts/connect
echo '#!/bin/sh
pkill -f holesail && echo "Disconnected"' > ~/.shortcuts/disconnect
chmod +x ~/.shortcuts/*

# Add aliases and PATH
echo 'alias hs="~/hole"
alias stop="pkill -f holesail"
export PATH="$HOME/.shortcuts:$PATH"' >> ~/.bashrc

echo "Setup complete!"
echo "Commands: 'hs' to connect, 'stop' to disconnect"
echo "Widgets: Add Termux widget, use 'connect' and 'disconnect'"
echo "Restart Termux or run: . ~/.bashrc"