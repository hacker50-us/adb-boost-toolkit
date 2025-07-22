@echo off
rem ===============================================
rem boost_android.bat — Windows ADB Toolkit
rem ===============================================
chcp 65001 >nul

:checkADB
adb get-state 2>nul | findstr /R /C:"device" >nul
if errorlevel 1 (
  echo ❌ ERROR: No device detected. Enable USB Debugging.
  goto :eof
)

echo 🚀 Starting Android Boost Toolkit...

rem 1. DNS benchmarking
for /f "tokens=*" %%A in ('adb shell ping -c4 8.8.8.8 ^| findstr avg') do set "G_LINE=%%A"
for /f "tokens=*" %%A in ('adb shell ping -c4 1.1.1.1 ^| findstr avg') do set "C_LINE=%%A"
for /f "tokens=5 delims=/" %%x in ("%G_LINE%") do set G_LAT=%%x
for /f "tokens=5 delims=/" %%x in ("%C_LINE%") do set C_LAT=%%x

if %G_LAT% LSS %C_LAT% (
    set DNS_HOST=dns.google
    echo → Google DNS (%G_LAT%ms)
) else (
    set DNS_HOST=1dot1dot1dot1.cloudflare-dns.com
    echo → Cloudflare DNS (%C_LAT%ms)
)

adb shell settings put global private_dns_mode hostname
adb shell settings put global private_dns_specifier %DNS_HOST%

rem 2. 4G enhancement
echo 📶 Enabling 4G data...
adb shell svc data enable

rem 3. GPU acceleration
echo 🎮 Forcing GPU rendering...
adb shell settings put global debug_hwui_force_gpu_rendering 1
adb shell settings put global debug_hwui_renderer_type opengl

rem 4. Performance tests
echo ⚙️  Checking CPU governor...
for /f "tokens=*" %%G in ('adb shell type /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor') do echo Governor=%%G

echo ⚙️  Light stress test (5s)...
adb shell "yes > /dev/null & timeout 5 & taskkill /IM yes.exe /F"

rem 5. Battery savings
echo 🔋 Applying battery-saving tweaks...
adb shell settings put global auto_sync 0
adb shell dumpsys deviceidle force-idle
adb shell dumpsys battery unplug

rem 6. Disable Samsung bloatware
echo 🗑 Disabling Samsung bloatware...
set PACKAGES=com.samsung.android.bixby.agent com.samsung.android.weather com.samsung.android.game.gamehome ^
 com.samsung.android.spay com.samsung.android.rubin.app com.samsung.android.scloud ^
 com.samsung.android.mdx com.samsung.android.svoiceime
for %%P in (%PACKAGES%) do (
  echo – %%P...
  adb shell pm disable-user --user 0 %%P
)

rem 7. Touch & fingerprint
echo 🤏 Tuning touch & fingerprint response...
adb shell settings put system pointer_speed 7
adb shell settings put secure fingerprint_success_vibrate 1

echo ✅ All done! Device optimized.
pause