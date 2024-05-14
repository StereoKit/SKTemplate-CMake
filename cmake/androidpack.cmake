
set(ANDROID_SDK_PATH "C:/Android") #### This needs to be not hard coded
set(BUILD_TOOLS_PATH "${ANDROID_SDK_PATH}/build-tools/${CMAKE_SYSTEM_VERSION}.0.0")
set(AAPT2    "${BUILD_TOOLS_PATH}/aapt2")
set(AAPT     "${BUILD_TOOLS_PATH}/aapt")
set(ZIPALIGN "${BUILD_TOOLS_PATH}/zipalign")
set(APKSIGN  "${BUILD_TOOLS_PATH}/apksigner")
set(D8       "${BUILD_TOOLS_PATH}/d8")
# https://developer.android.com/tools/aapt2
# https://developer.android.com/build/building-cmdline

# Set default keystore variables
set(DEFAULT_KEYSTORE       "${CMAKE_SOURCE_DIR}/debug.keystore")
set(DEFAULT_KEYSTORE_ALIAS "androiddebugkey")
set(DEFAULT_KEYSTORE_PASS  "android")
set(DEFAULT_KEY_ALIAS_PASS "android")

# Check if keystore variables are provided, otherwise use defaults
set(KEYSTORE       "${DEFAULT_KEYSTORE}"       CACHE STRING "Path to the keystore")
set(KEY_ALIAS      "${DEFAULT_KEYSTORE_ALIAS}" CACHE STRING "Alias for the key")
set(KEYSTORE_PASS  "${DEFAULT_KEYSTORE_PASS}"  CACHE STRING "Password for the keystore")
set(KEY_ALIAS_PASS "${DEFAULT_KEY_ALIAS_PASS}" CACHE STRING "Password for the key")

find_program(KEYTOOL_EXECUTABLE NAMES keytool)
if(NOT EXISTS "${KEYSTORE}")
    message(STATUS "Keystore not found, generating new keystore...")
    execute_process(COMMAND ${KEYTOOL_EXECUTABLE}
        -genkeypair
        -v
        -keystore "${KEYSTORE}"
        -alias "${KEY_ALIAS}"
        -keyalg RSA
        -keysize 2048
        -validity 10000
        -storepass "${KEYSTORE_PASS}"
        -keypass "${KEY_ALIAS_PASS}"
        -dname "CN=Android Debug,O=Android,C=US"
        RESULT_VARIABLE KEYTOOL_RESULT)
    if(NOT KEYTOOL_RESULT EQUAL "0")
        message(FATAL_ERROR "Failed to create keystore")
    endif()
endif()

# Debug message to confirm which keystore is being used
message(STATUS "Using keystore: ${KEYSTORE} with alias ${KEY_ALIAS}")

# This line only works if it is set before the library target is defined.
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib/${CMAKE_ANDROID_ARCH_ABI})
# This will at least catch the project .so if this file is included late.
set_target_properties(${PROJECT_NAME} PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib/${CMAKE_ANDROID_ARCH_ABI})

# If these files exist from a previous build, we get overwrite errors when
# generating the APK.
set(APK_NAME_ROOT ${CMAKE_BINARY_DIR}/${PROJECT_NAME})
file(REMOVE ${APK_NAME_ROOT}.unaligned.apk)
file(REMOVE ${APK_NAME_ROOT}.unsigned.apk)
file(REMOVE ${APK_NAME_ROOT}.signed.apk)

# Create a command to package resources
add_custom_command(
    TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${AAPT2} compile # Zip the resources folder
        --dir ${CMAKE_SOURCE_DIR}/src/android/resources
        -o ${CMAKE_BINARY_DIR}/apk_resources.zip
    COMMAND ${D8} --release ${CMAKE_SOURCE_DIR}/src/android/Empty.class --output ${CMAKE_BINARY_DIR}
    COMMAND ${AAPT2} link # Link all the files into an APK
        -o ${APK_NAME_ROOT}.unaligned.apk 
        --manifest ${CMAKE_SOURCE_DIR}/src/android/AndroidManifest.xml
        -A ${CMAKE_SOURCE_DIR}/assets
        -I ${ANDROID_SDK_PATH}/platforms/android-${CMAKE_SYSTEM_VERSION}/android.jar
        ${CMAKE_BINARY_DIR}/apk_resources.zip
    COMMAND ${AAPT} add ${APK_NAME_ROOT}.unaligned.apk classes.dex
    COMMAND ${AAPT} add ${APK_NAME_ROOT}.unaligned.apk lib/${CMAKE_ANDROID_ARCH_ABI}/$<TARGET_FILE_NAME:${PROJECT_NAME}>
    COMMAND ${ZIPALIGN} 4 ${APK_NAME_ROOT}.unaligned.apk ${APK_NAME_ROOT}.unsigned.apk
    COMMAND ${APKSIGN} sign --ks ${KEYSTORE} --ks-key-alias ${KEY_ALIAS} --ks-pass pass:${KEYSTORE_PASS} --key-pass pass:${KEY_ALIAS_PASS} --out ${APK_NAME_ROOT}.signed.apk ${APK_NAME_ROOT}.unsigned.apk 


    COMMENT "Building an APK"
)