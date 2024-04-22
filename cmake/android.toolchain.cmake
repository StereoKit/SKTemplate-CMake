set(POSSIBLE_NDK_PATHS ${NDK_PATH} $ENV{ANDROID_NDK_HOME} $ENV{NDK_HOME} $ENV{NDK})
find_path(ANDROID_NDK_PATH
    NAMES build/cmake/android.toolchain.cmake
    PATHS ${POSSIBLE_NDK_PATHS}
    NO_DEFAULT_PATH)

if(ANDROID_NDK_PATH)
    message(STATUS "Android NDK found at ${ANDROID_NDK_PATH}")
else()
    message(FATAL_ERROR "Android NDK not found. Please set the NDK_PATH variable, or environment variables ANDROID_NDK_HOME, NDK_HOME, or NDK.")
endif()

# There are two ways to build Android projects, the old deprecated way that
# involves tapping directly into the NDK's toolchain file, or the new way (as
# of cmake 3.21).
#
# The old way, along with the direct reference to the NDK's toolchain file,
# uses a number of ANDROID_ prefixed variables.
#
# The new way looks like this, and only uses CMAKE_ prefixed variables. You can
# find Cmake's docs on this here:
# https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html#cross-compiling-for-android-with-the-ndk
set(CMAKE_SYSTEM_NAME      Android)
set(CMAKE_SYSTEM_VERSION   32)
set(CMAKE_ANDROID_NDK      ${ANDROID_NDK_PATH})
set(CMAKE_ANDROID_ARCH_ABI arm64-v8a)