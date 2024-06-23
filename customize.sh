#!/sbin/sh
# customize.sh
SKIPMOUNT=false
PROPFILE=true
POSTFSDATA=true
LATESTARTSERVICE=true

  ui_print "*******************************"
  ui_print "        SUNNY TWEAK V3        "
  ui_print "       [t.me/rtmodule]        "  
  ui_print "                              "
  ui_print "*******************************"
  sleep 3
ui_print "                              "
ui_print "*******************************"
ui_print "            CREDITS           "
ui_print "                              "

sleep 2
ui_print " Simple tweak for reliability and stability "
sleep 2
ui_print ""
echo "Feature added" 
echo " - FileSystem Trimmer (Fstrim)✅"
echo " - Smooth GUI v2.1 (RiProG)✅"
echo " - Dalvik Hyperthreading (ModuloStk)✅"
echo " - iOS Keyboard Sound (ModuloStk)✅"
sleep 2

ui_print " initializing KillLogger++ v1.9 " 
ui_print " Love by mrfrost475 "
ui_print "  Special Thanks"
ui_print "  - mrfrost475"
ui_print "  - huan0526"
ui_print "  - Zillot"
ui_print "  - Krapkert"
ui_print "  - Archeix"
ui_print "*******************************"
ui_print " Menambahkan baris ke build.prop "
ui_print " ................................"
ui_print " ................................"

ui_print " Menonaktifkan daemon di system , vendor"
ui_print " ...................................."
ui_print " ...................................."

ui_print " Membersihkan log yang sudah dibuat di data , dev , sys... "
ui_print " ......................................................"

ui_print " Log dinonaktifkan! "
ui_print " Silakan restart perangkat untuk menerapkan efek "
ui_print " please wait till reboot button appears "


# Execute commands from install.sh
on_install() {
  ui_print " Installed"
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
}

# Set permissions (if needed)
set_permissions() {
  set_perm_recursive $MODPATH 0 0 0755 0644
  # Add other set_perm_recursive commands as needed
} 

# Disabling Scheduler statistics
echo "0" > /sys/block/mmcblk0/queue/iostats
echo "0" > /sys/block/mmcblk1/queue/iostats

# Minimize Dropbox Logs to 1
content insert --uri content://settings/global --bind name:s:dropbox_max_files --bind value:i:1 
settings put global dropbox_max_files 1

# Fstrim partitions
fstrim -v /cache; fstrim -v /system; fstrim -v /vendor; fstrim -v /data; fstrim -v /preload