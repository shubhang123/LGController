# Liquid Galaxy KML Project

This project demonstrates how to upload and display custom KML files on a [Liquid Galaxy](https://github.com/LiquidGalaxy/liquid-galaxy) rig using Flutter and dartssh2. It handles:
- **SSH Connection** and file upload via **SFTP**  
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

1. **SSH & SFTP** using [dartssh2](https://pub.dev/packages/dartssh2).
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
  ├─ assets/
  │   ├─ kml1.kml            # KML for Singapore or any custom location
  │   ├─ kml2.kml            # KML for Monaco / Eiffel Tower or any other place
  │   ...
  ├─ lib/
  │   ├─ main.dart           # Entry point
  │   ├─ services/
  │   │   ├─ ssh_services.dart 
  │   │   └─ lg_service.dart # The core logic for uploading KML, flying, etc.
  │   ├─ screens/
  │   │   └─ settings_page.dart
  │   └─ widgets/
  │       └─ home_page.dart  # Example UI for sending KML, showing logo, etc.
  ├─ pubspec.yaml            # Dependencies + assets declaration
  └─ README.md
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

---

## 5. Usage

### 5.1 Connecting

- On the **settings page**, store your LG IP, port, username, and password in `SharedPreferences`.
- Call `SSHService.shared.connect()` to test the SSH connection.

### 5.2 Sending a KML

- **`sendKML1(context)`** or **`sendKML2(context)`** loads the KML from `assets/kml1.kml` or `assets/kml2.kml`.
- Writes it to a temp file, then **uploads** via `kmlFileUpload`.
- Appends the path to `kmls.txt`.
- Moves the camera to the defined coordinates (using `flyToLookAt` or `flyToSearch`).

### 5.3 Clearing KML

```dart
await lgService.cleanKML();
```
- Clears `kmls.txt` and stops tours by writing `exittour=true` if needed.

### 5.4 Logo Overlay

```dart
await lgService.showLogo();
await lgService.clearLogo();
```

- Writes a simple KML to `slave_3.kml` to show or remove a Liquid Galaxy–branded image overlay.

### 5.5 System Actions

```dart
await lgService.reboot();
await lgService.poweroff();
await lgService.relaunch();
```

- Loops over `screenAmount` (default: 3) to issue `sshpass -p...` commands to each `lgX`.



## 7. References

- **Liquid Galaxy**: <https://github.com/LiquidGalaxy/liquid-galaxy>  
- **Dartssh2**: <https://pub.dev/packages/dartssh2>  
- **SSH + SFTP** Example: Official Dart code samples for SFTP

---

**Enjoy your Liquid Galaxy KML Project!** Feel free to customize coordinates, icons, or KML content to fit your specific use case. If you run into issues, check your console logs for SSH or SFTP errors, and verify your rig is configured to accept remote commands.
