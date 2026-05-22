# 4-Bit ALU Tester for ESP32

## Upload Instructions

### Windows
Just upload your code. That's it. No additional configuration needed.

### Linux
**One-time setup (do this once):**

1. Run: sudo usermod -a -G dialout $USER
2. Restart your computer

**After setup:** upload normally with pio run --target upload

## Monitor Output
Run: pio device monitor
Press Ctrl + C to exit.

## Folder Structure
Your .cpp file must be inside the src/ folder.

## Common Errors
- **"Permission denied: /dev/ttyUSB0" on Linux** → You skipped the one-time setup. Add yourself to dialout group and restart.

- **"undefined reference to setup/loop"** → Your main .cpp file is not in the src/ folder.

- **Upload stuck at "Connecting..."** → Hold the BOOT button on your ESP32 during upload.