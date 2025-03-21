import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';
import 'package:insighted/presentation/components/form_field_widget.dart';
import 'package:insighted/presentation/components/dropdown_field_widget.dart';
import 'package:insighted/presentation/models/class_model.dart';
import 'package:insighted/presentation/models/teacher_model.dart';
import 'package:intl/intl.dart';

class AddTeacherPage extends StatefulWidget {
  const AddTeacherPage({super.key});

  @override
  State<AddTeacherPage> createState() => _AddTeacherPageState();
}

class _AddTeacherPageState extends State<AddTeacherPage> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Text editing controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _experienceController = TextEditingController();

  // Selected values
  String? _selectedGender;
  DateTime? _selectedDate;
  final List<ClassModel> _selectedClasses = [];
  final List<String> _selectedSubjects = [];

  // Mock class data
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
      color: Colors.blue,
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
      color: Colors.green,
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
      color: Colors.orange,
    ),
  ];

  // All subjects from classes
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

  // Loading state
  bool _isLoading = false;

  @override
  void dispose() {
    // Dispose controllers
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _qualificationController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  // Show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDate ??
          DateTime.now().subtract(
            const Duration(days: 365 * 30),
          ), // Default to 30 years ago
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorConstants.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // Toggle class selection
  void _toggleClass(ClassModel classModel) {
    setState(() {
      if (_selectedClasses.contains(classModel)) {
        _selectedClasses.remove(classModel);
      } else {
        _selectedClasses.add(classModel);
      }
    });
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

  // Submit form
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Check if at least one class and subject is selected
      if (_selectedClasses.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one class'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

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
        // Simulate network delay
        await Future.delayed(const Duration(seconds: 1));

        // Create new teacher object
        final newTeacher = Teacher(
          id:
              'T${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 8)}', // Generate temporary ID
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          dateOfBirth: _dobController.text,
          gender: _selectedGender!,
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          employmentDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          subjects: _selectedSubjects,
          classIds: _selectedClasses.map((c) => c.id).toList(),
          qualification: _qualificationController.text.trim(),
          experience: _experienceController.text.trim(),
        );

        // In a real app, you would save this to a database
        // For now, just print the teacher info and show success
        debugPrint('New teacher created: ${newTeacher.toJson()}');

        // Show success message and navigate back
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Teacher ${newTeacher.fullName} added successfully!',
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
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
        title: const Text('Add New Teacher'),
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
                      _buildSectionHeader('Personal Information'),
                      const SizedBox(height: 16),

                      // Personal info fields
                      Row(
                        children: [
                          Expanded(
                            child: CustomFormField(
                              label: 'First Name',
                              controller: _firstNameController,
                              prefixIcon: const Icon(Icons.person),
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomFormField(
                              label: 'Last Name',
                              controller: _lastNameController,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),

                      // Date of birth
                      CustomFormField(
                        label: 'Date of Birth',
                        controller: _dobController,
                        prefixIcon: const Icon(Icons.calendar_today),
                        readOnly: true,
                        onTap: () => _selectDate(context),
                      ),

                      // Gender dropdown
                      CustomDropdownField<String>(
                        label: 'Gender',
                        value: _selectedGender,
                        items: const [
                          DropdownMenuItem(value: 'Male', child: Text('Male')),
                          DropdownMenuItem(
                            value: 'Female',
                            child: Text('Female'),
                          ),
                          DropdownMenuItem(
                            value: 'Other',
                            child: Text('Other'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                      ),

                      // Contact info
                      CustomFormField(
                        label: 'Email',
                        controller: _emailController,
                        prefixIcon: const Icon(Icons.email),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          // Simple email validation
                          final emailRegExp = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          );
                          if (!emailRegExp.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),

                      CustomFormField(
                        label: 'Phone Number',
                        controller: _phoneController,
                        prefixIcon: const Icon(Icons.phone),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                      ),

                      CustomFormField(
                        label: 'Address',
                        controller: _addressController,
                        prefixIcon: const Icon(Icons.home),
                        isMultiline: true,
                      ),

                      const SizedBox(height: 16),
                      _buildSectionHeader('Professional Information'),
                      const SizedBox(height: 16),

                      // Qualification and experience
                      CustomFormField(
                        label: 'Qualification',
                        controller: _qualificationController,
                        prefixIcon: const Icon(Icons.school),
                        hintText: 'e.g., Bachelor of Education',
                        textInputAction: TextInputAction.next,
                      ),

                      CustomFormField(
                        label: 'Experience',
                        controller: _experienceController,
                        prefixIcon: const Icon(Icons.work),
                        hintText: 'e.g., 5 years',
                        textInputAction: TextInputAction.next,
                      ),

                      // Class selection
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              text: 'Assigned Classes',
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
                                _classes.map((classModel) {
                                  final isSelected = _selectedClasses.contains(
                                    classModel,
                                  );
                                  return FilterChip(
                                    label: Text(
                                      '${classModel.name} ${classModel.section}',
                                    ),
                                    selected: isSelected,
                                    onSelected: (_) => _toggleClass(classModel),
                                    backgroundColor: Colors.grey.shade100,
                                    selectedColor: classModel.color.withOpacity(
                                      0.2,
                                    ),
                                    checkmarkColor: classModel.color,
                                    labelStyle: TextStyle(
                                      color:
                                          isSelected
                                              ? classModel.color
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

                      const SizedBox(height: 16),

                      // Subject selection
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              text: 'Subjects Teaching',
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
                                    selectedColor: ColorConstants.primaryColor
                                        .withOpacity(0.2),
                                    checkmarkColor: ColorConstants.primaryColor,
                                    labelStyle: TextStyle(
                                      color:
                                          isSelected
                                              ? ColorConstants.primaryColor
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
                            backgroundColor: ColorConstants.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _submitForm,
                          child: const Text(
                            'Add Teacher',
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
            color: ColorConstants.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Divider(color: ColorConstants.primaryColor.withOpacity(0.2)),
      ],
    );
  }
}
