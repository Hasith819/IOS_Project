# PlayHub iOS Game App

## Architecture Overview

PlayHub is a SwiftUI based iOS application that contains multiple mini games. 
The app is developed using the MVVM (Model-View-ViewModel) architecture pattern.

The project is divided into different folders to keep the code clean and organized.

### App
The App folder contains the main application files. 
`PlayHubApp.swift` is the starting point of the application and loads the main tab navigation. 
`AppTabShellView.swift` manages the four main tabs of the app.

### Models
The Models folder contains the data structures used in the application.

- `GameSession` stores completed game details such as game type, score, date, and location.
- `LocationGroup` is used to group game sessions by location.
- `TriviaQuestion` contains the quiz question data received from the API.

### Views
The Views folder contains all user interface screens.

There are two main sections:

**Games**
- Tap Frenzy
- Light It Up
- Quiz Rush
- Game Over screen

**Tabs**
- Home
- Stats
- Map
- Settings

Views are responsible only for displaying information and handling user interaction.

### ViewModels
ViewModels contain the main logic of the application.

Each game has its own ViewModel:

- `TapFrenzyVM` controls the tapping game logic.
- `LightItUpVM` controls card levels, timer, and scoring.
- `QuizRushVM` manages questions, answers, timer, and scoring.

Other ViewModels:

- `HomeVM` manages daily challenges.
- `StatsVM` calculates game statistics.
- `MapVM` manages map data.
- `SettingsVM` handles notifications and resetting data.

### Services
Services handle external functions and data management.

- `GameSessionStore` saves and loads game history using UserDefaults.
- `LocationService` gets the current user location.
- `NotificationService` creates daily challenge reminders.
- `TriviaApiService` connects with Open Trivia API to get quiz questions.

### Shared Components
The Shared folder contains reusable UI components.

- `GameBackground` provides an animated background for games.
- `MenuBackground` provides the background design for menu screens.

---

# Features List

## Multiple Mini Games

### Tap Frenzy
- Player taps the moving button to increase the score.
- Includes combo scoring system.
- Button position and color change during the game.
- Saves the highest score.

### Light It Up
- Player needs to tap the highlighted cards.
- Contains four difficulty levels.
- Speed increases with each level.
- Saves the highest score.

### Quiz Rush
- Loads questions from Open Trivia API.
- Includes a countdown timer for each question.
- Provides score and streak system.
- Shows correct and incorrect answers.

## Home Screen
- Shows all available games.
- Displays daily challenge.
- Shows high scores for each game.

## Statistics
- Shows total played games.
- Displays best scores.
- Shows recent game history.
- Includes score charts.

## Map Feature
- Saves game locations using GPS.
- Displays played locations on Apple Map.
- Shows games played at each location.

## Notification System
- Allows users to enable daily challenge reminders.
- Users can select reminder time.

## Data Storage
- Saves game sessions and high scores locally.
- User data remains available after closing the app.

---

# Known Limitations

- The application stores data only on the local device. Data cannot be synchronized between multiple devices.
- Map locations depend on GPS accuracy and internet availability.
- Quiz questions depend on the Open Trivia API, so questions cannot load if the API is unavailable.
- The application currently supports only the included three games.
- No user account system is available.
- Notifications depend on user permission.
- Some UI designs may need more improvements for different screen sizes.

---

# Reflection

