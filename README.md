# Liquid Galaxy Controller

This project demonstrates how to upload and display custom KML files on a [Liquid Galaxy](https://github.com/LiquidGalaxy/liquid-galaxy) rig using Flutter and dartssh2(for the Task 2 for Liquid Galaxy for GSoC 2025). It handles:
- **SSH Connection**  
- **Clearing existing KML** from Google Earth  
- **Showing a logo overlay** on a specified screen  
- **Sending KML from Flutter assets** to the rig  
- **Flying** Google Earth to coordinates  
- **Rebooting / Powering off** the rig screens

---

## 1. Project Overview

In a typical Liquid Galaxy setup, you have one or more screens (lg1, lg2, lg3...) that run Google Earth. This Flutter app:

- **Connects** via SSH to `lg1`.
- **Uploads** KML files to `/var/www/html/`.
- **Updates** `kmls.txt` so Google Earth knows about the new KML files.
- **Can** issue commands to Google Earth’s query interface (e.g. `/tmp/query.txt`) to fly the camera or perform searches.
- **Allows** you to show or remove a logo overlay, or **reboot** / **power off** all screens in the rig.

---

## 2. Key Features

1. **uses [dartssh2](https://pub.dev/packages/dartssh2)**.
2. **KML Upload** from Flutter `assets/` or local temp file.
3. **KML Control**: Clear, run, or append to `kmls.txt`.
4. **Camera** movement: 
   - `search=lat,lon` 
   - or `flytoview=<LookAt>` for more precise control
5. **System** actions: `relaunch()`, `poweroff()`, `reboot()`
6. **Logo Overlay**: Show/clear an image overlay on a specific screen (default: `slave_3`).

---

## 3. Folder Structure

```
my_flutter_app/
  ├── lib/
  │   ├── main.dart                # Entry point for Flutter app
  │   ├── models/
  │   │   ├── config.dart          # Possibly storing app config or user credentials
  │   │   └── kml_helper.dart      # Helper model or parser for KML
  │   ├── pages/
  │   │   ├── control/             # UI pages that control LG (buttons, commands)
  │   │   │   └── control_page.dart
  │   │   ├── manage/              # UI pages for management tasks (e.g. KML list, screen mgmt)
  │   │   │   └── manage_page.dart
  │   │   └── settings/            # UI pages for SSH settings or preferences
  │   │       └── settings_page.dart
  │   ├── services/
  │   │   ├── ssh_service.dart     # Manages SSH connection (host, port, username, password)
  │   │   └── lg_service.dart      # Liquid Galaxy logic (send KML, fly coords, power off, etc.)
  │   └── widgets/
  │       └── custom_button.dart   # Reusable widget examples
  ├── assets/
  │   ├── kml1.kml                 # Example KML for location 1
  │   └── kml2.kml                 # Example KML for location 2
  ├── pubspec.yaml                 # Flutter dependencies + assets references
  └── README.md

```

- **`assets/kml1.kml`** and **`assets/kml2.kml`** are sample KML files you can display on Liquid Galaxy.
- **`services/ssh_services.dart`** manages the SSH connection.
- **`services/lg_service.dart`** uses an existing SSHClient to handle KML logic (upload, run, show logo, etc.).

---

## 4. Setup Instructions

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```
2. **Declare assets** in `pubspec.yaml`:
   ```yaml
   flutter:
     assets:
       - assets/kml1.kml
       - assets/kml2.kml
   ```
3. **Adjust credentials** in your code:
   - `ssh_services.dart` expects `ipAddress`, `port`, `username`, and `password` from `SharedPreferences`.
   - Make sure they match your Liquid Galaxy rig (e.g., `lg1` with IP `192.168.1.10`, `port=22`, `username=lg`, `password=YOURPASSWORD`).
4. **Ensure** `sshpass` is installed on each screen (`lgX`) if you plan to use the poweroff/reboot commands that do `sshpass -p "$pw" ssh ...`.
5. **Run** the app in **Android Studio** or **VS Code** (or via `flutter run`).


## 5. References

- **Liquid Galaxy**: <https://github.com/LiquidGalaxy/liquid-galaxy>  
- **Dartssh2**: <https://pub.dev/packages/dartssh2>  
- **SSH + SFTP** Example: Official Dart code samples for SFTP

---
