# PlayHub 🎮

A vibrant, multi-game mobile platform built with SwiftUI where users can play three engaging mini-games, track their performance, and explore their gaming locations on an interactive map.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Features](#features)
- [Known Limitations](#known-limitations)
- [Reflection](#reflection)

---

## Overview

**PlayHub** is an iOS application that combines three distinct gaming experiences with comprehensive stat tracking, profile management, and location-based gameplay visualization. The app uses a modern MVVM architecture with SwiftUI for a smooth, responsive user experience.

**Target Platform:** iOS 14+  
**Language:** Swift  
**UI Framework:** SwiftUI  

---

## Architecture

### MVVM Pattern

PlayHub follows the **Model-View-ViewModel (MVVM)** architectural pattern:

```
┌─────────────────────────────────────────────┐
│           PRESENTATION LAYER                │
├─────────────────────────────────────────────┤
│  Views (SwiftUI)                            │
│  ├── HomeTab, StatsTab, MapTab              │
│  ├── ProfileTab, SettingsTab                │
│  └── Game Views (TapFrenzy, LightItUp...)   │
├─────────────────────────────────────────────┤
│           BUSINESS LOGIC LAYER              │
├─────────────────────────────────────────────┤
│  ViewModels (@ObservedObject)               │
│  ├── StatsVM, ProfileVM                     │
│  ├── TapFrenzyVM, LightItUpVM, QuizRushVM   │
│  └── State Management & Logic               │
├─────────────────────────────────────────────┤
│           DATA LAYER                        │
├─────────────────────────────────────────────┤
│  Models                                     │
│  ├── GameMode, GameSession, UserProfile     │
│  ├── TriviaQuestion                         │
│  └── Data Structures                        │
│                                             │
│  Services                                   │
│  ├── LocationService (GPS tracking)         │
│  ├── TriviaAPI (Quiz questions)             │
│  ├── NotificationService (Alerts)           │
│  └── SessionManager (Data persistence)      │
└─────────────────────────────────────────────┘
```

### Project Structure

```
PlayHubApp/
├── App/
│   └── PlayHubApp.swift              # App entry point & tab configuration
├── Models/
│   ├── GameMode.swift                # Enum: Tap Frenzy, Light It Up, Quiz Rush
│   ├── GameSession.swift             # Game session data (score, timestamp, location)
│   ├── TriviaQuestion.swift          # Quiz question model
│   └── UserProfile.swift             # User profile data
├── ViewModels/
│   ├── StatsVM.swift                 # Stats tab logic & data
│   ├── ProfileVM.swift               # Profile management logic
│   ├── TapFrenzyVM.swift             # Tap Frenzy game logic
│   ├── LightItUpVM.swift             # Light It Up game logic
│   └── QuizRushVM.swift              # Quiz Rush game logic
├── Services/
│   ├── LocationService.swift         # GPS & location tracking
│   ├── TriviaAPI.swift               # Fetches trivia questions
│   └── NotificationService.swift     # Local notifications
├── Views/
│   ├── Tabs/
│   │   ├── HomeTab.swift             # Game selection hub
│   │   ├── StatsTab.swift            # Performance tracking
│   │   ├── MapTab.swift              # Interactive game location map
│   │   ├── ProfileTab.swift          # User profile management
│   │   └── SettingsTab.swift         # App settings
│   ├── Games/
│   │   ├── TapFrenzyView.swift       # Tap Frenzy gameplay
│   │   ├── LightItUpView.swift       # Light It Up gameplay
│   │   └── QuizRushView.swift        # Quiz Rush gameplay
│   └── Shared/
│       ├── UIComponents.swift        # Reusable UI components
│       ├── ResultView.swift          # Game result screen
│       └── ScoreBadge.swift          # Score display component
├── Theme/
│   └── AppTheme.swift                # Colors, gradients, typography
└── README.md                         # This file
```

### Key Services

| Service | Responsibility |
|---------|----------------|
| **LocationService** | Requests location permissions, tracks user GPS coordinates for each game session |
| **TriviaAPI** | Fetches trivia questions from external API for Quiz Rush |
| **NotificationService** | Handles in-app notifications and alerts |
| **SessionManager** | Persists game sessions to UserDefaults/local storage |

---

## Features

### 🎮 Games (3 Playable Modes)

#### 1. **Tap Frenzy** ⚡
- Fast-paced tapping game testing reflexes
- Time-based gameplay with score accumulation
- Real-time tap counter and timer display
- High score tracking

#### 2. **Light It Up** 💡
- Memory and observation challenge
- Cards glow in sequence, player must tap the correct one
- Progressive difficulty (speed increases with rounds)
- Visual feedback on correct/incorrect taps

#### 3. **Quiz Rush** ❓
- Trivia questions fetched from external API
- Multiple-choice answers
- Speed-based scoring (faster correct answers = more points)
- Variety of question categories

### 📊 Stats & Analytics

- **Progress Dashboard**: Total games played, cumulative score
- **Personal Bests**: Highest score tracked for each game mode
- **Score History Chart**: Visual bar chart of score progression over time
- **Recent Games Log**: List of last games played with timestamps and scores
- **Game Mode Filtering**: Color-coded by game type for easy identification

### 👤 Profile Management

- **Avatar Selection**: Choose from emoji avatar options
- **User Information**: Name, username, bio, favorite game
- **Profile Persistence**: Saved locally on device
- **Edit/Delete**: Modify or remove profile data
- **Member Since**: Tracks profile creation date

### 🗺️ Location Tracking

- **Interactive Map**: Shows all game session locations
- **Color-Coded Markers**: Each game mode has unique color
- **Location Details**: Score and game mode shown at each marker
- **Permission Handling**: Requests GPS access on first launch
- **Session History**: Visualize gaming journey across locations

### 🎨 User Interface

- **Dark Theme**: Purple and violet color scheme optimized for gaming
- **Tab Navigation**: 5 easy-to-access tabs (Play, Stats, Map, Profile, Settings)
- **Smooth Animations**: Tap feedback, transitions, and visual effects
- **Game Preview Overlay**: Quick preview before starting a game
- **Responsive Design**: Optimized for all iPhone screen sizes

### 📢 Additional Features

- **Daily Challenge Banner**: Featured daily gaming challenges
- **Welcome Tips Banner**: Rotating gameplay tips
- **Toast Notifications**: Success/error feedback messages
- **Empty States**: Helpful prompts when no data exists

---

## Known Limitations

### 🔴 Current Constraints

1. **No Cloud Sync**
   - Game sessions and profiles stored locally only
   - No backup or sync across devices
   - Data lost if app is uninstalled

2. **No Multiplayer**
   - Single-player experience only
   - No leaderboards or competitive features
   - No friend/social integration

3. **No Offline Mode**
   - Quiz Rush requires internet for trivia API
   - Map requires location services
   - Some features may not work without connectivity

4. **Limited Trivia Questions**
   - Quiz Rush depends on external API availability
   - Question variety limited by API response
   - No custom question support

5. **Basic Settings**
   - Settings tab has minimal customization options
   - No sound/music volume control
   - No difficulty settings per game
   - No theme customization (dark theme only)

6. **No Analytics or Achievements**
   - No badge/achievement system
   - Limited stat insights
   - No trend analysis or recommendations

7. **Performance Considerations**
   - Map may lag with hundreds of session markers
   - Large data sets could slow down stats calculations
   - No pagination on recent games list

8. **Testing Limitations**
   - Limited unit test coverage
   - No UI/snapshot tests yet
   - Manual testing required for location features

---

## Reflection

### What Went Well ✅

**MVVM Architecture** — Separating UI from business logic made the codebase clean and testable. Each ViewModel handles its own state independently, making the app scalable.

**SwiftUI Adoption** — Using SwiftUI provided smooth animations and a modern UI with less code. The declarative syntax made building complex layouts intuitive and maintainable.

**Modular Game Design** — Each game is isolated in its own ViewModel and View, making it easy to add new games without affecting existing code.

**Theme System** — Centralizing colors and styling in `AppTheme.swift` creates visual consistency and makes theming changes trivial.

**User Experience** — The dark theme, smooth transitions, and intuitive tab navigation make the app feel polished and professional despite being a learner project.

### Areas for Improvement 🚀

**Data Persistence** — Moving from UserDefaults to CoreData or Realm would provide better performance with large datasets and enable cloud sync capabilities.

**Error Handling** — API calls and location services need more robust error handling and user-facing error messages.

**Testing** — Adding unit tests for ViewModels and UI tests for critical flows would catch bugs early and enable confident refactoring.

**Settings Customization** — Currently minimal. Adding sound toggles, difficulty levels, and notification preferences would enhance user engagement.

**Social Features** — A simple leaderboard or friend comparison would add competitive replay value.

**Performance Optimization** — Lazy loading for charts and pagination for game history could improve responsiveness as data grows.

### Key Learnings 📚

1. **MVVM is powerful** — The separation of concerns made the app maintainable and made testing logic easier (when done).

2. **Location services require care** — Permission handling and privacy considerations are critical for location-based features.

3. **Animation matters** — Small touches like tap feedback and smooth transitions significantly improve perceived app quality.

4. **Simple is better** — Starting with three focused games is better than trying to build ten mediocre ones.

5. **Consistency builds trust** — A unified theme and consistent navigation patterns make apps feel trustworthy and professional.

### Future Roadmap 🗺️

- [ ] Cloud sync with Firebase/iCloud
- [ ] Multiplayer leaderboards
- [ ] Achievement badges system
- [ ] Customizable difficulty levels
- [ ] Sound effects and background music
- [ ] Push notifications for daily challenges
- [ ] Offline mode for games
- [ ] Analytics dashboard for detailed stats
- [ ] Expand to Android with Flutter/React Native
- [ ] In-app purchases for cosmetics

---

## Getting Started

### Prerequisites
- Xcode 13+
- iOS 14+
- Swift 5.5+

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd PlayHub
   ```

2. Open in Xcode:
   ```bash
   open PlayHubApp.xcodeproj
   ```

3. Select target device and run:
   ```
   Cmd + R
   ```

4. On first launch, allow location permission when prompted

### Running Tests

```bash
xcodebuild test -scheme PlayHubApp
```

---

## Contributing

This is a learner project. Contributions and suggestions are welcome!

---

## License

MIT License - See LICENSE file for details

---

**Built with ❤️ by Piyumi Warnakulasuriya**
