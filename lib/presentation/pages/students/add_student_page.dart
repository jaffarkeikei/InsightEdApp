import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';
import 'package:insighted/presentation/components/form_field_widget.dart';
import 'package:insighted/presentation/components/dropdown_field_widget.dart';
import 'package:insighted/presentation/models/class_model.dart';
import 'package:insighted/presentation/models/student_model.dart';
import 'package:intl/intl.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Text editing controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _guardianNameController = TextEditingController();
  final _guardianPhoneController = TextEditingController();
  final _guardianEmailController = TextEditingController();
  final _addressController = TextEditingController();

  // Selected values
  String? _selectedGender;
  ClassModel? _selectedClass;
  DateTime? _selectedDate;

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

  // Loading state
  bool _isLoading = false;

  @override
  void dispose() {
    // Dispose controllers
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _guardianNameController.dispose();
    _guardianPhoneController.dispose();
    _guardianEmailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDate ??
          DateTime.now().subtract(
            const Duration(days: 365 * 6),
          ), // Default to 6 years ago
      firstDate: DateTime(2000),
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

  // Submit form
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Set loading state
      setState(() {
        _isLoading = true;
      });

      try {
        // Simulate network delay
        await Future.delayed(const Duration(seconds: 1));

        // Create new student object
        final newStudent = Student(
          id:
              'S${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 8)}', // Generate temporary ID
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          dateOfBirth: _dobController.text,
          gender: _selectedGender!,
          classId: _selectedClass!.id,
          className: '${_selectedClass!.name} ${_selectedClass!.section}',
          guardianName: _guardianNameController.text.trim(),
          guardianContact: _guardianPhoneController.text.trim(),
          guardianEmail: _guardianEmailController.text.trim(),
          address: _addressController.text.trim(),
          admissionDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        );

        // In a real app, you would save this to a database
        // For now, just print the student info and show success
        debugPrint('New student created: ${newStudent.toJson()}');

        // Show success message and navigate back
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Student ${newStudent.fullName} added successfully!',
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
        title: const Text('Add New Student'),
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

                      // Class dropdown
                      CustomDropdownField<ClassModel>(
                        label: 'Class',
                        value: _selectedClass,
                        items:
                            _classes.map((classModel) {
                              return DropdownMenuItem<ClassModel>(
                                value: classModel,
                                child: Text(
                                  '${classModel.name} ${classModel.section}',
                                ),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedClass = value;
                          });
                        },
                      ),

                      const SizedBox(height: 16),
                      _buildSectionHeader('Guardian Information'),
                      const SizedBox(height: 16),

                      // Guardian info
                      CustomFormField(
                        label: 'Guardian Name',
                        controller: _guardianNameController,
                        prefixIcon: const Icon(Icons.family_restroom),
                        textInputAction: TextInputAction.next,
                      ),

                      CustomFormField(
                        label: 'Phone Number',
                        controller: _guardianPhoneController,
                        prefixIcon: const Icon(Icons.phone),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                      ),

                      CustomFormField(
                        label: 'Email',
                        controller: _guardianEmailController,
                        prefixIcon: const Icon(Icons.email),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            // Simple email validation
                            final emailRegExp = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            );
                            if (!emailRegExp.hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                          }
                          return null;
                        },
                      ),

                      CustomFormField(
                        label: 'Address',
                        controller: _addressController,
                        prefixIcon: const Icon(Icons.home),
                        isMultiline: true,
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
                            'Add Student',
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
