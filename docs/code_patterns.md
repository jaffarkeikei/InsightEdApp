# InsightEd Code Patterns & Implementation Details

This document provides an overview of specific code patterns and implementation details used in the InsightEd application.

## Entity Implementation

Entities are implemented as immutable data classes with the Equatable package for comparison. Example:

```dart
// Student entity implementation
class Student extends Equatable {
  final String id;
  final String name;
  final String studentNumber;
  final String gender;
  final String classId;
  final String className;
  final String? photoUrl;
  final DateTime dateOfBirth;
  final String? parentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Student({
    required this.id,
    required this.name,
    required this.studentNumber,
    required this.gender,
    required this.classId,
    required this.className,
    this.photoUrl,
    required this.dateOfBirth,
    this.parentId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id, name, studentNumber, gender, classId, className,
    photoUrl, dateOfBirth, parentId, createdAt, updatedAt,
  ];

  // Copy with pattern for immutability
  Student copyWith({
    String? id,
    String? name,
    // Other fields...
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      // Other fields...
    );
  }
}
```

## Repository Pattern Implementation

Repositories provide a clean API for data operations and abstract the data source:

```dart
// Repository interface
abstract class StudentRepository {
  Future<List<Student>> getAllStudents();
  Future<Student?> getStudentById(String id);
  Future<void> saveStudent(Student student);
  Future<void> updateStudent(Student student);
  Future<void> deleteStudent(String id);
  Future<List<Student>> getStudentsByClass(String classId);
}

// Repository implementation
class StudentRepositoryImpl implements StudentRepository {
  final StudentLocalDataSource localDataSource;
  final StudentRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  StudentRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Student>> getAllStudents() async {
    // First get local students
    final localStudents = await localDataSource.getAllStudents();
    
    // If online, try to sync with remote
    if (await networkInfo.isConnected) {
      try {
        final remoteStudents = await remoteDataSource.getAllStudents();
        await localDataSource.cacheStudents(remoteStudents);
        return remoteStudents;
      } catch (e) {
        // If remote fetch fails, return cached data
        return localStudents;
      }
    }
    
    return localStudents;
  }

  // Other methods follow similar offline-first pattern...
}
```

## Local Data Source Implementation

```dart
// Local data source using SQLite
class StudentLocalDataSourceImpl implements StudentLocalDataSource {
  final Database database;

  StudentLocalDataSourceImpl({required this.database});

  @override
  Future<List<Student>> getAllStudents() async {
    final List<Map<String, dynamic>> maps = await database.query(
      'students',
      orderBy: 'name ASC',
    );
    
    return List.generate(maps.length, (i) {
      return Student(
        id: maps[i]['id'],
        name: maps[i]['name'],
        studentNumber: maps[i]['student_number'],
        gender: maps[i]['gender'],
        classId: maps[i]['class_id'],
        className: maps[i]['class_name'],
        photoUrl: maps[i]['photo_url'],
        dateOfBirth: DateTime.parse(maps[i]['date_of_birth']),
        parentId: maps[i]['parent_id'],
        createdAt: DateTime.parse(maps[i]['created_at']),
        updatedAt: DateTime.parse(maps[i]['updated_at']),
      );
    });
  }

  @override
  Future<void> cacheStudents(List<Student> students) async {
    final batch = database.batch();
    
    for (var student in students) {
      batch.insert(
        'students',
        {
          'id': student.id,
          'name': student.name,
          'student_number': student.studentNumber,
          'gender': student.gender,
          'class_id': student.classId,
          'class_name': student.className,
          'photo_url': student.photoUrl,
          'date_of_birth': student.dateOfBirth.toIso8601String(),
          'parent_id': student.parentId,
          'created_at': student.createdAt.toIso8601String(),
          'updated_at': student.updatedAt.toIso8601String(),
          'is_synced': 1,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit(noResult: true);
  }

  // Other CRUD operations...
}
```

## Remote Data Source Implementation

