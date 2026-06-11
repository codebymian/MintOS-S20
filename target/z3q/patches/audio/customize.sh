BLOBS_LIST="
lib/android.hardware.audio.common@5.0-util.so
lib/hw/android.hardware.audio.effect@5.0-impl.so
lib/hw/android.hardware.audio@5.0-impl.so
lib64/android.hardware.audio.common@5.0-util.so
lib64/hw/android.hardware.audio.effect@5.0-impl.so
lib64/hw/android.hardware.audio@5.0-impl.so
"
for blob in $BLOBS_LIST
do
    DELETE_FROM_WORK_DIR "vendor" "$blob"
done


# S20 Series -> SoundBooster 1050
LOG_STEP_IN "- Replacing SoundBooster"
DELETE_FROM_WORK_DIR "system" "system/lib64/lib_SoundBooster_ver1100.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/lib_SAG_EQ_ver1100.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/libsamsungSoundbooster_plus_legacy.so"

ADD_TO_WORK_DIR "pa3qxxx" "system" "system/lib64/libvoice_booster.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "pa3qxxx" "system" "system/lib64/lib_sag_ai_sound_sep_v1.00.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "pa3qxxx" "system" "system/lib64/lib_SAG_EQ_ver2060.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "pa3qxxx" "system" "system/lib64/libSAG_VM_Energy_v300.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "pa3qxxx" "system" "system/lib64/libSAG_VM_Score_V300.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "pa3qxxx" "system" "system/lib64/lib_SoundAlive_play_plus_ver900.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "pa3qxxx" "system" "system/etc/audio_effects_common.conf" 0 0 644 "u:object_r:system_file:s0"
LOG_STEP_OUT
