
set(ANDROID_SDK_PATH "C:/Android") #### This needs to be not hard coded
set(AAPT "${ANDROID_SDK_PATH}/build-tools/${CMAKE_SYSTEM_VERSION}.0.0/aapt2")
# https://developer.android.com/tools/aapt2

set(SOURCE_DIR "${CMAKE_SOURCE_DIR}/src")
set(OUTPUT_DIR "${CMAKE_BINARY_DIR}/output/")

# Create a command to package resources
add_custom_command(
    TARGET ${PROJECT_NAME} POST_BUILD
    #COMMAND ${AAPT} package -f -m -J ${OUTPUT_DIR}/src 
    #        -M ${SOURCE_DIR}/android/AndroidManifest.xml
    #        -S ${SOURCE_DIR}/android/resources
    #        -I ${ANDROID_SDK_PATH}/platforms/android-${CMAKE_SYSTEM_VERSION}/android.jar
    #        -F ${OUTPUT_DIR}/resources.ap_ --auto-add-overlay
    COMMAND ${AAPT} compile --dir ${SOURCE_DIR}/android/resources -o ${CMAKE_BINARY_DIR}/compiled_resources.zip
    COMMAND ${AAPT} link 
        -o ${CMAKE_BINARY_DIR}/${PROJECT_NAME}.apk 
        --manifest ${SOURCE_DIR}/android/AndroidManifest.xml
        -I ${ANDROID_SDK_PATH}/platforms/android-${CMAKE_SYSTEM_VERSION}/android.jar
        ${CMAKE_BINARY_DIR}/compiled_resources.zip
    COMMENT "Running aapt to package resources"
)