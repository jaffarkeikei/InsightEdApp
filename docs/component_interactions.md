# InsightEd Component Interactions

This document provides a detailed view of how specific components in the InsightEd application interact with each other.

## Core Entity Relationships

The following diagram shows the relationships between the core domain entities:

```
┌───────────────┐       ┌───────────────┐       ┌───────────────┐
│     User      │       │     School    │       │  ClassGroup   │
├───────────────┤       ├───────────────┤       ├───────────────┤
│ id            │       │ id            │       │ id            │
│ name          │       │ name          │       │ name          │
│ email         │       │ location      │       │ grade         │
│ role          │◄─────►│ contactInfo   │◄─────►│ teacherId     │
│ schoolId      │       │ adminUserId   │       │ schoolId      │
└───────────────┘       └───────────────┘       └───────────────┘
        ▲                       ▲                      ▲
        │                       │                      │
        │                       │                      │
        │                       │                      │
        ▼                       ▼                      ▼
┌───────────────┐       ┌───────────────┐       ┌───────────────┐
│    Student    │       │    Subject    │       │     Exam      │
├───────────────┤       ├───────────────┤       ├───────────────┤
│ id            │       │ id            │       │ id            │
│ name          │◄─────►│ name          │◄─────►│ title         │
│ studentNumber │       │ code          │       │ subjectId     │
│ classId       │       │ teacherId     │       │ classId       │
│ gender        │       │ description   │       │ date          │
└───────────────┘       └───────────────┘       │ totalMarks    │
        ▲                       ▲               └───────────────┘
        │                       │                      ▲
        │                       │                      │
        │                       │                      │
        ▼                       ▼                      ▼
┌───────────────────────────────────────────────────────────────┐
│                          Result                               │
├───────────────────────────────────────────────────────────────┤
│ id                                                            │
│ studentId                                                     │
│ examId                                                        │
│ subjectId                                                     │
│ marks                                                         │
│ grade                                                         │
│ comments                                                      │
└───────────────────────────────────────────────────────────────┘
                              ▲
                              │
                              │
                              ▼
┌───────────────────────────────────────────────────────────────┐
│                         ReportCard                            │
├───────────────────────────────────────────────────────────────┤
│ id                                                            │
│ studentId                                                     │
│ classId                                                       │
│ term                                                          │
│ year                                                          │
│ results (List<Result>)                                        │
│ totalMarks                                                    │
│ averageGrade                                                  │
│ teacherComments                                               │
│ principalComments                                             │
└───────────────────────────────────────────────────────────────┘
```

## UI Component Hierarchy

The following hierarchy shows how the presentation components are organized:

```
InsightEdApp (main.dart)
├── SplashPage
│   └── [Transitions to either LoginPage or DashboardPage]
├── AuthPages
│   ├── LoginPage
│   └── RegisterPage
└── DashboardPage (Main Container)
    ├── Header
    │   ├── NotificationIcon
    │   ├── UserProfileAvatar
    │   └── SchoolInfo
    ├── NavigationDrawer
    │   ├── MenuItems
    │   └── LogoutButton
    └── ContentArea
        ├── DashboardHomeContent
        │   ├── StatisticsCards
        │   │   ├── StudentCountCard
        │   │   ├── ClassCountCard
        │   │   ├── TeacherCountCard
        │   │   └── ExamCountCard
        │   ├── RecentActivitiesSection
        │   └── PerformanceCharts
        ├── StudentManagementContent
        │   ├── StudentListView
        │   ├── StudentDetailView
        │   └── StudentFormView
        ├── ClassManagementContent
        │   ├── ClassListView
        │   ├── ClassDetailView
        │   └── ClassFormView
        ├── TeacherManagementContent
        │   ├── TeacherListView
        │   ├── TeacherDetailView
        │   └── TeacherFormView
        ├── ExamManagementContent
        │   ├── ExamListView
        │   ├── ExamDetailView
        │   └── ExamFormView
        └── ReportContent
            ├── ReportListView
            ├── ReportDetailView
            └── ReportGenerationView
```

## Data Flow Sequence Diagrams

### Student Registration Flow

