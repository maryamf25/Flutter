# Pokemon App

A Flutter application that displays Pokemon data from the PokeAPI. Browse through different Pokemon, view their details, stats, and images.

## Features

- 📱 Browse Pokemon with a clean, modern UI
- 🔍 View detailed Pokemon information including stats, types, and abilities
- 🎨 Beautiful UI with custom fonts (Google Fonts)
- 💾 Local storage using SharedPreferences
- 🖼️ Cached network images for better performance
- 🌐 Real-time data from PokeAPI

## Dependencies

### Core Dependencies
- **http** (^1.1.0) - For API calls to PokeAPI
- **json_annotation** (^4.9.0) - JSON serialization support
- **shared_preferences** (^2.2.2) - Local data persistence
- **cached_network_image** (^3.3.0) - Efficient image loading and caching
- **google_fonts** (^6.1.0) - Custom font styling

### Dev Dependencies
- **build_runner** (^2.4.6) - Code generation
- **json_serializable** (^6.7.1) - JSON serialization code generation
- **flutter_lints** (^6.0.0) - Recommended lints for Flutter

## Permissions

The app requires the following Android permissions for proper functionality:
- `INTERNET` - Required for fetching Pokemon data from PokeAPI
- `ACCESS_NETWORK_STATE` - To check network connectivity status

## Getting Started

### Prerequisites
- Flutter SDK (3.8.0 or higher)
- Android Studio / Xcode for mobile development
- An internet connection for API calls

### Installation

1. Clone the repository
2. Navigate to the project directory
3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Generate model files:
   ```bash
   flutter pub run build_runner build
   ```

5. Run the app:
   ```bash
   flutter run
   ```

### Building APK

To build a release APK:
```bash
flutter build apk --release
```

For split APKs (smaller file size):
```bash
flutter build apk --split-per-abi
```

## Project Structure

```
lib/
├── main.dart                      # App entry point
├── models/
│   ├── pokemon.dart              # Pokemon data model
│   └── pokemon.g.dart            # Generated JSON serialization
├── screens/
│   ├── welcome_screen.dart       # Initial welcome screen
│   ├── home_screen.dart          # Pokemon list screen
│   └── pokemon_detail_screen.dart # Pokemon details screen
├── services/
│   └── pokemon_service.dart      # API service for Pokemon data
└── widgets/
    └── pokemon_card.dart         # Reusable Pokemon card widget
```

## API

This app uses the [PokeAPI](https://pokeapi.co/) - A free RESTful Pokemon API.

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [PokeAPI Documentation](https://pokeapi.co/docs/v2)
- [Dart Documentation](https://dart.dev/guides)
