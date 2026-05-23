# ==============================================================================
#
# MOD_NAME="Bluetooth library patcher"
# MOD_AUTHOR="3arthur6 & duhansysl (AstroROM adaptation)"
# MOD_DESC="Fixes Bluetooth JNI issues for MintOS source (skip missing sequences)."
#
# ==============================================================================

# Extract libbluetooth_jni.so if missing
if [ ! -f "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" ]; then
    LOG_STEP_IN "- Extracting libbluetooth_jni.so from com.android.bt.apex"

    [ -d "$TMP_DIR" ] && EVAL "rm -rf \"$TMP_DIR\""
    mkdir -p "$TMP_DIR"

    EVAL "unzip -j \"$WORK_DIR/system/system/apex/com.android.bt.apex\" \"apex_payload.img\" -d \"$TMP_DIR\""

    if ! sudo -n -v &> /dev/null; then
        LOG "\033[0;33m! Asking user for sudo password\033[0m"
        if ! sudo -v 2> /dev/null; then
            ABORT "Root permissions are required to unpack APEX image"
        fi
    fi

    mkdir -p "$TMP_DIR/tmp_out"
    EVAL "sudo mount -o ro \"$TMP_DIR/apex_payload.img\" \"$TMP_DIR/tmp_out\""
    EVAL "sudo cat \"$TMP_DIR/tmp_out/lib64/libbluetooth_jni.so\" > \"$WORK_DIR/system/system/lib64/libbluetooth_jni.so\""

    EVAL "sudo umount \"$TMP_DIR/tmp_out\""
    rm -rf "$TMP_DIR"

    SET_METADATA "system" "system/lib64/libbluetooth_jni.so" 0 0 644 "u:object_r:system_lib_file:s0"

    LOG_STEP_OUT
fi

# Apply hex patches based on API level
if [ "$SOURCE_API_LEVEL" -eq 33 ]; then
    HEX_PATCH "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" \
        "6804003528008052" "2a00001428008052" || LOG "- Skipping missing pattern for SDK 33"

elif [ "$SOURCE_API_LEVEL" -eq 34 ]; then
    HEX_PATCH "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" \
        "6804003528008052" "2b00001428008052" || LOG "- Skipping missing pattern for SDK 34"

elif [ "$SOURCE_API_LEVEL" -eq 35 ]; then
    HEX_PATCH "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" \
        "480500352800805228" "530100142800805228" || LOG "- Skipping missing pattern for SDK 35"

elif [ "$SOURCE_API_LEVEL" -eq 36 ]; then
    HEX_PATCH "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" \
        "00122a0140395f01086b00020054" "00122a0140395f01086bde030014" || LOG "- Skipping missing pattern (1/5)"
    HEX_PATCH "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" \
        "2897773948050037" "289777392a000014" || LOG "- Skipping missing pattern (2/5)"
    HEX_PATCH "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" \
        "183a009048050037" "183a00902a000014" || LOG "- Skipping missing pattern (3/5)"
    HEX_PATCH "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" \
        "3a009048050037330080" "3a00902a000014330080" || LOG "- Skipping missing pattern (4/5)"
    HEX_PATCH "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" \
        "f6713948050037330080" "f671392a000014330080" || LOG "- Skipping missing pattern (5/5)"

else
    LOG "\033[0;33m! Unsupported SDK/API level: $SOURCE_API_LEVEL — skipping Bluetooth patch\033[0m"
fi
