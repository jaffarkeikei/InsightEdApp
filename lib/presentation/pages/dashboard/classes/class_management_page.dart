import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';
import 'package:insighted/core/services/service_locator.dart';
import 'package:insighted/data/repositories/class_repository_impl.dart';
import 'package:insighted/domain/entities/class_group.dart';
import 'package:insighted/presentation/models/class_model.dart';
import 'package:insighted/presentation/pages/dashboard/classes/class_details/class_details_page.dart';
import 'package:insighted/presentation/pages/classes/create_class_page.dart';

class ClassManagementPage extends StatefulWidget {
  const ClassManagementPage({super.key});

  @override
  State<ClassManagementPage> createState() => _ClassManagementPageState();
}

class _ClassManagementPageState extends State<ClassManagementPage> {
  // Classes data
  List<ClassModel> _classes = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  // Load classes from the repository
  Future<void> _loadClasses() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final classRepository = ServiceLocator().get<ClassRepository>();
      final domainClasses = await classRepository.getAllClasses();

      // Convert domain classes to presentation model
      final classes =
          domainClasses
              .map(
                (domainClass) => ClassModel(
                  id: domainClass.id,
                  name:
                      domainClass.name
                          .split(' ')
                          .first, // Assuming format "Grade X"
                  section:
                      domainClass.name.contains(' ')
                          ? domainClass.name.split(' ').last
                          : 'A',
                  studentCount:
                      0, // Will be updated when we implement student count
                  teacherCount:
                      0, // Will be updated when we implement teacher count
                  classTeacher: domainClass.teacherName ?? 'Unassigned',
                  subjects: [],
                  level: _determineLevelFromName(domainClass.name),
                  color: _getRandomColor(domainClass.id),
                ),
              )
              .toList();

      setState(() {
        _classes = classes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading classes: $e');
      setState(() {
        _isLoading = false;
        _error = 'Failed to load classes: $e';
      });
    }
  }

  // Helper to determine education level from class name
  String _determineLevelFromName(String className) {
    final name = className.toLowerCase();
    if (name.contains('grade')) {
      final gradeNumber =
          int.tryParse(name.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

      if (gradeNumber <= 6) return 'Primary';
      if (gradeNumber <= 9) return 'Junior Secondary';
      return 'Senior Secondary';
    }
    return 'Unspecified';
  }

  // Generate color based on class ID for consistency
  Color _getRandomColor(String id) {
    final colors = [
      ColorConstants.primaryColor,
      ColorConstants.infoColor,
      ColorConstants.warningColor,
      ColorConstants.successColor,
      ColorConstants.accentColor,
      ColorConstants.errorColor,
    ];

    final colorIndex = id.hashCode % colors.length;
    return colors[colorIndex];
  }

  // Add a new class to the database using repository
  Future<void> _addClass(ClassModel newClass) async {
    try {
      final classRepository = ServiceLocator().get<ClassRepository>();

      // Convert presentation model to domain entity
      final domainClass = ClassGroup(
        id: '', // Will be assigned by repository
        name: '${newClass.name} ${newClass.section}',
        description: '',
        grade: newClass.name,
        teacherId: null,
        teacherName: newClass.classTeacher,
        academicYear: DateTime.now().year,
        term: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await classRepository.saveClass(domainClass);

      // Refresh the class list
      _loadClasses();
    } catch (e) {
      print('Error adding class: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add class: $e')));
    }
  }

  // Delete a class from the database
  Future<void> _deleteClass(String classId) async {
    try {
      final classRepository = ServiceLocator().get<ClassRepository>();
      await classRepository.deleteClass(classId);

      // Refresh the class list
      _loadClasses();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Class deleted successfully')),
      );
    } catch (e) {
      print('Error deleting class: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete class: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Management'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadClasses,
            tooltip: 'Refresh classes',
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading classes...'),
                  ],
                ),
              )
              : _error != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      'Error loading classes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(_error!),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadClasses,
                      child: Text('Retry'),
                    ),
                  ],
                ),
              )
              : _classes.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.class_, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No classes found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Create your first class to get started'),
                  ],
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Classes',
                      style: TextStyle(
                        color: ColorConstants.primaryTextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manage all classes and academic streams',
                      style: TextStyle(
                        color: ColorConstants.secondaryTextColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 1.1,
                            ),
                        itemCount: _classes.length,
                        itemBuilder: (context, index) {
                          final classItem = _classes[index];
                          return _buildClassCard(context, classItem);
                        },
                      ),
                    ),
                  ],
                ),
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstants.primaryColor,
        child: const Icon(Icons.add),
        onPressed: () async {
          // Navigate to create class page and wait for result
          final result = await Navigator.push<ClassModel>(
            context,
            MaterialPageRoute(builder: (context) => const CreateClassPage()),
          );

          // If a new class was created, refresh classes list
          if (result != null) {
            _loadClasses();
          }
        },
      ),
    );
  }

  Widget _buildClassCard(BuildContext context, ClassModel classItem) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClassDetailsPage(classModel: classItem),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [classItem.color.withOpacity(0.8), classItem.color],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${classItem.name} ${classItem.section}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.school,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Class Teacher: ${classItem.classTeacher}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${classItem.studentCount} Students',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${classItem.teacherCount} Teachers',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    classItem.level,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
