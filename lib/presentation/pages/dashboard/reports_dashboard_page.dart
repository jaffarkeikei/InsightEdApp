import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String _selectedReportType = 'Class';
  String _selectedClass = 'Grade 4 A';
  String _searchQuery = '';
  bool _showPreview = false;
  String? _selectedStudentName;
  String? _selectedStudentId;

  // Dummy data for classes
  final List<String> _classes = [
    'Grade 4 A',
    'Grade 5 A',
    'Grade 6 A',
    'Grade 7 A',
    'Grade 8 A',
    'Grade 9 A',
  ];

  // Dummy data for students
  final List<Map<String, dynamic>> _students = [
    {
      'id': 'STD001',
      'name': 'John Smith',
      'class': 'Grade 4 A',
      'marks': {
        'Mathematics': 85,
        'English': 78,
        'Science': 92,
        'Social Studies': 88,
        'Art': 95,
      },
    },
    {
      'id': 'STD002',
      'name': 'Emily Johnson',
      'class': 'Grade 4 A',
      'marks': {
        'Mathematics': 92,
        'English': 95,
        'Science': 88,
        'Social Studies': 90,
        'Art': 85,
      },
    },
    {
      'id': 'STD003',
      'name': 'Michael Brown',
      'class': 'Grade 5 A',
      'marks': {
        'Mathematics': 75,
        'English': 82,
        'Science': 79,
        'Social Studies': 85,
        'Art': 88,
      },
    },
    {
      'id': 'STD004',
      'name': 'Jessica Davis',
      'class': 'Grade 5 A',
      'marks': {
        'Mathematics': 88,
        'English': 91,
        'Science': 87,
        'Social Studies': 82,
        'Art': 90,
      },
    },
    {
      'id': 'STD005',
      'name': 'David Wilson',
      'class': 'Grade 6 A',
      'marks': {
        'Mathematics': 72,
        'English': 68,
        'Science': 75,
        'Social Studies': 70,
        'Art': 82,
      },
    },
    {
      'id': 'STD006',
      'name': 'Sarah Martinez',
      'class': 'Grade 6 A',
      'marks': {
        'Mathematics': 95,
        'English': 92,
        'Science': 98,
        'Social Studies': 91,
        'Art': 93,
      },
    },
    {
      'id': 'STD007',
      'name': 'James Taylor',
      'class': 'Grade 7 A',
      'marks': {
        'Mathematics': 82,
        'English': 79,
        'Science': 85,
        'Social Studies': 80,
        'Art': 78,
      },
    },
    {
      'id': 'STD008',
      'name': 'Jennifer Anderson',
      'class': 'Grade 7 A',
      'marks': {
        'Mathematics': 88,
        'English': 85,
        'Science': 90,
        'Social Studies': 87,
        'Art': 91,
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Show help dialog
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Report Generator Help'),
                      content: const Text(
                        'Generate reports by:\n'
                        '• Class: Generate reports for an entire class\n'
                        '• Student Name: Search for a student by name\n'
                        '• Student ID: Look up student by ID number\n\n'
                        'Use the preview option to see the report before downloading.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                        ButtonSegment(value: 'Class', label: Text('Class')),
                        ButtonSegment(
                          value: 'Name',
                          label: Text('Student Name'),
                        ),
                        ButtonSegment(value: 'ID', label: Text('Student ID')),
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
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (states) {
                            if (states.contains(WidgetState.selected)) {
                              return ColorConstants.primaryColor;
                            }
                            return Colors.transparent;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Dynamic content based on report type
                    if (_selectedReportType == 'Class') _buildClassSelection(),
                    if (_selectedReportType == 'Name') _buildNameSearch(),
                    if (_selectedReportType == 'ID') _buildIdSearch(),

                    const SizedBox(height: 16),

                    // Action Buttons - Modified to be vertical instead of horizontal
                    // Preview Button on top
                    ElevatedButton.icon(
                      icon: const Icon(Icons.preview),
                      label: const Text('Preview Report'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.infoColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size.fromHeight(
                          48,
                        ), // Make the button taller
                      ),
                      onPressed:
                          _canGenerateReport()
                              ? () {
                                // Show preview in a dialog
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          constraints: BoxConstraints(
                                            maxWidth:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.9,
                                            maxHeight:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height *
                                                0.8,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Report Preview',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          ColorConstants
                                                              .primaryTextColor,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.close,
                                                    ),
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              const Divider(),
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  child: _buildReportPreview(),
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              ElevatedButton.icon(
                                                icon: const Icon(
                                                  Icons.download,
                                                ),
                                                label: const Text(
                                                  'Download PDF',
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      ColorConstants
                                                          .successColor,
                                                  foregroundColor: Colors.white,
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Report downloaded successfully!',
                                                      ),
                                                      behavior:
                                                          SnackBarBehavior
                                                              .floating,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                );
                              }
                              : null,
                    ),

                    const SizedBox(height: 12), // Space between buttons
                    // Generate Report Button on bottom
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size.fromHeight(
                          48,
                        ), // Make the button taller
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Report downloaded successfully!',
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: const Icon(Icons.download),
                          label: const Text('Download PDF'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorConstants.successColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(child: _buildReportPreview()),
                  ],
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
                  _classes.map((className) {
                    return DropdownMenuItem(
                      value: className,
                      child: Text(className),
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
            hintText: 'Enter student ID (e.g., STD001)',
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
            return student['id'].toString().toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
          } else {
            return student['name'].toString().toLowerCase().contains(
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
            title: Text(student['name']),
            subtitle: Text('ID: ${student['id']} - ${student['class']}'),
            onTap: () {
              setState(() {
                if (isIdSearch) {
                  _selectedStudentId = student['id'];
                } else {
                  _selectedStudentName = student['name'];
                }
              });
            },
            selected:
                isIdSearch
                    ? _selectedStudentId == student['id']
                    : _selectedStudentName == student['name'],
            selectedTileColor: ColorConstants.primaryColor.withOpacity(0.1),
          );
        },
      ),
    );
  }

  bool _canGenerateReport() {
    if (_selectedReportType == 'Class') {
      return _selectedClass.isNotEmpty;
    } else if (_selectedReportType == 'Name') {
      return _selectedStudentName != null;
    } else if (_selectedReportType == 'ID') {
      return _selectedStudentId != null;
    }
    return false;
  }

  Widget _buildReportPreview() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 80,
                  height: 80,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: ColorConstants.primaryColor.withOpacity(0.1),
                      child: Icon(
                        Icons.school,
                        size: 40,
                        color: ColorConstants.primaryColor,
                      ),
                    );
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'InsightEd School',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Academic Report',
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorConstants.secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Term 2 - 2023',
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorConstants.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 32),

            if (_selectedReportType == 'Class')
              _buildClassReport()
            else
              _buildStudentReport(),
          ],
        ),
      ),
    );
  }

  Widget _buildClassReport() {
    final classStudents =
        _students
            .where((student) => student['class'] == _selectedClass)
            .toList();
    final subjectsList =
        classStudents.isNotEmpty
            ? (classStudents[0]['marks'] as Map<String, dynamic>).keys.toList()
            : [];

    return Column(
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
          'Class Performance Summary',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Class average by subject
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Container(
                color: ColorConstants.primaryColor.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Text(
                        'Subject',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Class Average',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Highest Score',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              ...subjectsList.map((subject) {
                double sum = 0;
                double highest = 0;

                for (final student in classStudents) {
                  final mark = (student['marks'][subject] as int).toDouble();
                  sum += mark;
                  if (mark > highest) highest = mark;
                }

                final average =
                    classStudents.isNotEmpty ? sum / classStudents.length : 0;

                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: Text(subject)),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${average.toStringAsFixed(1)}%',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _getColorForScore(average),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${highest.toStringAsFixed(0)}%',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _getColorForScore(highest),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 16),
        const Text(
          'Student Rankings',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Student rankings table
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Container(
                color: ColorConstants.primaryColor.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text(
                        'Rank',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Expanded(
                      flex: 3,
                      child: Text(
                        'Student Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Average Score',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              ..._getRankedStudents(classStudents),
            ],
          ),
        ),

        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Date Generated: ${DateTime.now().toString().substring(0, 10)}',
              style: TextStyle(
                fontSize: 12,
                color: ColorConstants.secondaryTextColor,
              ),
            ),
            Text(
              'Principal Signature: _________________',
              style: TextStyle(
                fontSize: 12,
                color: ColorConstants.secondaryTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _getRankedStudents(List<Map<String, dynamic>> students) {
    // Create a new list with calculated averages
    final rankedStudents =
        students.map((student) {
          final marks = student['marks'] as Map<String, dynamic>;
          double sum = 0;
          marks.forEach((_, value) {
            sum += (value as int).toDouble();
          });
          final average = marks.isNotEmpty ? sum / marks.length : 0;

          return {...student, 'average': average};
        }).toList();

    // Sort by average score (descending)
    rankedStudents.sort(
      (a, b) => (b['average'] as double).compareTo(a['average'] as double),
    );

    // Convert to widgets
    return rankedStudents.asMap().entries.map<Widget>((entry) {
      final index = entry.key;
      final student = entry.value;
      final rank = index + 1;
      final average = student['average'] as double;

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          color:
              rank <= 3 ? ColorConstants.successColor.withOpacity(0.05) : null,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                '$rank',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: rank <= 3 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                student['name'] as String,
                style: TextStyle(
                  fontWeight: rank <= 3 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '${average.toStringAsFixed(1)}%',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _getColorForScore(average),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildStudentReport() {
    // Find selected student
    final Map<String, dynamic> student;
    if (_selectedReportType == 'ID') {
      student = _students.firstWhere(
        (s) => s['id'] == _selectedStudentId,
        orElse: () => <String, dynamic>{},
      );
    } else {
      student = _students.firstWhere(
        (s) => s['name'] == _selectedStudentName,
        orElse: () => <String, dynamic>{},
      );
    }

    if (student.isEmpty) {
      return const Center(child: Text('Student data not found'));
    }

    final marks = student['marks'] as Map<String, dynamic>;
    double totalMarks = 0;
    marks.forEach((_, value) {
      totalMarks += (value as int).toDouble();
    });
    final average = marks.isNotEmpty ? totalMarks / marks.length : 0;

    // Find class rank
    final classmates =
        _students.where((s) => s['class'] == student['class']).map((s) {
            final studentMarks = s['marks'] as Map<String, dynamic>;
            double sum = 0;
            studentMarks.forEach((_, value) {
              sum += value as int;
            });
            final avg = studentMarks.isNotEmpty ? sum / studentMarks.length : 0;
            return {...s, 'average': avg};
          }).toList()
          ..sort(
            (a, b) =>
                (b['average'] as double).compareTo(a['average'] as double),
          );

    final rank = classmates.indexWhere((s) => s['id'] == student['id']) + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
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
                  const SizedBox(height: 8),
                  Text('Name: ${student['name']}'),
                  Text('ID: ${student['id']}'),
                  Text('Class: ${student['class']}'),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorConstants.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'Average',
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorConstants.secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${average.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _getColorForScore(average),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rank: $rank/${classmates.length}',
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorConstants.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        const Text(
          'Subject Performance',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Subject marks table
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Container(
                color: ColorConstants.primaryColor.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Text(
                        'Subject',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Score',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Grade',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              ...marks.entries.map((entry) {
                final subject = entry.key;
                final score = entry.value as int;

                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: Text(subject)),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '$score%',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _getColorForScore(score.toDouble()),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          _getGradeForScore(score.toDouble()),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _getColorForScore(score.toDouble()),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                color: Colors.grey.shade100,
                child: Row(
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Text(
                        'Overall Average',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${average.toStringAsFixed(1)}%',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _getColorForScore(average),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        _getGradeForScore(average),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _getColorForScore(average),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Teacher's comment
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Teacher\'s Comments:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                average >= 90
                    ? 'Outstanding performance! Keep up the excellent work.'
                    : average >= 80
                    ? 'Very good performance. Continue to work hard and improve.'
                    : average >= 70
                    ? 'Good effort. With more focus, you can achieve even better results.'
                    : average >= 60
                    ? 'Satisfactory performance. Need to pay more attention to weaker subjects.'
                    : 'Needs improvement. Extra effort and support are required.',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: ColorConstants.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Class Teacher:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('________________'),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Date Generated: ${DateTime.now().toString().substring(0, 10)}',
              style: TextStyle(
                fontSize: 12,
                color: ColorConstants.secondaryTextColor,
              ),
            ),
            Text(
              'Principal Signature: _________________',
              style: TextStyle(
                fontSize: 12,
                color: ColorConstants.secondaryTextColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            'This is a computer-generated report and does not require a physical signature.',
            style: TextStyle(
              fontSize: 10,
              color: ColorConstants.secondaryTextColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Color _getColorForScore(num score) {
    final scoreValue = score.toDouble();
    if (scoreValue >= 90) return ColorConstants.successColor;
    if (scoreValue >= 80) return ColorConstants.infoColor;
    if (scoreValue >= 70) return ColorConstants.primaryColor;
    if (scoreValue >= 60) return ColorConstants.warningColor;
    return ColorConstants.errorColor;
  }

  String _getGradeForScore(num score) {
    final scoreValue = score.toDouble();
    if (scoreValue >= 90) return 'A';
    if (scoreValue >= 80) return 'B';
    if (scoreValue >= 70) return 'C';
    if (scoreValue >= 60) return 'D';
    return 'F';
  }
}
