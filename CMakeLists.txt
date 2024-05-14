# Build for Android
# mkdir build_android
# cd build_android
# cmake -G Ninja -DCMAKE_TOOLCHAIN_FILE="cmake/android.toolchain.cmake" ..
# cmake --build . -j16

cmake_minimum_required(VERSION 3.21)
project(SKNativeTemplate VERSION "0.1.0" LANGUAGES CXX C)

if (ANDROID)
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib/${CMAKE_ANDROID_ARCH_ABI})

  # Android projects are shared libraries wrapped in an APK. Sprinkle in a
  # little bit of glue code to talk to the parent system, and we're good to go.
  add_library               (${PROJECT_NAME} SHARED)
  target_sources            (${PROJECT_NAME} PRIVATE ${CMAKE_ANDROID_NDK}/sources/android/native_app_glue/android_native_app_glue.c)
  target_include_directories(${PROJECT_NAME} PUBLIC  ${CMAKE_ANDROID_NDK}/sources/android/native_app_glue)

  include(cmake/androidpack.cmake)
else()
  # Non-android projects are just regular executables.
  add_executable(${PROJECT_NAME})
endif()

# Grab and build StereoKit from the GitHub repository. Here we're setting SK up
# as a statically linked library.
include(FetchContent)
set(SK_BUILD_TESTS       OFF CACHE INTERNAL "")
set(SK_BUILD_SHARED_LIBS OFF CACHE INTERNAL "")
FetchContent_Declare(
  StereoKitC
  GIT_REPOSITORY https://github.com/StereoKit/StereoKit.git
  GIT_TAG        v0.3.9
)
FetchContent_MakeAvailable(StereoKitC)

# Add source files to our target executable
target_sources(${PROJECT_NAME} PRIVATE
  src/main.cpp
  src/entrypoint.cpp)

# Link to dependencies
target_link_libraries( ${PROJECT_NAME}
  PRIVATE StereoKitC
)