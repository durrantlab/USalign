#!/bin/bash
# Exit immediately if a command exits with a non-zero status.
set -e

# Create a directory to store the compiled WebAssembly files.
mkdir -p dist

# Common Emscripten compiler flags for all tools.
# Using a shell array is safer for arguments with spaces.
FLAGS=(
    -O3
    -s WASM=1
    -s MODULARIZE=1
    -s "EXPORTED_RUNTIME_METHODS=['FS', 'callMain']"
    -s ALLOW_MEMORY_GROWTH=1
)

# A list of all the command-line tools that have a `main` function.
TOOLS=(
    USalign
    TMalign
    TMscore
    MMalign
    HwRMSD
    NWalign
    cif2pdb
    pdb2fasta
    pdb2ss
    pdb2xyz
    pdbAtomName
    xyz_sfetch
    biounitasym
    addChainID
)

# Loop through the list and compile each tool.
for TOOL in "${TOOLS[@]}"; do
    echo "Compiling ${TOOL}..."
    
    # The -I. flag is important so the compiler can find the local header files.
    # The -s "EXPORT_NAME='${TOOL}Module'" gives each module a unique name.
    # Use "${FLAGS[@]}" to correctly pass arguments with spaces.
    #
    # Change the output from .html to .js to fix the EXPORT_NAME error.
    em++ ${TOOL}.cpp -I. "${FLAGS[@]}" -s "EXPORT_NAME='${TOOL}Module'" -o "dist/${TOOL}.js"
done

echo "All tools compiled successfully and are located in the 'dist' directory."