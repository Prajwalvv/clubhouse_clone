# Clubhouse Clone

A Flutter-based clone of the Clubhouse audio chat app with Firebase integration. This project replicates the core features of Clubhouse, including live rooms, user roles, and real-time interaction — designed with scalability and performance in mind.

## Project Overview

This project is a clone of the Clubhouse audio chat application, built using Flutter and Firebase. The app implements a phone-based authentication system, an invite-only user registration, club creation, and user profiles.

## Current Development Status

The app is currently in development with the following features implemented:

- **Authentication System**: Phone number authentication using Firebase Auth
- **Invite-Only System**: Users can only join if they have been invited by an existing user
- **User Profiles**: Basic user profile management
- **Club Creation**: Users can create clubs with various settings
- **Category Management**: Clubs can be categorized

## Features

### Implemented Features

1. **Phone Authentication**
   - OTP-based verification
   - User session management

2. **Invite System**
   - Each user gets 5 invites
   - Users can only join if invited
   - Tracking of invites sent

3. **Club Creation**
   - Create discussion topics
   - Select categories
   - Add speakers
   - Schedule date and time
   - Set privacy (Public/Private)

4. **User Management**
   - Basic profile information
   - Invitation tracking

### Pending Features

1. **Audio Chat Functionality**
2. **Real-time Discussions**
3. **Club Exploration**
4. **Enhanced User Profiles**
5. **Notifications System**

## Project Structure

```
lib/
├── Services/
│   └── authenticate.dart
├── constants/
├── main.dart
├── models/
│   ├── rootPage.dart
│   └── userModel.dart
├── screens/
│   ├── authScreen.dart
│   ├── createAclub.dart
│   ├── homeScreen.dart
│   ├── inviteScreen.dart
│   ├── notInvitedScreen.dart
│   ├── phone/
│   └── profileScreen.dart
├── utils/
└── widgets/
    └── getTheTitle.dart
```

## Technical Stack

- **Frontend**: Flutter (SDK >=2.12.0 <3.0.0)
- **Backend**: Firebase
  - Firebase Authentication
  - Cloud Firestore
- **Dependencies**:
  - cupertino_icons: ^1.0.2
  - cloud_firestore: ^2.2.1
  - firebase_core: ^1.3.0
  - firebase_auth: ^1.4.1
  - dropdown_search: ^0.6.3
  - date_time_picker: ^2.0.0

## Setup Instructions

### Prerequisites

- Flutter SDK
- Firebase account
- Android Studio or VS Code with Flutter extensions

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd clubhouse
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project
   - Add Android and iOS apps to your Firebase project
   - Download and replace the configuration files:
     - For Android: Replace `android/app/google-services.json`
     - For iOS: Replace `ios/Runner/GoogleService-Info.plist`
   - **Important**: Make sure to remove any API keys before committing to GitHub

4. **Run the app**
   ```bash
   flutter run
   ```

## Database Structure

### Firestore Collections

1. **users**
   - name: String
   - phone: String
   - uid: String
   - invitesLeft: int
   - invitesAllowed: int

2. **invites**
   - invitee: String (phone number)
   - invitedBy: String (phone number)
   - date: Timestamp

3. **clubs**
   - title: String
   - category: String
   - createdBy: String (phone number)
   - invited: Array of Maps (name, phone)
   - createdOn: Timestamp
   - dateTime: Timestamp
   - type: String (Public/Private)
   - status: String

4. **categories**
   - title: String

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is for educational purposes only.

---

**Note**: This is a clone project created for learning purposes and is not affiliated with the official Clubhouse application.