```dart
// Remote data source using Firebase
class StudentRemoteDataSourceImpl implements StudentRemoteDataSource {
  final FirebaseFirestore firestore;

  StudentRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<Student>> getAllStudents() async {
    final snapshot = await firestore.collection('students').get();
    
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Student(
        id: doc.id,
        name: data['name'],
        studentNumber: data['studentNumber'],
        gender: data['gender'],
        classId: data['classId'],
        className: data['className'],
        photoUrl: data['photoUrl'],
        dateOfBirth: (data['dateOfBirth'] as Timestamp).toDate(),
        parentId: data['parentId'],
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      );
    }).toList();
  }

  @override
  Future<void> createStudent(Student student) async {
    await firestore.collection('students').doc(student.id).set({
      'name': student.name,
      'studentNumber': student.studentNumber,
      'gender': student.gender,
      'classId': student.classId,
      'className': student.className,
      'photoUrl': student.photoUrl,
      'dateOfBirth': Timestamp.fromDate(student.dateOfBirth),
      'parentId': student.parentId,
      'createdAt': Timestamp.fromDate(student.createdAt),
      'updatedAt': Timestamp.fromDate(student.updatedAt),
    });
  }

  // Other CRUD operations...
}
```

## State Management with Provider

```dart
// Student provider example
class StudentProvider extends ChangeNotifier {
  final StudentRepository repository;
  
  List<Student> _students = [];
  bool _isLoading = false;
  String? _error;
  
  StudentProvider({required this.repository});
  
  // Getters
  List<Student> get students => _students;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Methods
  Future<void> loadStudents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _students = await repository.getAllStudents();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> addStudent(Student student) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await repository.saveStudent(student);
      _students.add(student);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Other CRUD operations...
}
```

## State Management with BLoC

```dart
// Events
abstract class SyncEvent {}

class StartSync extends SyncEvent {}
class SyncCompleted extends SyncEvent {}
class SyncFailed extends SyncEvent {
  final String error;
  SyncFailed(this.error);
}

// States
abstract class SyncState {}

class SyncInitial extends SyncState {}
class SyncInProgress extends SyncState {}
class SyncSuccess extends SyncState {}
class SyncFailure extends SyncState {
  final String error;
  SyncFailure(this.error);
}

// BLoC
class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final SyncService syncService;
  
  SyncBloc({required this.syncService}) : super(SyncInitial()) {
    on<StartSync>(_onStartSync);
    on<SyncCompleted>(_onSyncCompleted);
    on<SyncFailed>(_onSyncFailed);
  }
  
  Future<void> _onStartSync(StartSync event, Emitter<SyncState> emit) async {
    emit(SyncInProgress());
    
    try {
      await syncService.synchronizeData();
      add(SyncCompleted());
    } catch (e) {
      add(SyncFailed(e.toString()));
    }
  }
  
  void _onSyncCompleted(SyncCompleted event, Emitter<SyncState> emit) {
    emit(SyncSuccess());
  }
  
  void _onSyncFailed(SyncFailed event, Emitter<SyncState> emit) {
    emit(SyncFailure(event.error));
  }
}
```

## UI Implementation Patterns

### Responsive Design Pattern

The app uses a responsive design approach to handle different screen sizes:

```dart
// Example of a responsive widget
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 650 &&
      MediaQuery.of(context).size.width < 1100;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    if (isDesktop(context) && desktop != null) {
      return desktop!;
    } else if (isTablet(context) && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}
```

### Form Implementation Pattern

Forms are implemented using the Flutter Form widget with validation:

```dart
// Example student form implementation
class StudentForm extends StatefulWidget {
  final Student? student;
  final Function(Student) onSave;

  const StudentForm({this.student, required this.onSave});

  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _studentNumberController;
  String _selectedGender = 'Male';
  late String _selectedClassId;
  late String _selectedClassName;
  DateTime _dateOfBirth = DateTime.now().subtract(const Duration(days: 365 * 10));

  @override
  void initState() {
    super.initState();
    
    // Initialize with existing student data if editing
    if (widget.student != null) {
      _nameController = TextEditingController(text: widget.student!.name);
      _studentNumberController = TextEditingController(text: widget.student!.studentNumber);
      _selectedGender = widget.student!.gender;
      _selectedClassId = widget.student!.classId;
      _selectedClassName = widget.student!.className;
      _dateOfBirth = widget.student!.dateOfBirth;
    } else {
      _nameController = TextEditingController();
      _studentNumberController = TextEditingController();
      // Default values for new student
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Full Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter student name';
              }
              return null;
            },
          ),
          // More form fields...
          
          ElevatedButton(
            onPressed: _saveStudent,
            child: Text(widget.student == null ? 'Add Student' : 'Update Student'),
          ),
        ],
      ),
    );
  }

  void _saveStudent() {
    if (_formKey.currentState!.validate()) {
      final student = Student(
        id: widget.student?.id ?? const Uuid().v4(),
        name: _nameController.text,
        studentNumber: _studentNumberController.text,
        gender: _selectedGender,
        classId: _selectedClassId,
        className: _selectedClassName,
        dateOfBirth: _dateOfBirth,
        createdAt: widget.student?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      widget.onSave(student);
    }
  }
}
```