```
┌──────────┐      ┌───────────────┐      ┌────────────┐      ┌───────────┐      ┌──────────┐
│  UI/Form │      │StudentProvider│      │ Repository │      │Local Store│      │ Firebase │
└────┬─────┘      └───────┬───────┘      └─────┬──────┘      └─────┬─────┘      └────┬─────┘
     │                    │                    │                   │                 │
     │ Enter Details      │                    │                   │                 │
     │───────────────────>│                    │                   │                 │
     │                    │                    │                   │                 │
     │                    │ Create Student     │                   │                 │
     │                    │───────────────────>│                   │                 │
     │                    │                    │                   │                 │
     │                    │                    │ Save to Local     │                 │
     │                    │                    │──────────────────>│                 │
     │                    │                    │                   │                 │
     │                    │                    │<──Success─────────│                 │
     │                    │                    │                   │                 │
     │                    │                    │ Check Connectivity│                 │
     │                    │                    │─┐                 │                 │
     │                    │                    │ │                 │                 │
     │                    │                    │<┘                 │                 │
     │                    │                    │                   │                 │
     │                    │                    │ If Online: Sync   │                 │
     │                    │                    │───────────────────┼────────────────>│
     │                    │                    │                   │                 │
     │                    │                    │<──────────────────┼──Sync Complete──│
     │                    │                    │                   │                 │
     │                    │<──Student Created──│                   │                 │
     │                    │                    │                   │                 │
     │<─Update UI─────────│                    │                   │                 │
     │                    │                    │                   │                 │
     │                    │                    │                   │                 │
```

### Data Synchronization Flow

```
┌──────────────┐      ┌─────────────┐       ┌───────────┐      ┌──────────┐
│SyncService   │      │ Repository  │       │Local Store│      │ Firebase │
└──────┬───────┘      └──────┬──────┘       └─────┬─────┘      └────┬─────┘
       │                     │                    │                 │
       │ Check Connectivity  │                    │                 │
       │─┐                   │                    │                 │
       │ │                   │                    │                 │
       │<┘                   │                    │                 │
       │                     │                    │                 │
       │ If Online: Start    │                    │                 │
       │                     │                    │                 │
       │ Get Unsynced Data   │                    │                 │
       │────────────────────>│                    │                 │
       │                     │                    │                 │
       │                     │ Get Local Changes  │                 │
       │                     │──────────────────>│                  │
       │                     │                    │                 │
       │                     │<─Local Changes─────│                 │
       │                     │                    │                 │
       │<─Unsynced Items─────│                    │                 │
       │                     │                    │                 │
       │ Push Changes        │                    │                 │
       │─────────────────────┼────────────────────┼────────────────>│
       │                     │                    │                 │
       │ Pull Remote Changes │                    │                 │
       │<────────────────────┼────────────────────┼─────────────────│
       │                     │                    │                 │
       │ Merge Changes       │                    │                 │
       │────────────────────>│                    │                 │
       │                     │                    │                 │
       │                     │ Update Local Store │                 │
       │                     │───────────────────>│                 │
       │                     │                    │                 │
       │                     │<──Update Complete──│                 │
       │                     │                    │                 │
       │<─Sync Complete──────│                    │                 │
       │                     │                    │                 │
       │ Notify UI Components│                    │                 │
       │─┐                   │                    │                 │
       │ │                   │                    │                 │
       │<┘                   │                    │                 │
```

## State Management Patterns

InsightEd uses a combination of Provider and BLoC patterns for state management:

### Provider Pattern (Used for simpler state)

```
┌───────────────┐       ┌───────────────┐       ┌───────────────┐
│    UI Widget  │       │   Provider    │       │  Repository   │
├───────────────┤       ├───────────────┤       ├───────────────┤
│ Consumer<T>   │◄─────►│ ChangeNotifier│◄─────►│  Data Access  │
│ watch/select  │       │ state + logic │       │    Methods    │
└───────────────┘       └───────────────┘       └───────────────┘
```

Example Providers:
- StudentProvider
- ClassProvider 
- AuthProvider
- ThemeProvider

### BLoC Pattern (For complex state flows)

```
┌───────────────┐       ┌───────────────┐       ┌───────────────┐
│    UI Widget  │       │     BLoC      │       │  Repository   │
├───────────────┤       ├───────────────┤       ├───────────────┤
│ BlocBuilder   │──────►│     Event     │──────►│               │
│ BlocListener  │       │      │        │       │  Data Access  │
│               │       │      ▼        │       │    Methods    │
│               │◄──────│     State     │◄──────│               │
└───────────────┘       └───────────────┘       └───────────────┘
```

Example BLoCs:
- SyncBloc (manages synchronization state)
- ReportGenerationBloc (manages complex report generation workflow)
- ExamResultsBloc (manages exam result processing)

## Offline-First Implementation

### Local Database Schema

