# InsightEd Mobile Application

An offline-first educational management system for schools in rural areas.

## Overview

InsightEd provides a comprehensive solution for managing educational workflows in areas with limited internet connectivity. The application supports multiple user roles (student, teacher, parent, admin) with role-specific dashboards.

## Features

- **Offline-first architecture**: Works without an internet connection
- **Multiple role dashboards**: Customized interfaces for students, teachers, parents, and administrators
- **CBC Curriculum Support**: Built around Kenya's Competency-Based Curriculum
- **Data synchronization**: Syncs data when internet is available
- **PDF report generation**: Create and share reports offline

## Development Notes

### Known Issues and Fixes

1. **Plugin Compatibility Issues**:
   - `file_picker` has been temporarily disabled due to compatibility issues with Flutter embedding API
   - `open_file` has been temporarily disabled due to macOS compatibility issues
   - When needed, alternative approaches should be implemented for file selection and opening

2. **Android Build Configuration**:
   - Using NDK version 26.0.10792818
   - compileSdk 35 

3. **UI Issues**:
   - Some overflow issues in the dashboard UI need to be addressed

## Getting Started

1. Make sure to have Flutter installed
2. Clone the repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the application

## Dependencies

See `pubspec.yaml` for a complete list of dependencies.

# InsightEd

![InsightEd Logo](assets/images/logo.png)

## InsightEd: Empowering Education in Rural Kenya

An offline-first, comprehensive educational management system designed specifically for schools in areas with limited internet connectivity.

