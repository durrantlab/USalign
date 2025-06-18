#!/bin/bash
# Exit immediately if a command exits with a non-zero status.
set -e

echo "--- Building Docker image ---"
docker build -t usalign-wasm .

# Remove old output directory to ensure a clean copy
echo "--- Removing old dist directory ---"
rm -rf ./dist

# Force remove the container if it exists, ignoring errors if it doesn't
echo "--- Cleaning up old container (if any) ---"
docker rm -f usalign-container || true

echo "--- Extracting compiled files ---"
docker create --name usalign-container usalign-wasm
docker cp usalign-container:/src/dist ./dist
docker rm usalign-container

echo "--- Success! Compiled files are in the ./dist directory ---"

cp index.html dist/
cd dist
python -m http.server

