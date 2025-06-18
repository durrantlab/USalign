# Use the official Emscripten SDK image as the base.
# Using a specific version tag ensures reproducibility.
FROM emscripten/emsdk:3.1.53

# Set the working directory inside the container.
WORKDIR /src

# Copy all the source code from your project directory into the container.
COPY . .

# Grant execute permissions to the build script.
RUN chmod +x build.sh

# Run the build script to compile all the tools.
# The compiled files will be placed in the 'dist' directory inside the container.
RUN ./build.sh
