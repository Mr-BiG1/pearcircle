# peer_circle

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## PeerCircle
PeerCircle is a community-focused mobile application that enables users to connect, share posts, and manage profiles. Designed with Flutter, it provides a seamless user experience for communication and collaboration.

## Features 🌟
- *Authentication*:
User registration and login via Firebase Authentication.
Secure account management with email and password authentication.
- *User Profiles*:
Update profile information, including bio and profile pictures.
Follow and interact with other users.
- *Posts *:
Create, view, and delete posts with text and images.
Fetch posts in real-time with Firebase Firestore.
- *Secure Storage*:
Secure image uploads and file management with Firebase Storage.
- *Light Mode Theme*:
A clean and user-friendly UI designed for optimal readability.

## Technology Stack 🛠
- Frontend: Flutter (Dart)
- Backend: Firebase
- Authentication
- Firestore Database
- Firebase Storage
- Version Control: GitHub
- CI/CD: GitHub Actions (optional for deployment)
  
## Getting Started 🚀
### Prerequisites
*Flutter SDK installed (Flutter installation guide)
Firebase Project (Firebase setup guide)
Android Studio or Visual Studio Code for development.*
Installation
1. Clone the repository:
bash
Copy code
`git clone https://github.com/Mr-BiG1/pearcircle.git`

2. Navigate into the project directory:
    bash
` cd pearcircle`

3. Install dependencies:
bash
Copy code
`flutter pub get`

4. Configure Firebase:

- Add your google-services.json file to android/app/.
- Add your GoogleService-Info.plist file to ios/Runner/.

5.  Run the app:
bash
Copy code
 `flutter run`

### Project Structure

- lib/
- ├── app.dart                    # Root of the application
- ├── config/
- │   └── firebase_options.dart   # Firebase configuration
- ├── features/
- │   ├── auth/                   # Authentication logic
- │   ├── profile/                # User profile management
- │   ├── post/                   # Post creation and management
- │   ├── storage/                # File and image storage
- │   └── theams/                 # Themes and UI styling


## Securityck 🔐
Sensitive files like google-services.json and firebase_options.dart are excluded via .gitignore.
Keys should never be hardcoded or exposed publicly.
If you discover a vulnerability, please report it via GitHub Issues.

### License 📝
This project is licensed under the MIT - - see the [LICENSE](LICENSE).

## Acknowledgements 🙏
- Flutter
- Firebase
