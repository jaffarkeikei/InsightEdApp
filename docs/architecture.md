# InsightEd Architecture Overview

## Introduction

InsightEd is an offline-first educational management system designed for schools in rural areas. The application follows Clean Architecture principles, separating concerns into distinct layers:

- **Presentation Layer**: UI components and state management
- **Domain Layer**: Business logic and entities
- **Core Layer**: Shared utilities and constants
- **Data Layer**: Repositories and data sources (local and remote)

## Project Structure

```
lib/
├── main.dart              # App entry point
├── core/                  # Shared utilities, constants, and configs
│   ├── constants/         # App-wide constants
│   ├── theme/             # Theme configuration
│   └── utils/             # Helper functions and extensions
├── domain/                # Business logic and entities
│   └── entities/          # Core business objects
│       ├── student.dart
│       ├── class_group.dart
│       ├── school.dart
│       ├── subject.dart
│       ├── user.dart
│       ├── exam.dart
│       ├── result.dart
│       └── report_card.dart
└── presentation/          # UI components
    ├── components/        # Reusable UI components
    ├── models/            # Presentation-specific models
    ├── pages/             # App screens organized by feature
    │   ├── auth/          # Authentication screens
    │   ├── dashboard/     # Main dashboard screens
    │   ├── students/      # Student management screens
    │   ├── teachers/      # Teacher management screens
    │   ├── classes/       # Class management screens
    │   ├── reports/       # Reporting screens
    │   └── splash/        # App startup screen
    └── widgets/           # Shared UI widgets
```

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                      External Dependencies                      │
│  Firebase Auth, Firebase Storage, Cloud Firestore, Flutter SDK  │
└───────────────────────────────▲───────────────────────────────┬─┘
                                │                               │
                                │                               │
┌───────────────────────────────┴───────────────────────────────▼─┐
│                         Presentation Layer                      │
│                                                                 │
│   ┌─────────────┐   ┌─────────────┐   ┌──────────────────────┐  │
│   │   Screens   │───│   Widgets   │───│  State Management    │  │
│   │  (Pages)    │   │             │   │ (Provider/BLoC)      │  │
│   └─────────────┘   └─────────────┘   └──────────────────────┘  │
└───────────────────────────────▲───────────────────────────────┬─┘
                                │                               │
                                │                               │
┌───────────────────────────────┴───────────────────────────────▼─┐
│                         Domain Layer                            │
│                                                                 │
│                      ┌────────────────────┐                     │
│                      │      Entities      │                     │
│                      │                    │                     │
│                      │  Student, School,  │                     │
│                      │  Class, Subject,   │                     │
│                      │  Exam, Result, etc │                     │
│                      └────────────────────┘                     │
└───────────────────────────────▲───────────────────────────────┬─┘
                                │                               │
                                │                               │
┌───────────────────────────────┴───────────────────────────────▼─┐
│                        Data Layer                               │
│                                                                 │
│   ┌─────────────┐   ┌─────────────┐   ┌──────────────────────┐  │
│   │  Local Data │   │ Repositories│   │    Remote Data       │  │
│   │   (Hive,    │───│             │───│   (Firestore,        │  │
│   │   SQLite)   │   │             │   │   Firebase Storage)  │  │
│   └─────────────┘   └─────────────┘   └──────────────────────┘  │
└───────────────────────────────────────────────────────────────┬─┘
                                                                │
                                                                │
┌───────────────────────────────────────────────────────────────▼─┐
│                          Core Layer                             │
│                                                                 │
│   ┌─────────────┐   ┌─────────────┐   ┌──────────────────────┐  │
│   │  Constants  │   │  Utilities  │   │      Theme           │  │
│   │             │   │             │   │                      │  │
│   └─────────────┘   └─────────────┘   └──────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## Key Components and Their Interactions

### Data Flow

1. **User Interaction**: User interacts with UI components in the Presentation Layer
2. **State Management**: UI events are processed by state management (Provider or BLoC)
3. **Business Logic**: Domain Layer processes the commands and returns results
4. **Data Access**: Data Layer handles data operations:
   - First attempts to perform operations locally (Offline-First)
   - Synchronizes with remote services when connectivity is available

### Offline-First Strategy

InsightEd employs an offline-first strategy using:

