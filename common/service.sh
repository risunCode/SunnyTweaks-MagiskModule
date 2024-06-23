#!/system/bin/sh

# Menunggu sampai sys.boot_completed memiliki nilai yang tidak kosong
while [ -z "$(resetprop sys.boot_completed)" ]; do
  sleep 2
done

# Fungsi untuk menunggu boot selesai
boot_wait() {
  while [ -z "$(getprop sys.boot_completed)" ]; do
    sleep 1
  done
}

# Fungsi untuk menonaktifkan process reclaim jika tersedia
disable_process_reclaim() {
  if [ -e /sys/module/process_reclaim/parameters/enable_process_reclaim ]; then
    echo "0" > /sys/module/process_reclaim/parameters/enable_process_reclaim
  fi
}

# Fungsi untuk optimisasi zcache jika tersedia
optimize_zcache() {
  if [ -e /sys/module/zcache/parameters/max_pool_percent ]; then
    echo "100" > /sys/module/zcache/parameters/max_pool_percent
  fi
}

# Fungsi untuk penyesuaian file system
adjust_filesystem() {
  echo "0" > /proc/sys/fs/dir-notify-enable
  echo "2000" > /proc/sys/fs/lease-break-time
  echo "131072" > /proc/sys/fs/aio-max-nr
}

# Fungsi untuk membersihkan logs yang tidak perlu
clean_logs() {
  rm -f /data/anr/* \
        /dev/log/* \
        /data/tombstones/* \
        /data/log_other_mode/* \
        /data/system/dropbox/* \
        /data/system/usagestats/* \
        /data/log/* \
        /sys/kernel/debug/* \
        /data/local/tmp*
}

# Fungsi untuk mengaktifkan wakelock blocker untuk penghematan baterai
enable_wakelock_blocker() {
  if [ -e /sys/class/misc/boeffla_wakelock_blocker/wakelock_blocker ]; then
    echo "wlan_pno_wl;wlan_ipa;wcnss_filter_lock;[timerfd];hal_bluetooth_lock;IPA_WS;sensor_ind;wlan;netmgr_wl;qcom_rx_wakelock;SensorService_wakelock;tftp_server_wakelock;wlan_wow_wl;wlan_extscan_wl;" > /sys/class/misc/boeffla_wakelock_blocker/wakelock_blocker
  fi
}
 
disable_device_admins() {
  pm disable com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver
}
 
enable_doze_services() {
  su -c "pm enable com.google.android.gms/.ads.AdRequestBrokerService"
  su -c "pm enable com.google.android.gms/.ads.identifier.service.AdvertisingIdService"
  su -c "pm enable com.google.android.gms/.ads.social.GcmSchedulerWakeupService"
  su -c "pm enable com.google.android.gms/.analytics.AnalyticsService"
  su -c "pm enable com.google.android.gms/.analytics.service.PlayLogMonitorIntervalService"
  su -c "pm enable com.google.android.gms/.backup.BackupTransportService"
  su -c "pm enable com.google.android.gms/.update.SystemUpdateActivity"
  su -c "pm enable com.google.android.gms/.update.SystemUpdateService"
  su -c "pm enable com.google.android.gms/.update.SystemUpdateService\$ActiveReceiver"
  su -c "pm enable com.google.android.gms/.update.SystemUpdateService\$Receiver"
  su -c "pm enable com.google.android.gms/.update.SystemUpdateService\$SecretCodeReceiver"
  su -c "pm enable com.google.android.gms/.thunderbird.settings.ThunderbirdSettingInjectorService"
  su -c "pm enable com.google.android.gsf/.update.SystemUpdateActivity"
  su -c "pm enable com.google.android.gsf/.update.SystemUpdatePanoActivity"
  su -c "pm enable com.google.android.gsf/.update.SystemUpdateService"
  su -c "pm enable com.google.android.gsf/.update.SystemUpdateService\$Receiver"
  su -c "pm enable com.google.android.gsf/.update.SystemUpdateService\$SecretCodeReceiver"
}

# Fungsi untuk melakukan FSTRIM pada partisi yang ada
perform_fstrim() {
  fstrim -v /system /vendor /data /cache /metadata /odm /system_ext /product
}

# Eksekusi 
boot_wait
disable_process_reclaim
optimize_zcache
sleep 3
adjust_filesystem
clean_logs
enable_wakelock_blocker
disable_device_admins
enable_doze_services
perform_fstrim