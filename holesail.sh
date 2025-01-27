#!/bin/sh
pkg update 
apt upgrade -y
pkg install nodejs-lts 
pkg install git 
pkg install python3 autoconf automake make binutils 
git clone https://github.com/holesail/holesail.git 
rm ./holesail/package-lock.json
rm ./holesail/package.json
cat << EOF > ./holesail/package.json
{
  "name": "holesail",
  "version": "1.8.2",
  "description": "Holesail is TCP/UDP peer-to-peer proxy. Holesail let's you instantly share any application running on a specific port from your local computer.",
  "main": "index.js",
  "scripts": {
    "test": "npm test",
    "refresh": "rm package-lock.json && rm -rf node_modules && npm i && npm update"
  },
  "repository": {
    "type": "git",
    "url": "git+https://github.com/holesail/holesail.git"
  },
  "keywords": [
    "holesail",
    "hyperdht",
    "holepunch"
  ],
  "author": "supersuryaansh",
  "license": "GPL-3.0",
  "bugs": {
    "url": "https://github.com/holesail/holesail/issues"
  },
  "homepage": "https://github.com/holesail/holesail#readme",
  "dependencies": {
    "b4a": "^1.6.6",
    "cli-box": "^6.0.10",
    "colors": "^1.4.0",
    "graceful-goodbye": "^1.3.0",
    "holesail-client": "^1.1.6",
    "holesail-server": "^1.4.2",
    "hyper-cmd-lib-keys": "^0.1.1",
    "hyperdht": "^6.20.0",
    "minimist": "^1.2.8",
    "pm2": "^5.4.2",
    "qrcode-terminal": "^0.12.0",
    "standard": "^17.1.2",
    "udx-native": "1.11.2", 
    "sodium-native": "4.1.1"
  },
  "bin": {
    "holesail": "./index.js",
    "holesail-manager": "./manager.js"
  }
}
EOF

mkdir .gyp 
cat << EOF > ./.gyp/include.gypi
{
  'variables': {
    'android_ndk_path': ''
  }
}
EOF

cat << EOF > ./.bashrc
export PATH="/data/data/com.termux/files/home:$PATH"
EOF

source .bashrc

cd holesail

npm i --build-from-source --foreground-scripts

cd ..

cat << EOF > ./start
# Prompt the user for a string
echo "Please paste here your holesail string: "

# Read the user input
read string

# Create a file and write the user input within a specific text format
echo "node holesail \${string}" > hole
chmod +x hole

# Echo a specific text
echo "Now your holesail string is saved in the file 'hole'. When you want
 to connect, open termux, type "hole" and press enter. If you want to change your holesail string, type start and press enter."
EOF

chmod +x start

sh ./start