## Dependency Injection Pattern

The application uses a simple service locator pattern for dependency injection:

```dart
// Service locator implementation
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();
  
  final Map<String, dynamic> _dependencies = {};
  
  T get<T>() {
    return _dependencies[T.toString()] as T;
  }
  
  void register<T>(T dependency) {
    _dependencies[T.toString()] = dependency;
  }
  
  void registerLazySingleton<T>(T Function() factoryFunc) {
    if (!_dependencies.containsKey(T.toString())) {
      _dependencies[T.toString()] = factoryFunc();
    }
  }
}

// Usage example
void setupDependencies() {
  final locator = ServiceLocator();
  
  // Database
  locator.registerLazySingleton<Database>(() => _initDatabase());
  
  // Data sources
  locator.register<StudentLocalDataSource>(
    StudentLocalDataSourceImpl(database: locator.get<Database>()),
  );
  
  locator.register<StudentRemoteDataSource>(
    StudentRemoteDataSourceImpl(firestore: FirebaseFirestore.instance),
  );
  
  // Network info
  locator.register<NetworkInfo>(
    NetworkInfoImpl(connectivity: Connectivity()),
  );
  
  // Repositories
  locator.register<StudentRepository>(
    StudentRepositoryImpl(
      localDataSource: locator.get<StudentLocalDataSource>(),
      remoteDataSource: locator.get<StudentRemoteDataSource>(),
      networkInfo: locator.get<NetworkInfo>(),
    ),
  );
  
  // Providers
  locator.register<StudentProvider>(
    StudentProvider(repository: locator.get<StudentRepository>()),
  );
}
```

## Navigation Pattern

The application uses Flutter's Navigator 2.0 with Go Router:

```dart
// Router configuration
final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
      routes: [
        GoRoute(
          path: 'students',
          builder: (context, state) => const StudentListPage(),
        ),
        GoRoute(
          path: 'students/:id',
          builder: (context, state) {
            final studentId = state.pathParameters['id']!;
            return StudentDetailPage(studentId: studentId);
          },
        ),
        // Additional nested routes...
      ],
    ),
  ],
);
```

## Offline-First Data Synchronization

The application implements a custom synchronization service:

```dart
class SyncService {
  final ConnectivityService connectivityService;
  final List<Repository> repositories;
  
  SyncService({
    required this.connectivityService,
    required this.repositories,
  });
  
  Future<void> synchronizeData() async {
    if (!await connectivityService.isConnected()) {
      throw Exception('No internet connection available');
    }
    
    for (final repository in repositories) {
      await repository.syncData();
    }
  }
  
  Stream<ConnectivityStatus> get connectivityStream {
    return connectivityService.connectivityStream;
  }
}

// Usage in app initialization
void initSyncService() {
  final syncService = SyncService(
    connectivityService: serviceLocator.get<ConnectivityService>(),
    repositories: [
      serviceLocator.get<StudentRepository>(),
      serviceLocator.get<ClassRepository>(),
      serviceLocator.get<TeacherRepository>(),
      // Other repositories...
    ],
  );
  
  // Set up periodic sync
  Timer.periodic(const Duration(minutes: 15), (_) {
    syncService.synchronizeData().catchError((e) {
      // Handle sync errors
      print('Sync error: $e');
    });
  });
  
  // Listen to connectivity changes
  syncService.connectivityStream.listen((status) {
    if (status == ConnectivityStatus.connected) {
      // Try to sync when connection is established
      syncService.synchronizeData().catchError((e) {
        print('Sync error: $e');
      });
    }
  });
}
```

## Report Generation and PDF Export

The application uses the `pdf` package to generate PDF reports:

