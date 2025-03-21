import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';
import 'package:insighted/presentation/models/class_model.dart';
import 'package:insighted/presentation/pages/dashboard/classes/class_details/class_details_page.dart';
import 'package:insighted/presentation/pages/classes/create_class_page.dart';

class ClassManagementPage extends StatefulWidget {
  const ClassManagementPage({super.key});

  @override
  State<ClassManagementPage> createState() => _ClassManagementPageState();
}

class _ClassManagementPageState extends State<ClassManagementPage> {
  // Mock data for classes
  final List<ClassModel> _classes = [
    ClassModel(
      id: '1',
      name: 'Grade 4',
      section: 'A',
      studentCount: 32,
      teacherCount: 8,
      classTeacher: 'Mrs. Jane Smith',
      subjects: ['Mathematics', 'English', 'Science', 'Social Studies', 'Art'],
      level: 'Upper Primary',
      color: ColorConstants.primaryColor,
    ),
    ClassModel(
      id: '2',
      name: 'Grade 5',
      section: 'A',
      studentCount: 35,
      teacherCount: 9,
      classTeacher: 'Mr. John Doe',
      subjects: [
        'Mathematics',
        'English',
        'Science',
        'Social Studies',
        'Music',
      ],
      level: 'Upper Primary',
      color: ColorConstants.infoColor,
    ),
    ClassModel(
      id: '3',
      name: 'Grade 6',
      section: 'A',
      studentCount: 28,
      teacherCount: 8,
      classTeacher: 'Mrs. Sarah Johnson',
      subjects: ['Mathematics', 'English', 'Science', 'Social Studies', 'PE'],
      level: 'Upper Primary',
      color: ColorConstants.warningColor,
    ),
    ClassModel(
      id: '4',
      name: 'Grade 7',
      section: 'A',
      studentCount: 30,
      teacherCount: 10,
      classTeacher: 'Mr. David Williams',
      subjects: [
        'Mathematics',
        'English',
        'Integrated Science',
        'Social Studies',
        'Business Studies',
      ],
      level: 'Junior Secondary',
      color: ColorConstants.successColor,
    ),
    ClassModel(
      id: '5',
      name: 'Grade 8',
      section: 'A',
      studentCount: 27,
      teacherCount: 10,
      classTeacher: 'Mrs. Emily Brown',
      subjects: [
        'Mathematics',
        'English',
        'Integrated Science',
        'Social Studies',
        'Agriculture',
      ],
      level: 'Junior Secondary',
      color: ColorConstants.accentColor,
    ),
    ClassModel(
      id: '6',
      name: 'Grade 9',
      section: 'A',
      studentCount: 25,
      teacherCount: 10,
      classTeacher: 'Mr. Michael Johnson',
      subjects: [
        'Mathematics',
        'English',
        'Integrated Science',
        'Social Studies',
        'Life Skills',
      ],
      level: 'Junior Secondary',
      color: ColorConstants.errorColor,
    ),
  ];

  // Add a new class to the list (in a real app this would be handled by a repository)
  void _addClass(ClassModel newClass) {
    setState(() {
      _classes.add(newClass);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Management'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: Padding(
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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

          // If a new class was created, add it to the list
          if (result != null) {
            _addClass(result);
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
