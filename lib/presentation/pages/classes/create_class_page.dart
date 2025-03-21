import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';
import 'package:insighted/core/services/service_locator.dart';
import 'package:insighted/data/repositories/class_repository_impl.dart';
import 'package:insighted/domain/entities/class_group.dart';
import 'package:insighted/presentation/components/form_field_widget.dart';
import 'package:insighted/presentation/components/dropdown_field_widget.dart';
import 'package:insighted/presentation/models/class_model.dart';
// import 'package:intl/intl.dart';

class CreateClassPage extends StatefulWidget {
  const CreateClassPage({super.key});

  @override
  State<CreateClassPage> createState() => _CreateClassPageState();
}

class _CreateClassPageState extends State<CreateClassPage> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Text editing controllers
  final _classNameController = TextEditingController();
  final _sectionController = TextEditingController();
  final _classTeacherController = TextEditingController();

  // Selected values
  String? _selectedLevel;
  final List<String> _selectedSubjects = [];
  Color _selectedColor = ColorConstants.primaryColor;

  // All subjects
  final List<String> _allSubjects = [
    'Mathematics',
    'English',
    'Kiswahili',
    'Science',
    'Science and Technology',
    'Social Studies',
    'Religious Education',
    'Creative Arts',
    'Physical and Health Education',
    'Agriculture',
    'Home Science',
    'Business Studies',
    'Music',
    'Art',
    'PE',
  ];

  // Education levels
  final List<String> _educationLevels = [
    'Upper Primary',
    'Junior Secondary',
    'Senior Secondary',
  ];

  // Colors for selection
  final List<Color> _availableColors = [
    ColorConstants.primaryColor,
    ColorConstants.accentColor,
    ColorConstants.infoColor,
    ColorConstants.successColor,
    ColorConstants.warningColor,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
  ];

  // Loading state
  bool _isLoading = false;

  @override
  void dispose() {
    // Dispose controllers
    _classNameController.dispose();
    _sectionController.dispose();
    _classTeacherController.dispose();
    super.dispose();
  }

  // Toggle subject selection
  void _toggleSubject(String subject) {
    setState(() {
      if (_selectedSubjects.contains(subject)) {
        _selectedSubjects.remove(subject);
      } else {
        _selectedSubjects.add(subject);
      }
    });
  }

  // Select color
  void _selectColor(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }

  // Submit form
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Check if at least one subject is selected
      if (_selectedSubjects.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one subject'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Set loading state
      setState(() {
        _isLoading = true;
      });

      try {
        // Create presentation model for UI
        final newClass = ClassModel(
          id:
              'C${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 8)}', // Generate temporary ID
          name: _classNameController.text.trim(),
          section: _sectionController.text.trim(),
          studentCount: 0, // New class starts with 0 students
          teacherCount: 0, // New class starts with 0 teachers
          classTeacher: _classTeacherController.text.trim(),
          subjects: _selectedSubjects,
          level: _selectedLevel!,
          color: _selectedColor,
        );
        
        // Create domain entity for database
        final classRepository = ServiceLocator().get<ClassRepository>();
        final domainClass = ClassGroup(
          id: '', // Will be assigned by repository
          name: '${newClass.name} ${newClass.section}',
          description: 'Class for ${newClass.level} level',
          grade: newClass.name,
          teacherId: null,
          teacherName: newClass.classTeacher,
          academicYear: DateTime.now().year,
          term: 1,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        // Save to database
        await classRepository.saveClass(domainClass);

        // Show success message and return to previous screen with the new class
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Class ${newClass.name} ${newClass.section} created successfully!',
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, newClass);
        }
      } catch (e) {
        // Show error
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
        print('Error creating class: $e');
      } finally {
        // Reset loading state
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Class'),
        backgroundColor: ColorConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Form sections
                      _buildSectionHeader('Class Information'),
                      const SizedBox(height: 16),

                      // Class info fields
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: CustomFormField(
                              label: 'Class Name',
                              controller: _classNameController,
                              prefixIcon: const Icon(Icons.class_),
                              hintText: 'e.g., Grade 4',
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: CustomFormField(
                              label: 'Section',
                              controller: _sectionController,
                              hintText: 'e.g., A',
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),

                      // Class teacher
                      CustomFormField(
                        label: 'Class Teacher',
                        controller: _classTeacherController,
                        prefixIcon: const Icon(Icons.person),
                        hintText: 'e.g., Mrs. Jane Smith',
                        textInputAction: TextInputAction.next,
                      ),

                      // Education level dropdown
                      CustomDropdownField<String>(
                        label: 'Education Level',
                        value: _selectedLevel,
                        items:
                            _educationLevels.map((level) {
                              return DropdownMenuItem<String>(
                                value: level,
                                child: Text(level),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedLevel = value;
                          });
                        },
                      ),

                      // Color selection
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Class Color',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 12,
                            children:
                                _availableColors.map((color) {
                                  final isSelected = _selectedColor == color;
                                  return GestureDetector(
                                    onTap: () => _selectColor(color),
                                    child: Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? Colors.white
                                                  : Colors.transparent,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          if (isSelected)
                                            BoxShadow(
                                              color: color.withOpacity(0.4),
                                              blurRadius: 8,
                                              spreadRadius: 2,
                                            ),
                                        ],
                                      ),
                                      child:
                                          isSelected
                                              ? const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 18,
                                              )
                                              : null,
                                    ),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      _buildSectionHeader('Subjects'),
                      const SizedBox(height: 16),

                      // Subject selection
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              text: 'Subjects for This Class',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                              children: [
                                TextSpan(
                                  text: ' *',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                _allSubjects.map((subject) {
                                  final isSelected = _selectedSubjects.contains(
                                    subject,
                                  );
                                  return FilterChip(
                                    label: Text(subject),
                                    selected: isSelected,
                                    onSelected: (_) => _toggleSubject(subject),
                                    backgroundColor: Colors.grey.shade100,
                                    selectedColor: _selectedColor.withOpacity(
                                      0.2,
                                    ),
                                    checkmarkColor: _selectedColor,
                                    labelStyle: TextStyle(
                                      color:
                                          isSelected
                                              ? _selectedColor
                                              : Colors.black87,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _isLoading ? null : _submitForm,
                          child: _isLoading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text('Creating class...'),
                                  ],
                                )
                              : const Text(
                                  'Create Class',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _selectedColor,
          ),
        ),
        const SizedBox(height: 8),
        Divider(color: _selectedColor.withOpacity(0.2)),
      ],
    );
  }
}
