# InsightEd Mobile Application

## Overview

InsightEd is an offline-first educational management system designed specifically for schools in rural areas with limited internet connectivity. The application provides a comprehensive solution for managing educational workflows with support for multiple user roles (student, teacher, parent, admin) and role-specific dashboards.

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
│   ├── datasources/          # Data sources (local and remote)
│   ├── models/               # Data models
│   └── repositories/         # Repository implementations
├── domain/                    # Domain layer (business logic)
│   ├── entities/             # Business objects
│   ├── repositories/         # Repository interfaces
│   └── usecases/             # Use cases
└── presentation/             # Presentation layer
    ├── bloc/                 # BLoC implementations
    ├── pages/                # UI pages
    └── widgets/              # Reusable widgets
```

## Architecture

The application follows a Clean Architecture approach with the following layers:

1. **Presentation Layer**: UI components and state management
2. **Domain Layer**: Business logic and use cases
3. **Data Layer**: Data sources and repositories
4. **Core Layer**: Shared utilities and configurations

### Data Flow
```
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

## Getting Started

1. Ensure you have Flutter installed on your system
2. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/InsightEdMobileApp.git
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the application:
   ```bash
   flutter run
   ```

## Development Notes

### Recent Updates (June 2023)

1. **Database Improvements**:
   - Fixed database schema inconsistencies in the class management module
   - Resolved column naming mismatch (`grade` vs `grade_level`)
   - Enhanced error handling in database operations

2. **Synchronization Enhancements**:
   - Improved SyncService initialization and lifecycle management
   - Added comprehensive logging for synchronization operations
   - Implemented periodic sync on 15-minute intervals when online
   - Enhanced connectivity detection reliability

3. **General Fixes**:
   - Removed unnecessary splash screen message
   - Improved database transaction handling
   - Added better error reporting during data operations

### Known Issues

1. **Plugin Compatibility**:
   - `file_picker`: Temporarily disabled due to Flutter embedding API compatibility issues
   - `open_file`: Temporarily disabled due to macOS compatibility issues
   - Alternative approaches should be implemented for file operations

2. **Android Build Configuration**:
   - NDK version: 26.0.10792818
   - compileSdk: 35

3. **UI Issues**:
   - Some overflow issues in the dashboard UI need to be addressed

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
