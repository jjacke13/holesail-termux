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
  "version": "1.10.0",
  "description": "Holesail is TCP/UDP peer-to-peer proxy. Holesail let's you instantly share any application running on a specific port from your local computer.",
  "main": "index.js",
  "pear": {
    "name": "holesail",
    "type": "terminal"
  },
  "imports": {
    "util": {
      "bare": "bare-utils",
      "default": "util"
    },
    "fs": {
      "bare": "bare-fs",
      "default": "fs"
    }
  },
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
  "pkg": {
    "assets": [
      "includes/**/*"
    ]
  },
  "dependencies": {
    "b4a": "^1.6.6",
    "bare-crypto": "^1.3.1",
    "bare-events": "^2.5.0",
    "bare-fs": "^4.0.1",
    "bare-http1": "^4.0.2",
    "bare-net": "^2.0.0",
    "bare-os": "^3.3.0",
    "bare-path": "^3.0.0",
    "bare-process": "^4.0.0",
    "bare-querystring": "^1.0.0",
    "bare-subprocess": "^5.0.2",
    "bare-tty": "^5.0.1",
    "bare-utils": "1.1.1",
    "barely-pm2": "^0.0.4",
    "child_process": "npm:bare-subprocess@^5.0.2",
    "cli-box": "^6.0.10",
    "colors": "^1.4.0",
    "crypto": "npm:bare-crypto@^1.3.1",
    "events": "npm:bare-events@^2.5.0",
    "fs": "npm:bare-node-fs@^1.0.2",
    "graceful-goodbye": "^1.3.0",
    "holesail-client": "^1.1.6",
    "holesail-server": "^1.4.4",
    "http": "npm:bare-http1@^4.0.2",
    "hyper-cmd-lib-keys": "^0.1.1",
    "hyperdht": "^6.20.0",
    "minimist": "^1.2.8",
    "net": "npm:bare-net@^2.0.0",
    "os": "npm:bare-os@^3.3.0",
    "path": "npm:bare-path@^3.0.0",
    "process": "npm:bare-process@^4.0.0",
    "qrcode-terminal": "^0.12.0",
    "querystring": "npm:bare-querystring@^1.0.0",
    "tty": "npm:bare-tty@^5.0.1",
    "util": "npm:bare-utils@^1.1.1",
    "which-runtime": "^1.2.1",
    "udx-native": "1.11.2",
    "sodium-native": "4.1.1"
  },
  "bin": {
    "holesail": "./index.js"
  },
  "devDependencies": {
    "standard": "^17.1.2"
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
