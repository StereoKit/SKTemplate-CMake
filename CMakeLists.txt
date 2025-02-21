cmake_minimum_required(VERSION 3.11)
project(SKNativeTemplate VERSION "0.1.0" LANGUAGES CXX C)

add_executable( ${PROJECT_NAME} )

# Grab and build StereoKit from the GitHub repository. Here we're setting SK up
# as a statically linked library.
include(FetchContent)
set(SK_BUILD_TESTS       OFF CACHE INTERNAL "")
set(SK_BUILD_SHARED_LIBS OFF CACHE INTERNAL "")
FetchContent_Declare(
	StereoKitC
	GIT_REPOSITORY https://github.com/StereoKit/StereoKit.git
	GIT_TAG        v0.3.10
)
FetchContent_MakeAvailable(StereoKitC)

# Link to dependencies
target_link_libraries( ${PROJECT_NAME}
	PRIVATE StereoKitC
)

# Add source files to our target executable
target_sources( ${PROJECT_NAME} PRIVATE
	src/main.cpp
)

# Compile shaders to .h files for use in our code, you can find parameter docs
# for the shader compiler here: https://github.com/StereoKit/sk_gpu/blob/master/skshaderc/main.cpp#L247-L301
skshaderc_compile_headers( ${PROJECT_NAME}
	${CMAKE_BINARY_DIR}/shaders/
	"-O3 -si -t xe -i ${stereokitc_SOURCE_DIR}/tools/include"
	src/shaders/floor.hlsl)
