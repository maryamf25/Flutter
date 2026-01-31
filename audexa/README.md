
# 🎤 Audexa - Voice Notes App

Enjoy taking voice notes!

---

## ✨ Features

### Core Features
- **Voice Note Recording:** Press and hold the mic button to record. Uses `speech_to_text` for real-time transcription.
- **Save Notes Locally:** Notes are stored with `SharedPreferences`, each with a timestamp and short title.
- **Notes List with Search Bar:** Instantly filter notes by keyword or date.
- **Edit & Delete Notes:** Tap any note to edit or delete.
- **Dark Mode Support:** Toggle between light and dark mode in settings.

### Extra Features
- **Speech-to-text:** Speak and convert to text in real-time.
- **Modern UI:** Clean, responsive design with smooth animations.
- **Unique IDs:** Every note has a unique ID (using `uuid`).
- **Well-Organized Code:** Provider for state management, modular structure.

---

## 🚀 How to Use

1. **Record a Note:** Press and hold the mic button. Speak, and your words appear as text in real time. Release to stop.
2. **Save & Name:** Enter a title and save your note.
3. **Search:** Use the search bar to filter notes by keyword or date.
4. **Edit/Delete:** Tap a note to edit or delete it.
5. **Upload Audio:** Tap the upload button, pick an audio file, and get its transcript.
6. **Dark Mode:** Switch themes anytime from the settings screen.

---

## 🛠️ Tech Stack
- **Flutter** (Dart)
- `speech_to_text` (real-time transcription)
- `shared_preferences` (local storage)
- `provider` (state management)
- `file_picker` (audio upload)
- `uuid`, `intl`, `cupertino_icons`

---

## 📂 Project Structure

```
lib/
  models/         # Note model
  providers/      # State management & logic
  screens/        # UI pages
  widgets/        # Reusable components
  main.dart       # Entry point
```

---


## 📋 Android Permissions
Add these to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.BLUETOOTH"/>
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN"/>
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT"/>
```

---

## ⚡ Getting Started

1. Clone this repo and run `flutter pub get`.
2. Run on a real device for best speech-to-text results.
3. Grant microphone permissions when prompted.
4. Start recording and managing your voice notes!

---

## 📝 Notes
- **Speech-to-Text:** Works best on real devices, not emulators.
- **Permissions:** If denied, enable manually in App Settings.
- **Storage:** Uses SharedPreferences for simplicity and speed.
- **File Upload:** Only mp3/wav files under 5MB are supported for upload.

---

## 💡 Credits
Made with ❤️ using Flutter, by Maryam.
