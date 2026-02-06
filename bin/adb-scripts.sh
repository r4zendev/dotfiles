adb shell appops set com.android.systemui READ_CLIPBOARD ignore

# Automatic two-way clipboard sync
# adb -d shell pm revoke org.kde.kdeconnect_tp android.permission.READ_LOGS
# adb -d shell appops set org.kde.kdeconnect_tp SYSTEM_ALERT_WINDOW deny
# adb -d shell am force-stop org.kde.kdeconnect_tp
