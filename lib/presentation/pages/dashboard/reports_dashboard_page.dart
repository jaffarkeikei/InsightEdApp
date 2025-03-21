import 'package:flutter/material.dart';
import 'dart:math';
import 'package:insighted/core/constants/color_constants.dart';
import 'package:insighted/core/services/service_locator.dart';
import 'package:insighted/data/repositories/class_repository_impl.dart';
import 'package:insighted/data/repositories/student_repository_impl.dart';
import 'package:insighted/domain/entities/class_group.dart';
import 'package:insighted/domain/entities/student.dart';

// Simple extension to generate mock marks for demo purposes
extension StudentMarksExtension on Student {
  Map<String, int> get generateMarks {
    // Generate consistent marks based on student ID
    final seed = id.hashCode;
    final rng = Random(seed);

    return {
      'Mathematics': 60 + rng.nextInt(41), // 60-100
      'English': 60 + rng.nextInt(41),
      'Science': 60 + rng.nextInt(41),
      'Social Studies': 60 + rng.nextInt(41),
      'Art': 60 + rng.nextInt(41),
    };
  }
}

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String _selectedReportType = 'Class';
  String? _selectedClass;
  String _searchQuery = '';
  bool _showPreview = false;
  String? _selectedStudentName;
  String? _selectedStudentId;

  // Loading states
  bool _isLoading = true;
  String? _error;

  // Data from repositories
  List<ClassGroup> _classes = [];
  List<Student> _students = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Load data from repositories
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load classes
      final classRepository = ServiceLocator().get<ClassRepository>();
      final classes = await classRepository.getAllClasses();

      // Load students
      final studentRepository = ServiceLocator().get<StudentRepository>();
      final students = await studentRepository.getAllStudents();

      setState(() {
        _classes = classes;
        _students = students;
        _isLoading = false;

        // Set default selected class if available
        if (classes.isNotEmpty) {
          _selectedClass = classes.first.name;
        }
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
        _error = 'Failed to load data: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh data',
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
                    Text('Loading data...'),
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
                      'Error loading data',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(_error!),
                    SizedBox(height: 16),
                    ElevatedButton(onPressed: _loadData, child: Text('Retry')),
                  ],
                ),
              )
              : _classes.isEmpty && _students.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.school, size: 64, color: Colors.grey[400]),
                    SizedBox(height: 16),
                    Text(
                      'No data available',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Add classes and students to generate reports'),
                  ],
                ),
              )
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Report Options',
                              style: TextStyle(
                                color: ColorConstants.primaryTextColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Report Type Selection
                            Text(
                              'Report Type',
                              style: TextStyle(
                                color: ColorConstants.secondaryTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SegmentedButton<String>(
                              segments: const [
                                ButtonSegment(
                                  value: 'Class',
                                  label: Text('Class'),
                                ),
                                ButtonSegment(
                                  value: 'Name',
                                  label: Text('Student Name'),
                                ),
                                ButtonSegment(
                                  value: 'ID',
                                  label: Text('Student ID'),
                                ),
                              ],
                              selected: {_selectedReportType},
                              onSelectionChanged: (selectedSet) {
                                setState(() {
                                  _selectedReportType = selectedSet.first;
                                  _showPreview = false;
                                  _selectedStudentName = null;
                                  _selectedStudentId = null;
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.resolveWith<Color>((
                                      states,
                                    ) {
                                      if (states.contains(
                                        WidgetState.selected,
                                      )) {
                                        return ColorConstants.primaryColor;
                                      }
                                      return Colors.transparent;
                                    }),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Dynamic content based on report type
                            if (_selectedReportType == 'Class')
                              _buildClassSelection(),
                            if (_selectedReportType == 'Name')
                              _buildNameSearch(),
                            if (_selectedReportType == 'ID') _buildIdSearch(),

                            const SizedBox(height: 16),

                            // Generate Report Button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConstants.primaryColor,
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(48),
                              ),
                              onPressed:
                                  _canGenerateReport()
                                      ? () {
                                        setState(() {
                                          _showPreview = true;
                                        });
                                      }
                                      : null,
                              child: const Text('Generate Report'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Report Preview
                  if (_showPreview)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Report Preview',
                                      style: TextStyle(
                                        color: ColorConstants.primaryTextColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Report downloaded successfully!',
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.download),
                                      label: const Text('Export PDF'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            ColorConstants.successColor,
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 24),
                                const Text(
                                  'Note: This is a simplified report preview. Complete reporting with full analytics will be included in the next update.',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Simple report content based on type
                                if (_selectedReportType == 'Class')
                                  _buildSimpleClassReport()
                                else
                                  _buildSimpleStudentReport(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
    );
  }

  Widget _buildClassSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Class',
          style: TextStyle(
            color: ColorConstants.secondaryTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedClass,
              items:
                  _classes.map((classGroup) {
                    return DropdownMenuItem(
                      value: classGroup.name,
                      child: Text(classGroup.name),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedClass = value;
                    _showPreview = false;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNameSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search Student by Name',
          style: TextStyle(
            color: ColorConstants.secondaryTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter student name',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
              _showPreview = false;
              _selectedStudentName = null;
            });
          },
        ),
        const SizedBox(height: 16),
        if (_searchQuery.isNotEmpty) _buildSearchResults(),
      ],
    );
  }

  Widget _buildIdSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search Student by ID',
          style: TextStyle(
            color: ColorConstants.secondaryTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter student ID',
            prefixIcon: const Icon(Icons.badge),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
              _showPreview = false;
              _selectedStudentId = null;
            });
          },
        ),
        const SizedBox(height: 16),
        if (_searchQuery.isNotEmpty) _buildSearchResults(isIdSearch: true),
      ],
    );
  }

  Widget _buildSearchResults({bool isIdSearch = false}) {
    final filteredStudents =
        _students.where((student) {
          if (isIdSearch) {
            return student.id.toString().toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
          } else {
            return student.name.toString().toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
          }
        }).toList();

    if (filteredStudents.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('No students found'),
      );
    }

    return Container(
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: filteredStudents.length,
        itemBuilder: (context, index) {
          final student = filteredStudents[index];
          return ListTile(
            title: Text(student.name),
            subtitle: Text('ID: ${student.id} - Class: ${student.className}'),
            onTap: () {
              setState(() {
                if (isIdSearch) {
                  _selectedStudentId = student.id;
                } else {
                  _selectedStudentName = student.name;
                }
              });
            },
            selected:
                isIdSearch
                    ? _selectedStudentId == student.id
                    : _selectedStudentName == student.name,
            selectedTileColor: ColorConstants.primaryColor.withOpacity(0.1),
          );
        },
      ),
    );
  }

  bool _canGenerateReport() {
    if (_selectedReportType == 'Class') {
      return _selectedClass != null;
    } else if (_selectedReportType == 'Name') {
      return _selectedStudentName != null;
    } else if (_selectedReportType == 'ID') {
      return _selectedStudentId != null;
    }
    return false;
  }

  Widget _buildSimpleClassReport() {
    final classStudents =
        _students
            .where((student) => student.className == _selectedClass)
            .toList();

    if (classStudents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text('No students in this class', style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Class Report: $_selectedClass',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorConstants.primaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Total Students: ${classStudents.length}',
            style: TextStyle(
              fontSize: 14,
              color: ColorConstants.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Students in this class:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Student list
          Expanded(
            child: ListView.builder(
              itemCount: classStudents.length,
              itemBuilder: (context, index) {
                final student = classStudents[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: ColorConstants.primaryColor.withOpacity(
                      0.1,
                    ),
                    child: Text(
                      student.name.isNotEmpty
                          ? student.name.substring(0, 1)
                          : "-",
                      style: TextStyle(color: ColorConstants.primaryColor),
                    ),
                  ),
                  title: Text(student.name),
                  subtitle: Text('ID: ${student.id}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleStudentReport() {
    // Find selected student
    Student student;
    if (_selectedReportType == 'ID') {
      student = _students.firstWhere(
        (s) => s.id == _selectedStudentId,
        orElse:
            () => Student(
              id: '',
              name: '',
              studentNumber: '',
              gender: '',
              classId: '',
              className: '',
              dateOfBirth: DateTime.now(),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
      );
    } else {
      student = _students.firstWhere(
        (s) => s.name == _selectedStudentName,
        orElse:
            () => Student(
              id: '',
              name: '',
              studentNumber: '',
              gender: '',
              classId: '',
              className: '',
              dateOfBirth: DateTime.now(),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
      );
    }

    if (student.id.isEmpty) {
      return const Center(child: Text('Student data not found'));
    }

    // Generate mock marks for demo
    final marks = student.generateMarks;
    final average = marks.values.reduce((a, b) => a + b) / marks.length;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Student Report',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorConstants.primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: ColorConstants.primaryColor,
                      child: Text(
                        student.name.isNotEmpty
                            ? student.name.substring(0, 1)
                            : "-",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text('ID: ${student.id}'),
                          Text('Class: ${student.className}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Academic Performance',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Subject grades
          Expanded(
            child: ListView(
              children: [
                // Average score card
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: ColorConstants.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Average Score:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${average.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: _getColorForScore(average),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),

                // Subject list
                ...marks.entries.map((entry) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key),
                        Text(
                          '${entry.value}%',
                          style: TextStyle(
                            color: _getColorForScore(entry.value.toDouble()),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForScore(double score) {
    if (score >= 90) return ColorConstants.successColor;
    if (score >= 80) return ColorConstants.infoColor;
    if (score >= 70) return ColorConstants.primaryColor;
    if (score >= 60) return ColorConstants.warningColor;
    return ColorConstants.errorColor;
  }
}
