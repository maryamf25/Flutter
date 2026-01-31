# Screenshots Instructions

## 📸 How to Add Screenshots

This folder is for storing app screenshots that are referenced in the main DOCUMENTATION.md file.

### Required Screenshots:

1. **welcome_screen.png** - Animated splash/welcome screen
2. **home_screen.png** - Main Pokémon grid with infinite scroll
3. **detail_screen.png** - Detailed Pokémon information page
4. **loading_state.png** - Loading indicator screen
5. **error_state.png** - Error/no connection screen
6. **offline_mode.png** - Offline mode with snackbar notification

### How to Capture Screenshots:

#### For Android/iOS Emulator:
1. Run the app: `flutter run`
2. Navigate to each screen
3. Press the camera icon in the emulator toolbar, OR
4. Use Flutter DevTools screenshot feature

#### For Physical Device:
1. Connect device: `flutter devices`
2. Run app: `flutter run -d <device-id>`
3. Use device screenshot feature (Power + Volume Down)

#### Using Flutter CLI:
```bash
# Take screenshot of current screen
flutter screenshot
```

### File Naming Convention:
- Use lowercase with underscores
- Match the names referenced in DOCUMENTATION.md
- Save as PNG for best quality

### Recommended Resolution:
- **Portrait:** 1080x1920 or device native resolution
- **File Size:** Keep under 2MB per image

---

**Note:** After adding screenshots, the documentation will display them automatically with the placeholder paths already configured.
