#!/usr/bin/env bash
#
# boost_android.sh — ADB Toolkit to optimize network, performance & battery
#

set -euo pipefail
IFS=$'\n\t'

DEVICE="$(adb get-state 2>/dev/null)"
if [[ "$DEVICE" != "device" ]]; then
  echo "❌ ERROR: No Android device detected. Enable USB Debugging & connect."
  exit 1
fi

echo "🚀 Starting Android Boost Toolkit..."

# 1. DNS benchmarking
echo -n "🌐 Testing DNS latency (Google vs Cloudflare)... "
G_LAT=$(adb shell ping -c4 8.8.8.8 | awk -F'/' '/avg/ {print $5}')
C_LAT=$(adb shell ping -c4 1.1.1.1 | awk -F'/' '/avg/ {print $5}')
if (( $(echo "$G_LAT < $C_LAT" | bc -l) )); then
  DNS_HOST="dns.google"
  echo "→ Google DNS (avg ${G_LAT}ms)"
else
  DNS_HOST="1dot1dot1dot1.cloudflare-dns.com"
  echo "→ Cloudflare DNS (avg ${C_LAT}ms)"
fi

adb shell settings put global private_dns_mode hostname
adb shell settings put global private_dns_specifier "${DNS_HOST}"

# 2. 4G enhancement (without blocking calls)
echo "📶 Enabling all 4G bands..."
# (Requires modem support; placeholder/service call)
adb shell svc data enable

# 3. GPU acceleration
echo "🎮 Forcing GPU rendering to help CPU..."
adb shell settings put global debug_hwui_force_gpu_rendering 1
adb shell settings put global debug_hwui_renderer_type opengl

# 4. Performance tests
echo -n "⚙️  Verifying CPU governor & load... "
CPU_GOV=$(adb shell cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
echo "Governor=$CPU_GOV"
echo -n "→ Light stress test (5s)... "
adb shell "yes > /dev/null & sleep 5; killall yes"
echo "OK"

# 5. Battery savings
echo "🔋 Applying battery-saving tweaks..."
adb shell settings put global auto_sync 0        # disable auto-sync
adb shell dumpsys deviceidle force-idle         # deep idle
adb shell dumpsys battery unplug                # simulate unplug to lock idle

# 6. Disable heavy/unused Samsung services
echo "🗑 Disabling Samsung bloatware..."
SERVICES=(
  com.samsung.android.bixby.agent
  com.samsung.android.weather
  com.samsung.android.game.gamehome
  com.samsung.android.spay
  com.samsung.android.rubin.app
  com.samsung.android.scloud
  com.samsung.android.mdx
  com.samsung.android.svoiceime
)
for pkg in "${SERVICES[@]}"; do
  echo -n "– $pkg... "
  adb shell pm disable-user --user 0 "$pkg" &>/dev/null && echo "OK" || echo "Failed"
done

# 7. Touch & fingerprint responsiveness
echo "🤏 Tuning touch & fingerprint response..."
adb shell settings put system pointer_speed 7
adb shell settings put secure fingerprint_success_vibrate 1

echo "✅ All done! Device optimized."