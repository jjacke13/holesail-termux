#!/bin/sh
pkg update 
apt upgrade -y
pkg install nodejs-lts -y
pkg install git -y

cat << EOF > ./.bashrc
export PATH="/data/data/com.termux/files/home:$PATH"
EOF

npm i bare -g
git clone https://github.com/holesail/holesail 
cd holesail
npm i

cd ..

cat << EOF > ./start
# Prompt the user for a string
echo "Please paste here your holesail string: "

# Read the user input
read string

# Create a file and write the user input within a specific text format
echo "bare ./holesail/index.js \${string}" | tr -d '\n' > hole
chmod +x hole

# Echo a specific text
echo "Now your holesail string is saved in the file 'hole'. When you want
 to connect, open termux, type "hole" and press enter. If you want to change your holesail string, type start and press enter."
EOF

chmod +x start

sh ./start