```dart
class ReportCardGenerator {
  Future<Uint8List> generateReportCardPdf(ReportCard reportCard, Student student) async {
    final pdf = Document();
    
    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const EdgeInsets.all(32),
        header: (context) {
          return _buildHeader(context, student);
        },
        build: (context) {
          return [
            _buildStudentInfoSection(student),
            SizedBox(height: 20),
            _buildResultsTable(reportCard),
            SizedBox(height: 20),
            _buildCommentsSection(reportCard),
          ];
        },
        footer: (context) {
          return _buildFooter(context);
        },
      ),
    );
    
    return pdf.save();
  }
  
  Widget _buildHeader(Context context, Student student) {
    // Build school header
    return Column(
      children: [
        Text('SCHOOL NAME', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text('Student Report Card', style: TextStyle(fontSize: 16)),
        SizedBox(height: 5),
        Text('Term: ${reportCard.term} - Year: ${reportCard.year}', style: TextStyle(fontSize: 14)),
      ],
    );
  }
  
  // Additional helper methods for building PDF sections...
}
```

## Error Handling and Reporting

The application implements a central error handling mechanism:

```dart
class ErrorHandler {
  final Analytics analytics;

  ErrorHandler({required this.analytics});

  Future<void> handleError(dynamic error, StackTrace stack) async {
    // Log to console in debug mode
    print('Error: $error');
    print('Stack trace: $stack');
    
    // Report to analytics in production
    await analytics.logError(error.toString(), stack);
    
    // Determine error type and appropriate action
    if (error is NetworkException) {
      // Handle network errors
      _showNetworkError(error);
    } else if (error is DatabaseException) {
      // Handle database errors
      _showDatabaseError(error);
    } else {
      // Handle other errors
      _showGenericError(error);
    }
  }
  
  void _showNetworkError(NetworkException error) {
    // Show appropriate UI notification
  }
  
  void _showDatabaseError(DatabaseException error) {
    // Show appropriate UI notification
  }
  
  void _showGenericError(dynamic error) {
    // Show appropriate UI notification
  }
}

// Usage example with zone
void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Set up dependencies
    final errorHandler = ErrorHandler(
      analytics: FirebaseAnalytics.instance,
    );
    
    // Run app
    runApp(const InsightEdApp());
  }, (error, stack) {
    // This catches any uncaught errors in the app
    errorHandler.handleError(error, stack);
  });
}
```

## Authentication Implementation

The application uses both Firebase Auth and local authentication:

```dart
class AuthService {
  final FirebaseAuth _firebaseAuth;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  
  AuthService({
    required FirebaseAuth firebaseAuth,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _firebaseAuth = firebaseAuth,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;
  
  Future<User?> signIn(String email, String password) async {
    // First try local authentication when offline
    if (!await _networkInfo.isConnected) {
      final localUser = await _localDataSource.getUser(email);
      if (localUser != null && await _verifyLocalPassword(password, localUser.passwordHash)) {
        return localUser;
      }
      throw AuthException('Authentication failed');
    }
    
    // Try Firebase authentication when online
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Cache user locally for offline access
      if (credential.user != null) {
        await _cacheUserLocally(credential.user!, password);
      }
      
      return credential.user;
    } catch (e) {
      throw AuthException('Authentication failed: ${e.toString()}');
    }
  }
  
  // Additional authentication methods...
  
  Future<void> _cacheUserLocally(User firebaseUser, String password) async {
    // Hash password for local storage
    final passwordHash = await _hashPassword(password);
    
    // Get additional user info from Firebase
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get();
    
    if (userDoc.exists) {
      final userData = userDoc.data()!;
      
      await _localDataSource.saveUser(
        User(
          id: firebaseUser.uid,
          email: firebaseUser.email!,
          name: userData['name'] ?? firebaseUser.displayName ?? '',
          role: userData['role'] ?? 'user',
          schoolId: userData['schoolId'],
          passwordHash: passwordHash,
        ),
      );
    }
  }
  
  Future<String> _hashPassword(String password) async {
    // Implement secure password hashing
  }
  
  Future<bool> _verifyLocalPassword(String password, String hash) async {
    // Verify password against stored hash
  }
}
```

## Future Considerations and Extension Points

The application's architecture is designed with the following extension points in mind:

1. **Modular Features**: New features can be added by creating new entities, repositories, and UI components without modifying existing code.

2. **API Abstraction**: The network layer can be extended to support different backends by implementing new data sources.

3. **Analytics Integration**: The application can be extended with analytics by adding an analytics service and integrating it with the existing error handling.

4. **Multiple Authentication Providers**: Additional authentication providers can be added by extending the AuthService.

5. **Localization**: The application is structured to support additional languages by adding localization files and using the Flutter localization system. 