- **Hive**: For lightweight persistent storage
- **SQLite**: For structured relational data storage
- **Connectivity Detection**: To determine when to sync with cloud services
- **Conflict Resolution**: Handling data conflicts during synchronization

### Authentication Flow

1. User enters credentials in LoginPage
2. Authentication attempt is made locally first
3. If online, credentials are verified with Firebase Auth
4. User data is cached locally for offline access

### Data Synchronization

### Synchronization Mechanism

InsightEd implements a robust data synchronization system to ensure data consistency between local and remote databases:

1. **Offline-First Approach**: All data operations are performed locally first, ensuring the app works without internet
2. **Change Tracking**: Each database table includes an `is_synced` column to track which records need synchronization
3. **Bidirectional Sync**: Data flows both ways - local to remote and remote to local
4. **Automatic Connectivity Detection**: The app monitors network state and triggers sync when connectivity is available
5. **Periodic Sync**: Scheduled synchronization runs every 15 minutes when online
6. **Error Handling**: Synchronization errors are logged and reported to the user

### Recent Improvements (June 2023)

1. **Database Schema Consistency**: Fixed field naming inconsistencies between domain models and database schema
   - Resolved issue with class creation by aligning column names (`grade` vs `grade_level`)
   - Standardized naming patterns across all entities

2. **SyncService Initialization**: Improved the initialization flow of the SyncService ensuring it starts properly with the application

3. **Repository Synchronization**: Enhanced the syncData() implementation in repositories with better error handling and logging

4. **Connection Monitoring**: Improved the reliability of network state detection and connectivity monitoring

### Synchronization Flow

```
┌─────────────────┐                     ┌─────────────────┐
│                 │   Connectivity      │                 │
│  Local Actions  │────Detected────────►│  SyncService    │
│                 │                     │                 │
└────────┬────────┘                     └────────┬────────┘
         │                                       │
         │ Local                                 │ Process
         │ First                                 │ Each
         │                                       │ Repository
         ▼                                       ▼
┌─────────────────┐                     ┌─────────────────┐
│                 │                     │                 │
│  Local Storage  │◄────────────────────│  Push Unsynced  │
│  (SQLite)       │   Mark as Synced    │  Records        │
│                 │                     │                 │
└────────┬────────┘                     └────────┬────────┘
         │                                       │
         │                                       │
         │                                       │
         ▼                                       ▼
┌─────────────────┐                     ┌─────────────────┐
│                 │                     │                 │
│  Updated Local  │◄────────────────────│  Pull Remote    │
│  Database       │   Cache Records     │  Records        │
│                 │                     │                 │
└─────────────────┘                     └─────────────────┘
```

### Future Synchronization Enhancements

1. **Conflict Resolution**: Implement more sophisticated conflict resolution strategies
2. **Selective Sync**: Allow users to choose which data to prioritize during synchronization
3. **Background Sync**: Implement true background synchronization that works even when app is closed
4. **Sync Progress Indicators**: Provide more detailed feedback on synchronization progress

### Key Features

- **Student Management**: Track student information, attendance, and performance
- **Class Management**: Organize students into classes with assigned teachers
- **Exam Management**: Create, administer, and grade exams
- **Report Generation**: Generate performance reports and report cards
- **Offline Data Access**: Full functionality without internet connection
- **Data Synchronization**: Seamless sync when connectivity is available

## Technology Stack

- **Frontend**: Flutter (Cross-platform UI framework)
- **State Management**: Provider & BLoC
- **Local Storage**: 
  - Hive (NoSQL data storage)
  - SQLite (Relational database)
  - Shared Preferences (Key-value storage)
- **Remote Services**:
  - Firebase Authentication (User authentication)
  - Cloud Firestore (Cloud database)
  - Firebase Storage (Media storage)
- **Utilities**:
  - PDF generation for reports
  - Chart visualization
  - Image handling

## Security Considerations

- Local data is encrypted using secure storage practices
- Authentication tokens are securely stored
- Personal student information is protected with appropriate access controls
- Data sync occurs only on secure connections

## Performance Considerations

- Lazy loading of data
- Pagination for large data sets
- Efficient local caching
- Optimized image loading and caching
- Background synchronization to avoid UI freezes 