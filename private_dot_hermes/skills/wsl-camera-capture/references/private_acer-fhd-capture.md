# Acer FHD User Facing Capture (2026-05-16 session)

**Device name (exact):** "Acer FHD User Facing"

**Windows FFmpeg path used:**
```
C:\Users\dante\AppData\Local\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-8.1.1-full_build\bin\ffmpeg.exe
```

**Capture command (PowerShell from WSL):**
```powershell
& 'C:\Users\dante\AppData\Local\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-8.1.1-full_build\bin\ffmpeg.exe' -f dshow -i video="Acer FHD User Facing" -frames:v 1 -update 1 -y "C:\Users\dante\Pictures\hermes_photo.jpg"
```

**Output location (WSL view):**
`/mnt/c/Users/dante/Pictures/hermes_photo.jpg`

**Notes:**
- First winget install of Gyan.FFmpeg succeeded.
- usbipd-win install was attempted first but failed due to missing elevation in non-interactive PowerShell; the dshow route bypassed it entirely.
- Single frame capture succeeded on the second attempt after fixing filename pattern.