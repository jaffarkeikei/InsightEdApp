import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';
import 'package:insighted/presentation/models/exams/exam_result_model.dart';
import 'package:insighted/presentation/pages/dashboard/exams/components/exam_results_table.dart';

class ExamResultsPage extends StatefulWidget {
  final String examId;
  final String examTitle;
  final String classId;
  final String className;
  final Color classColor;

  const ExamResultsPage({
    super.key,
    required this.examId,
    required this.examTitle,
    required this.classId,
    required this.className,
    required this.classColor,
  });

  @override
  State<ExamResultsPage> createState() => _ExamResultsPageState();
}

class _ExamResultsPageState extends State<ExamResultsPage> {
  bool _isLoading = true;
  List<ExamResult> _results = [];
  List<String> _subjects = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadExamResults();
  }

  // Load exam results - in a real app, this would fetch from a database
  Future<void> _loadExamResults() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock subjects
    final subjects = [
      'Mathematics',
      'English',
      'Kiswahili',
      'Science',
      'Social Studies',
    ];

    // Mock student results
    final mockResults = [
      ExamResult(
        examId: widget.examId,
        examTitle: widget.examTitle,
        studentId: 'S001',
        studentName: 'John Smith',
        subjectScores: {
          'Mathematics': 85,
          'English': 78,
          'Kiswahili': 72,
          'Science': 90,
          'Social Studies': 82,
        },
        totalScore: 407,
        position: 3,
      ),
      ExamResult(
        examId: widget.examId,
        examTitle: widget.examTitle,
        studentId: 'S002',
        studentName: 'Emily Johnson',
        subjectScores: {
          'Mathematics': 92,
          'English': 95,
          'Kiswahili': 88,
          'Science': 87,
          'Social Studies': 91,
        },
        totalScore: 453,
        position: 1,
      ),
      ExamResult(
        examId: widget.examId,
        examTitle: widget.examTitle,
        studentId: 'S003',
        studentName: 'Michael Brown',
        subjectScores: {
          'Mathematics': 78,
          'English': 82,
          'Kiswahili': 74,
          'Science': 85,
          'Social Studies': 80,
        },
        totalScore: 399,
        position: 4,
      ),
      ExamResult(
        examId: widget.examId,
        examTitle: widget.examTitle,
        studentId: 'S004',
        studentName: 'Sarah Martinez',
        subjectScores: {
          'Mathematics': 95,
          'English': 90,
          'Kiswahili': 85,
          'Science': 92,
          'Social Studies': 89,
        },
        totalScore: 451,
        position: 2,
      ),
      ExamResult(
        examId: widget.examId,
        examTitle: widget.examTitle,
        studentId: 'S005',
        studentName: 'David Wilson',
        subjectScores: {
          'Mathematics': 72,
          'English': 68,
          'Kiswahili': 70,
          'Science': 75,
          'Social Studies': 69,
        },
        totalScore: 354,
        position: 6,
      ),
      ExamResult(
        examId: widget.examId,
        examTitle: widget.examTitle,
        studentId: 'S006',
        studentName: 'Jennifer Anderson',
        subjectScores: {
          'Mathematics': 88,
          'English': 84,
          'Kiswahili': 78,
          'Science': 82,
          'Social Studies': 86,
        },
        totalScore: 418,
        position: 5,
      ),
      ExamResult(
        examId: widget.examId,
        examTitle: widget.examTitle,
        studentId: 'S007',
        studentName: 'James Taylor',
        subjectScores: {
          'Mathematics': 62,
          'English': 70,
          'Kiswahili': 65,
          'Science': 68,
          'Social Studies': 72,
        },
        totalScore: 337,
        position: 7,
      ),
    ];

    setState(() {
      _subjects = subjects;
      _results = mockResults;
      _isLoading = false;
    });
  }

  // Filter results based on search query
  List<ExamResult> get _filteredResults {
    if (_searchQuery.isEmpty) {
      return _results;
    }

    final query = _searchQuery.toLowerCase();
    return _results.where((result) {
      return result.studentName.toLowerCase().contains(query) ||
          result.studentId.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.className} - ${widget.examTitle}'),
        backgroundColor: widget.classColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Download Report',
            onPressed: () {
              // Download functionality would be implemented here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Report downloaded successfully!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.print),
            tooltip: 'Print Report',
            onPressed: () {
              // Print functionality would be implemented here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sending to printer...'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // Class stats
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: widget.classColor.withOpacity(0.05),
                    child: Column(
                      children: [
                        Text(
                          'Exam Summary',
                          style: TextStyle(
                            color: widget.classColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem('Students', '${_results.length}'),
                            _buildStatItem('Class Average', '81%'),
                            _buildStatItem('Passing Rate', '85%'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Search bar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search student...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),

                  // Results table
                  Expanded(
                    child: ExamResultsTable(
                      results: _filteredResults,
                      subjects: _subjects,
                      classColor: widget.classColor,
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: widget.classColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: ColorConstants.secondaryTextColor,
          ),
        ),
      ],
    );
  }
}
