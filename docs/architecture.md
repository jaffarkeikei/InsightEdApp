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

1. App regularly checks for connectivity
2. When connectivity is established:
   - Local changes are pushed to Firebase/Firestore
   - Remote changes are pulled and integrated with local data
   - Conflicts are resolved based on timestamps and predefined rules

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