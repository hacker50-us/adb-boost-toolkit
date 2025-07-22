# 📱 Android Boost Toolkit

A professional ADB-based toolkit to optimize your Android device’s **network**, **performance**, and **battery**, for both Unix‐style shells and Windows.

---

## 📝 Features

1. **Automated DNS Benchmark**  
   - Pings Google DNS vs Cloudflare, then configures the faster one.
2. **4G Data Enhancement**  
   - Enables data service without blocking voice calls.
3. **GPU Acceleration**  
   - Forces UI rendering on GPU to relieve CPU.
4. **Light Performance Tests**  
   - Verifies CPU governor & runs a quick stress test.
5. **Battery-saving Tweaks**  
   - Disables auto-sync, forces deep idle, simulates unplug.
6. **Samsung Bloatware Removal**  
   - Disables heavy system apps on Galaxy devices.
7. **Touch & Fingerprint Speed**  
   - Maximizes pointer speed & preserves fingerprint haptics.

---

## 📦 Contents 
adb-boost-toolkit/ ├─ boost_android.sh     # Shell script (Unix/Linux/macOS)
                                  ├─ boost_android.bat    # Batch script (Windows) └── README.md            # This documentation

---

## ⚙️ Requirements

- **ADB** installed and in your PATH  
- **USB Debugging** enabled on your Android device  
- Windows: Tested on Windows 10/11 with Git Bash or native CMD  

---

## 🚀 Installation & Usage

1. **Clone the repo**  
   ```bash
   git clone https://github.com/hacker50-us/adb-boost-toolkit.git
   cd adb-boost-toolkit 

2. On Unix/Linux/macOS

    ```bash
     chmod +x boost_android.sh
     ./boost_android.sh


3. On Windows

Double-click boost_android.bat or run in CMD:

    ```
    
      boost_android.bat




  ---

⚠️ Disclaimer

Use at your own risk. Always back up your data and verify each command. Scripts modify system settings and may behave differently across ROMs or Android versions.


---

🤝 Contributions

Feel free to open issues or PRs for:

Additional device/vendor tweaks

Extended benchmarking (e.g., network jitter, throughput)

Support for other OEM skin services



---

Happy boosting! 🚀