## Table of Contents
- [Overview](#overview)
- [Architecture Diagram](#architecture-diagram)
- [Key Features](#key-features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [User Roles and Workflows](#user-roles-and-workflows)
- [Offline Functionality](#offline-functionality)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

## Overview

InsightEd is a Flutter-based application designed to address the unique challenges faced by educational institutions in rural Kenya. The system provides a complete school management solution that works primarily offline, with data synchronization capabilities when internet connectivity is available.

The application follows a Clean Architecture approach with feature-first organization, ensuring maintainability, testability, and scalability. It utilizes local storage solutions (Hive, SQLite) for offline data persistence and Firebase for authentication and data synchronization when online.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                             InsightEd Architecture                              │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐    │
│  │                            Presentation Layer                           │    │
│  │                                                                         │    │
│  │  ┌───────────────┐    ┌───────────────┐    ┌───────────────┐            │    │
│  │  │ Admin         │    │ Teacher       │    │ Student       │            │    │
│  │  │ Dashboard     │    │ Dashboard     │    │ Dashboard     │            │    │
│  │  └───────┬───────┘    └───────┬───────┘    └───────┬───────┘            │    │
│  │          │                    │                    │                    │    │
│  │  ┌───────▼────────────────────▼────────────────────▼───────┐            │    │
│  │  │                  Widgets & Components                   │            │    │
│  │  └───────▲────────────────────▲────────────────────▲───────┘            │    │
│  │          │                    │                    │                    │    │
│  │  ┌───────┴───────┐    ┌───────┴───────┐    ┌───────┴───────┐            │    │
│  │  │ BLoC/Provider │    │ BLoC/Provider │    │ BLoC/Provider │            │    │
│  │  │ State Mgmt    │    │ State Mgmt    │    │ State Mgmt    │            │    │
│  │  └───────▲───────┘    └───────▲───────┘    └───────▲───────┘            │    │
│  └──────────┼────────────────────┼────────────────────┼────────────────────┘    │
│             │                    │                    │                         │
│  ┌──────────▼────────────────────▼────────────────────▼────────────────────┐    │
│  │                                Domain Layer                             │    │
│  │                                                                         │    │
│  │  ┌───────────────┐    ┌───────────────┐    ┌───────────────┐            │    │
│  │  │   Use Cases   │    │   Entities    │    │  Repositories │            │    │
│  │  │   (Business   │    │   (Business   │    │  Interfaces   │            │    │
│  │  │    Logic)     │    │    Objects)   │    │               │            │    │
│  │  └───────────────┘    └───────────────┘    └───────▲───────┘            │    │
│  └──────────────────────────────────────────────────────────────────────┬──┘    │
│                                                                         │       │
│  ┌──────────────────────────────────────────────────────────────────────▼──┐    │
│  │                                 Data Layer                              │    │
│  │                                                                         │    │
│  │  ┌───────────────────┐               ┌───────────────────┐              │    │
│  │  │  Local Data       │               │  Remote Data      │              │    │
│  │  │  Sources          │◄─Sync When────►  Sources          │              │    │
│  │  │                   │  Available    │                   │              │    │
│  │  └─────┬─────────────┘               └─────────┬─────────┘              │    │
│  │        │                                       │                        │    │
│  │  ┌─────▼─────────────┐               ┌─────────▼─────────┐              │    │
│  │  │                   │               │                   │              │    │
│  │  │  ┌─────────────┐  │               │  ┌─────────────┐  │              │    │
│  │  │  │    Hive     │  │               │  │  Firebase   │  │              │    │
│  │  │  └─────────────┘  │               │  └─────────────┘  │              │    │
│  │  │  ┌─────────────┐  │               │  ┌─────────────┐  │              │    │
│  │  │  │   SQLite    │  │               │  │Cloud Storage│  │              │    │
│  │  │  └─────────────┘  │               │  └─────────────┘  │              │    │
│  │  │  ┌─────────────┐  │               │  ┌─────────────┐  │              │    │
│  │  │  │  SharedPrefs│  │               │  │ Firestore   │  │              │    │
│  │  │  └─────────────┘  │               │  └─────────────┘  │              │    │
│  │  └───────────────────┘               └───────────────────┘              │    │
│  └─────────────────────────────────────────────────────────────────────────┘    │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐    │
│  │                               Core Layer                                │    │
│  │                                                                         │    │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐        │    │
│  │  │   Utils     │ │  Constants  │ │   Theme     │ │   Config    │        │    │
│  │  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘        │    │
│  │  ┌─────────────┐ ┌─────────────┐ ┌──────────────────────────────┐       │    │
│  │  │   Errors    │ │   Network   │ │   Dependency Injection       │       │    │
│  │  └─────────────┘ └─────────────┘ └──────────────────────────────┘       │    │
│  └─────────────────────────────────────────────────────────────────────────┘    │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘

  OFFLINE WORKFLOW                           ONLINE WORKFLOW
  ┌────────────────┐                        ┌────────────────┐
  │ User Interface │                        │ User Interface │
  └────────┬───────┘                        └────────┬───────┘
           │                                         │
  ┌────────▼───────┐                        ┌────────▼───────┐
  │ Local Storage  │                        │ Local Storage  │
  │ (Primary)      │◄───Sync When Available─►(Cache)         │
  └────────────────┘                        └────────┬───────┘
                                                     │
                                            ┌────────▼───────┐
                                            │ Remote Storage │
                                            │ (Primary)      │
                                            └────────────────┘

  DATA FLOW
  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
  │ UI Event │───►│ BLoC/    │───►│ Use Case │───►│Repository│
  │          │    │ Provider │    │          │    │          │
  └──────────┘    └──────────┘    └──────────┘    └──────────┘
                                                       │
  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌────▼─────┐
  │ UI       │◄───│ BLoC/    │◄───│ Entity   │◄───│Data      │
  │ Update   │    │ Provider │    │ Models   │    │Source    │
  └──────────┘    └──────────┘    └──────────┘    └──────────┘
```

## Key Features

### Role-Based Dashboards
- **Admin Dashboard**: Complete school management with student/teacher management, class creation, analytics, and reporting tools
- **Teacher Dashboard**: Class management, attendance tracking, grading, and report generation capabilities
- **Student Dashboard**: Schedule viewing, assignment submission, and grade checking
- **Parent Dashboard**: Child performance monitoring and communication with teachers

### Educational Management Features
- **Attendance Tracking**: Daily and subject-wise attendance recording and reporting
- **Grade Management**: Record, calculate, and analyze student grades
- **CBC Curriculum Implementation**: Tailored to Kenya's Competency-Based Curriculum
- **Analytics**: Performance trends, comparative analysis, and visual reporting
- **Report Generation**: Detailed academic reports with offline PDF generation
- **Notifications**: In-app notifications for important events

### Technical Features
- **Offline-First Architecture**: All core functionality works without internet
- **Data Synchronization**: Automatic sync when connectivity is available
- **Multi-language Support**: English and Swahili languages
- **Theme Support**: Light and dark theme options
- **Responsive Design**: Works on various devices and screen sizes

## Tech Stack

### Framework & Languages
- **Flutter**: UI framework
- **Dart**: Programming language

### State Management
- **Flutter BLoC**: Complex state management
- **Provider**: Simpler state management cases

### Data Storage
- **Hive**: NoSQL local database for offline storage
- **SQLite**: Relational local database
- **SharedPreferences**: Key-value storage for simple preferences

### Backend & Sync
- **Firebase Authentication**: User authentication
- **Cloud Firestore**: NoSQL cloud database for data synchronization
- **Firebase Storage**: File storage for documents and images

### Other Libraries
- **PDF**: Document generation
- **fl_chart**: Data visualization
- **connectivity_plus**: Network connectivity detection
- **intl**: Internationalization and formatting
- **lottie**: Animations

## Project Structure

InsightEd follows Clean Architecture principles with a feature-first structure:

```
lib/
├── main.dart                  # Application entry point
├── core/                      # Core functionality used across the app
│   ├── constants/             # App-wide constants
│   ├── errors/                # Error handling
│   ├── network/               # Network related utilities
│   ├── theme/                 # App theme definitions
│   └── utils/                 # Utility functions and helpers
├── data/                      # Data layer implementation
│   ├── datasources/           # Data providers (local and remote)
│   ├── models/                # Data models (DTOs)
│   └── repositories/          # Repository implementations
├── domain/                    # Domain layer (business logic)
│   ├── entities/              # Business objects
│   ├── repositories/          # Repository interfaces
│   └── usecases/              # Business use cases
├── injection_container/       # Dependency injection setup
└── presentation/              # UI layer
    ├── bloc/                  # BLoC state management
    ├── components/            # Reusable UI components
    ├── models/                # Presentation models
    ├── pages/                 # Screen definitions
    │   ├── auth/              # Authentication screens
    │   ├── dashboard/         # Dashboard screens
    │   ├── splash/            # Splash screen
    │   ├── classes/           # Class management
    │   ├── students/          # Student management
    │   └── teachers/          # Teacher management
    └── widgets/               # Reusable widgets
```

## Getting Started

### Prerequisites
- Flutter SDK 3.7.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio or VS Code with Flutter extensions
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/insighted.git
   cd insighted
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Firebase** (if using online features)
   - Create a Firebase project
   - Configure Firebase for Flutter
   - Add your google-services.json (Android) and GoogleService-Info.plist (iOS)

4. **Run the application**
   ```bash
   flutter run
   ```

### Configuration
- Environment-specific configuration can be found in `lib/core/config/`
- Adjust settings as needed for your deployment environment

## User Roles and Workflows

### Administrator
1. **Dashboard**: Overview of school statistics
2. **Student Management**: Add, edit, view student profiles
3. **Teacher Management**: Add, edit, view teacher profiles
4. **Class Management**: Create and manage classes
5. **Reports**: Generate and view school-wide reports
6. **Analytics**: View performance metrics and trends

### Teacher
1. **Class Management**: View assigned classes
2. **Attendance**: Record daily attendance
3. **Grading**: Enter and manage student grades
4. **Reports**: Generate class and student reports
5. **Curriculum**: Access and implement CBC curriculum

### Student
1. **Dashboard**: View schedule and announcements
2. **Grades**: View personal academic performance
3. **Assignments**: View and submit assignments

### Parent
1. **Dashboard**: View child's progress
2. **Performance**: Track academic performance
3. **Communication**: Message teachers

## Offline Functionality

InsightEd's offline-first approach ensures core functionality remains available without internet access:

1. **Data Storage**: All data is primarily stored locally
2. **User Authentication**: Local authentication mechanism
3. **PDF Generation**: Reports can be generated and viewed offline
4. **Data Collection**: Attendance, grades, and other data can be recorded offline

When internet becomes available:
1. **Synchronization**: Local data is synced with cloud storage
2. **Updates**: Application updates can be downloaded
3. **Remote Authentication**: User credentials validated against server

## Deployment

### Android
1. Configure app in `android/app/build.gradle`
2. Build release APK: `flutter build apk --release`
3. Build App Bundle: `flutter build appbundle`

### iOS
1. Configure app in Xcode
2. Build for release: `flutter build ios --release`

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

*InsightEd - Empowering Education in Rural Kenya*
