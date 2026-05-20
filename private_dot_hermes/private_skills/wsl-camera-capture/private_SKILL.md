---
name: wsl-camera-capture
description: Capture photos or frames from Windows webcams in WSL using Windows-side FFmpeg (dshow) without requiring USBIPD passthrough.
category: media
---

# WSL Camera Capture

Use Windows-installed FFmpeg (via winget) to capture from DirectShow video devices when WSL has no `/dev/video*` devices.

## Trigger
- User requests a photo from the built-in or USB webcam while in WSL.
- Camera shows in Windows Device Manager / `Get-PnpDevice -Class Camera` but not visible in WSL.

## Standard Workflow

1. Locate the Windows FFmpeg binary (winget Gyan.FFmpeg package):
   ```
   $ffmpeg = "C:\Users\<username>\AppData\Local\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-*-full_build\bin\ffmpeg.exe"
   ```

2. List devices to confirm name:
   ```
   & $ffmpeg -list_devices true -f dshow -i dummy
   ```
   Look for the exact string under `[in#0 ...] "Exact Camera Name" (video)`

3. Capture single frame:
   ```
   & $ffmpeg -f dshow -i video="Exact Camera Name" -frames:v 1 -update 1 -y "C:\Users\<username>\Pictures\photo.jpg"
   ```

4. Access the file from WSL at `/mnt/c/Users/<username>/Pictures/photo.jpg`

5. Send via `MEDIA:/mnt/c/...` path in Discord or other platforms.

## Pitfalls
- Winget PATH updates require a fresh PowerShell session after install.
- Always use the full absolute path to `ffmpeg.exe` inside the PowerShell command when called from WSL.
- Use `-update 1` with `-frames:v 1` for single-image output (avoids image sequence pattern errors).
- Camera name must be quoted exactly as shown in the device list.

## References
- `references/acer-fhd-capture.md` — exact device name, full ffmpeg.exe path, and one-shot capture command used in the initial session.
