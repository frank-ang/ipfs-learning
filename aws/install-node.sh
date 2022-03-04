#!/bin/bash
# Install node on ubuntu.
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
nvm install node 17.6.0
npm install -g ipfs-car