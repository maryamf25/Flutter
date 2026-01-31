# DailyPulse - Your News Companion ⚡

A beautiful, modern Flutter news application with real-time news updates from NewsAPI.org. Features include user authentication, article bookmarking, category filtering, and a stunning vibrant UI with glassmorphic effects.

## ✨ Features

### 📱 Core Features
- **Real-time News**: Fetches latest news from NewsAPI.org
- **7 Categories**: Technology, Business, Sports, Health, Science, Entertainment, General
- **Search**: Full-text search across all articles
- **Pull-to-Refresh**: Refresh news with a simple swipe down
- **Saved Articles**: Bookmark articles for offline reading (SharedPreferences)

### 🔐 Authentication
- **Firebase Authentication**: Email/Password based user registration and login
- **Welcome Screen**: 3-second animated splash screen
- **Auto-login**: Persistent sessions with automatic authentication
- **User Profile**: View profile information and logout

### 🎨 Modern UI/UX
- **Vibrant Gradients**: Purple-pink gradient theme (667eea → 764ba2 → f093fb)
- **Glassmorphic Design**: Frosted glass effects on cards and search bar
- **Neon Shadows**: Color-coded shadows based on article category
- **Professional Typography**: Poppins for headings, Inter for body text
- **Magazine Layout**: Beautiful article detail screens with hero images
- **Shimmer Loading**: Smooth skeleton loading animations
- **Smart Author Display**: Publication icons for news sources, initials for authors

### 📊 Bottom Navigation
- **Home**: Browse and search news articles
- **Saved**: View bookmarked articles
- **Profile**: User account management

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (^3.10.4)
- Firebase account (for authentication)
- NewsAPI.org API key (free tier available)
- Dart SDK

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd news_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up NewsAPI**
   - Get your free API key from [NewsAPI.org](https://newsapi.org/)
   - Create a `.env` file in the project root:
     ```
     NEWS_API_KEY=your_api_key_here
     ```

4. **Set up Firebase**
   - Follow the detailed guide in [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
   - Quick steps:
     ```bash
     dart pub global activate flutterfire_cli
     flutterfire configure
     ```
   - Enable Email/Password authentication in Firebase Console

5. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point with Firebase initialization
├── models/
│   └── news.dart               # News article data model
├── providers/
│   └── news_provider.dart      # State management for news data
├── screens/
│   ├── welcome_screen.dart     # 3-second animated splash
│   ├── login_screen.dart       # User login
│   ├── signup_screen.dart      # User registration
│   ├── main_screen.dart        # Bottom navigation container
│   ├── home_screen.dart        # News feed with categories & search
│   ├── article_screen.dart     # Article detail view
│   ├── saved_articles_screen.dart  # Bookmarked articles
│   └── profile_screen.dart     # User profile & settings
├── services/
│   └── news_service.dart       # NewsAPI integration
└── widgets/
    └── news_tile.dart          # Article card component
```

## 🎨 Design System

### Color Palette
- **Primary Gradient**: #667eea → #764ba2 → #f093fb
- **Technology**: #667eea (Purple)
- **Business**: #06d6a0 (Teal)
- **Sports**: #ef476f (Pink Red)
- **Health**: #ab47bc (Purple)
- **Science**: #26c6da (Cyan)
- **Entertainment**: #ff6f91 (Rose)
- **General**: #5c6bc0 (Indigo)

### Typography
- **Headings**: Poppins (600-700 weight)
- **Body**: Inter (400-500 weight)
- **UI Elements**: Poppins (500-600 weight)

### Effects
- **Glassmorphism**: White backgrounds with alpha 0.1-0.2, subtle borders
- **Neon Shadows**: Category-colored shadows with alpha 0.25-0.5, 8-15px blur
- **Gradients**: Linear gradients for app bar, cards, and hero images
- **Border Radius**: 16-24px for modern, friendly feel

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.5+1          # State management
  http: ^1.1.0                # API requests
  flutter_dotenv: ^5.0.2      # Environment variables
  shimmer: ^3.0.0             # Loading animations
  google_fonts: ^6.3.3        # Typography
  firebase_core: ^3.15.2      # Firebase SDK
  firebase_auth: ^5.7.0       # Authentication
  shared_preferences: ^2.3.5  # Local storage
```

## 🔧 Configuration

### Environment Variables (.env)
```
NEWS_API_KEY=your_newsapi_key_here
```

### Firebase
See [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for complete Firebase configuration instructions.

## 📱 Screenshots

*(Add screenshots of your app here)*

- Welcome Screen
- Login/Signup
- Home with categories
- Article detail
- Saved articles
- User profile

## 🛠️ Development

### Run in debug mode
```bash
flutter run
```

### Build for release
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Windows
flutter build windows --release
```

### Run tests
```bash
flutter test
```

## 🌐 API Documentation

This app uses [NewsAPI.org](https://newsapi.org/docs) for fetching news articles.

**Endpoints used:**
- `GET /v2/top-headlines` - Fetch news by category
- `GET /v2/everything` - Search articles

**Rate Limits (Free Tier):**
- 100 requests per day
- No commercial use

## 🚧 Known Issues & Limitations

- NewsAPI free tier limits to 100 requests/day
- Some articles may have missing images or content
- Saved articles stored locally (not synced across devices)

## 🔮 Future Enhancements

- [ ] Dark mode support
- [ ] Share articles to social media
- [ ] Cloud sync for saved articles (Firestore)
- [ ] Push notifications for breaking news
- [ ] Offline reading mode
- [ ] Multiple language support
- [ ] Article comments and discussions

## 📄 License

This project is created for educational purposes as part of the AppVerse Internship program.

## 👥 Contributing

This is an internship project. Contributions are welcome for learning purposes.

## 🙏 Acknowledgments

- NewsAPI.org for providing the news data
- Firebase for authentication services
- Google Fonts for beautiful typography
- Flutter team for the amazing framework

---

**Built with ❤️ using Flutter**
