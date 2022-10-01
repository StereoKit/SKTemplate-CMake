# StereoKit Template for CMake

This is a basic StereoKit template for C/C++ using [CMake](https://cmake.org/). It's straightforward and portable way to build native StereoKit apps on Linux, Windows, and Web (via [emcc](https://emscripten.org/))! This template works quite well with VS Code, and following the prompts provided there can get you running pretty quickly. CMake can also be used to generate a Visual Studio solution, for those that prefer that workflow.

This template directly references and builds the StereoKit repository rather than using pre-built binaries, so this template could also be great for those that wish to fork and modify StereoKit's code!

## Linux pre-requisites

Linux users will need to install some pre-requisites for this template to compile.

```shell
sudo apt-get update
sudo apt-get install build-essential cmake unzip libfontconfig1-dev libgl1-mesa-dev libvulkan-dev libx11-xcb-dev libxcb-dri2-0-dev libxcb-glx0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-randr0-dev libxrandr-dev libxxf86vm-dev mesa-common-dev libjsoncpp-dev libxfixes-dev libglew-dev
```

## Command line instructions

For those new to CMake, here's a quick example of how to compile and build this using the CLI! If something is going wrong, sometimes adding in a `-v` for verbose will give you some additional info you might not see from VS Code.

```shell
# From the project root directory

# Make a folder to build in
mkdir build
cd build

# Configure the build
cmake .. -DCMAKE_BUILD_TYPE=Debug
# Build
cmake --build . -j8 --config Debug

# Run the app
./SKNativeTemplate
```
