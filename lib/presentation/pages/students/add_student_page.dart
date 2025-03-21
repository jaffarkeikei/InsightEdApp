import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';
import 'package:insighted/core/services/service_locator.dart';
import 'package:insighted/data/repositories/student_repository_impl.dart';
import 'package:insighted/data/repositories/class_repository_impl.dart';
import 'package:insighted/domain/entities/student.dart' as domain;
import 'package:insighted/domain/entities/class_group.dart';
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

  // Classes data
  List<ClassModel> _classes = [];
  bool _isLoadingClasses = true;
  bool _isLoading = false; // For form submission

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  // Load classes from the repository
  Future<void> _loadClasses() async {
    setState(() {
      _isLoadingClasses = true;
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
        _isLoadingClasses = false;
      });
    } catch (e) {
      print('Error loading classes: $e');
      setState(() {
        _isLoadingClasses = false;
        // Fallback to some default classes if loading fails
        _classes = [
          ClassModel(
            id: '1',
            name: 'Grade 4',
            section: 'A',
            studentCount: 0,
            teacherCount: 0,
            classTeacher: 'Unassigned',
            subjects: [],
            level: 'Primary',
            color: Colors.blue,
          ),
        ];
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
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];

    final colorIndex = id.hashCode % colors.length;
    return colors[colorIndex];
  }

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
        // Get the student repository through the service locator
        final studentRepository = ServiceLocator().get<StudentRepository>();

        // Create presentation layer student model
        final presentationStudent = Student(
          id:
              'S${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 8)}',
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

        // Convert to domain entity
        final domainStudent = domain.Student(
          id: presentationStudent.id,
          name:
              '${presentationStudent.firstName} ${presentationStudent.lastName}',
          studentNumber:
              'STD${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 6)}',
          gender: presentationStudent.gender,
          classId: presentationStudent.classId,
          className: presentationStudent.className,
          photoUrl: null,
          dateOfBirth: DateFormat(
            'yyyy-MM-dd',
          ).parse(presentationStudent.dateOfBirth),
          parentId: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Save to database using repository
        await studentRepository.saveStudent(domainStudent);

        debugPrint(
          'New student saved to database: ${presentationStudent.fullName}',
        );

        // Show success message and navigate back
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Student ${presentationStudent.fullName} added successfully!',
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
        print('Error saving student: $e');
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
      appBar: AppBar(title: const Text('Add New Student'), elevation: 0),
      body:
          _isLoadingClasses
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
              : _classes.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 64,
                      color: Colors.orange,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No classes available',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Please add classes before adding students.'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadClasses,
                      child: Text('Retry'),
                    ),
                  ],
                ),
              )
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
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child:
                              _isLoading
                                  ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text('Saving...'),
                                    ],
                                  )
                                  : const Text('Add Student'),
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
