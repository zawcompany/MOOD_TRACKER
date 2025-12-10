✦ Group 2 ✦ 
「 Zahra Amaliah Wildani (D121231100) - Nayla Apriliandita (D121231010) - Nabila Salsabila Akbar S. (D121231061) 」<br>

# 🧠 Mood Tracker
The Mood Tracker application is a Flutter-based mobile platform developed to facilitate self-awareness and emotional regulation in productive age groups. This application systematically combines emotion logging with personalized activity recommendations.

## 🎯 Background & Motivation
This application was developed as the fulfillment of a Final Project for Mobile Programming Course.

"Mental health is a crucial aspect of life quality, especially for productive age groups like students. Unmanaged mood instability can negatively affect productivity, social relations, and overall physical health."

The project aims to:
1. Enhance the ability to recognize and understand emotional patterns through daily logging.
2. Serve as a digital self-reflection tool that promotes self-awareness and emotional regulation.

## ✨ Key Features and Functionalities
The application has a complete set of features for daily emotion management:
1. Full Authentication (Login, Register, Logout): The integrated account security system uses Firebase Authentication.
2. Mood Logging: The core feature for selecting the primary mood category (Bad, Fine, Wonderful) and specific emotions, equipped with a notes/journal option.
3. Mood Prescription (Activity Suggestions): Provides daily activity suggestions that are randomized and personalized according to the last mood, supported by relevant monster icon visualization.
4. Dashboard Overview: Displays the user's mood summary over the last 7 days and the Quote of the Day.
5. Reminder Notifications: A daily reminder system to encourage consistency in mood logging.
6. Update Profile: Feature to update personal information and change the profile picture using URL input (a lightweight solution).
7. Mood Details: A detailed page to view the history and patterns of mood logging in depth.

## 🛠️ Technology Stack
### Frontend
- Flutter SDK
- Dart programming language
- Provider for state management

### Backend Services
- Firebase Authentication for user login.
- Cloud Firestore for data storage (mood entries and profile data).
- Firebase Messaging for push notifications/messaging (FCM).
- Firebase Storage (Listed in dependencies, potentially for future use/assets).

### Key Packages
- `provider` - State management.
- `firebase_core`- Firebase initialization.
- `firebase_auth` - User authentication.
- `cloud_firestore` - Database operations.
- `firebase_messaging` - Push notifications (FCM).
- `flutter_local_notifications` - Local notification handling/reminders.
- `image_picker` - Photo selection logic.
- `intl` - Date and number formatting (digunakan pada dashboard).
- `flutter_launcher_icons` - App icon generation.

## 📁 Project Structure
```
lib/
├── page/                   # UI/Presentation Layer (Screens and Views)
│   ├── dashboard/         # Dashboard Module (Logic, Screens, Widgets)
│   │   ├── domain/        # Data Models (mood_model.dart)
│   │   └── presentation/  # Screens, Widgets, and Providers for Dashboard
│   ├── auth/              # (Implicit: sign_in, sign_up, forgot_password)
│   ├── (screens)          # edit_profile, profile_page, detail_mood, change_password
│   └── widgets/           # Reusable UI components (custom_navbar)
│
├── services/               # Logic Layer (Business Logic & Data Access)
│   ├── auth_service.dart   # Authentication & Profile CRUD
│   ├── mood_service.dart   # Mood logging, Weekly/Daily stream, Prescription Logic
│   ├── notification_service.dart # Handles local notification reminders
│   └── (other services)    # quote_service, reset_new_password_page
│
├── firebase_options.dart   # Firebase configuration file
└── main.dart               # Application entry point and global providers
```

## 🚀 Getting Started
### Prerequisites
1. Flutter SDK (version ^3.9.0 recommended based on pubspec.yaml).
2. Android Studio/VS Code.
3. Configured Firebase Project with Firestore and Authentication enabled.

### Installation Steps
1. Clone this repository
```bash
git clone https://github.com/zawcompany/MOOD_TRACKER
cd MOOD_TRACKER
```

2. Install Dependencies:
```bash
flutter pub get
```

3. Setup Firebase Configuration:
- Place the google-services.json file inside android/app/.

4. Run the App 
```bash
flutter run
```