```
┌─────────────────────┐       ┌─────────────────────┐
│      Students       │       │       Users         │
├─────────────────────┤       ├─────────────────────┤
│ id (PK)             │       │ id (PK)             │
│ name                │       │ name                │
│ student_number      │       │ email               │
│ class_id (FK)       │       │ role                │
│ gender              │       │ password_hash       │
│ date_of_birth       │       │ school_id (FK)      │
│ parent_id           │       │ last_sync           │
│ photo_url           │       │ is_synced           │
│ created_at          │       └─────────────────────┘
│ updated_at          │               ▲
│ is_synced           │               │
└─────────────────────┘               │
        ▲                             │
        │                             │
        │                             │
        │                             │
┌─────────────────────┐       ┌─────────────────────┐
│     ClassGroups     │       │      Schools        │
├─────────────────────┤       ├─────────────────────┤
│ id (PK)             │       │ id (PK)             │
│ name                │       │ name                │
│ grade               │       │ location            │
│ teacher_id (FK)     │◄─────►│ contact_info        │
│ school_id (FK)      │       │ admin_user_id (FK)  │
│ created_at          │       │ created_at          │
│ updated_at          │       │ updated_at          │
│ is_synced           │       │ is_synced           │
└─────────────────────┘       └─────────────────────┘
        ▲                             ▲
        │                             │
        │                             │
┌─────────────────────┐       ┌─────────────────────┐
│      Subjects       │       │       Exams         │
├─────────────────────┤       ├─────────────────────┤
│ id (PK)             │       │ id (PK)             │
│ name                │       │ title               │
│ code                │       │ subject_id (FK)     │
│ teacher_id (FK)     │◄─────►│ class_id (FK)       │
│ description         │       │ date                │
│ created_at          │       │ total_marks         │
│ updated_at          │       │ created_at          │
│ is_synced           │       │ updated_at          │
└─────────────────────┘       │ is_synced           │
        ▲                     └─────────────────────┘
        │                             ▲
        │                             │
        │                             │
┌─────────────────────┐       ┌─────────────────────┐
│      Results        │       │    ReportCards      │
├─────────────────────┤       ├─────────────────────┤
│ id (PK)             │       │ id (PK)             │
│ student_id (FK)     │       │ student_id (FK)     │
│ exam_id (FK)        │◄─────►│ class_id (FK)       │
│ subject_id (FK)     │       │ term                │
│ marks               │       │ year                │
│ grade               │       │ total_marks         │
│ comments            │       │ average_grade       │
│ created_at          │       │ teacher_comments    │
│ updated_at          │       │ principal_comments  │
│ is_synced           │       │ created_at          │
└─────────────────────┘       │ updated_at          │
                              │ is_synced           │
                              └─────────────────────┘
```

## Network Layer Implementation

The application implements a resilient network layer with the following components:

```
┌────────────────────────────────────────────────────────┐
│                   API Service                          │
├────────────────────────────────────────────────────────┤
│ - handleRequest(endpoint, method, data)                │
│ - getDiagnostics()                                     │
└─────────────────────────┬──────────────────────────────┘
                          │
                          ▼
┌────────────────────────────────────────────────────────┐
│                Connectivity Service                    │
├────────────────────────────────────────────────────────┤
│ - checkConnectivity()                                  │
│ - listenToConnectivityChanges()                        │
│ - getLastKnownConnectivity()                           │
└─────────────────────────┬──────────────────────────────┘
                          │
                          ▼
┌────────────────────────────────────────────────────────┐
│                  Request Queue                         │
├────────────────────────────────────────────────────────┤
│ - enqueue(request)                                     │
│ - processQueue()                                       │
│ - retryFailedRequests()                                │
└─────────────────────────┬──────────────────────────────┘
                          │
                          ▼
┌────────────────────────────────────────────────────────┐
│            Firebase/Custom Backend API                 │
└────────────────────────────────────────────────────────┘
```

## Error Handling Strategy

The application implements a comprehensive error handling strategy:

1. **Local Errors**: Handled gracefully within the app
   - Database errors
   - File system errors
   - Invalid input errors

2. **Network Errors**: Managed through retry mechanisms
   - Connection timeout
   - Server errors
   - Authentication errors

3. **Sync Errors**: Resolved through conflict resolution strategies
   - Data version conflicts
   - Deleted record conflicts
   - Constraint violations

4. **UI Error Reporting**: Non-blocking error notifications
   - Toasts for minor errors
   - Alert dialogs for serious errors
   - Error logs for debugging

## Permissions and Access Control

The application implements role-based access control:

```
┌────────────────┐    ┌────────────────┐    ┌────────────────┐    ┌────────────────┐
│  Admin User    │    │  Teacher User  │    │  Student User  │    │  Parent User   │
├────────────────┤    ├────────────────┤    ├────────────────┤    ├────────────────┤
│- Manage all    │    │- View assigned │    │- View own      │    │- View children │
│  users         │    │  classes       │    │  profile       │    │  profiles      │
│- Manage school │    │- Manage        │    │- View own      │    │- View children │
│  settings      │    │  students      │    │  classes       │    │  report cards  │
│- Access all    │    │- Create/grade  │    │- View own      │    │- View children │
│  reports       │    │- Generate      │    │- View          │    │- Communicate   │
│- Full data     │    │- Generate      │    │- View          │    │- Communicate   │
│  management    │    │  reports       │    │  assignments   │    │  with teachers │
└────────────────┘    └────────────────┘    └────────────────┘    └────────────────┘
``` 