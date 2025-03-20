class Teacher {
  final String id;
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String gender;
  final String email;
  final String phone;
  final String address;
  final String employmentDate;
  final List<String> subjects;
  final List<String> classIds;
  final String qualification;
  final String experience;
  final String? profileImageUrl;

  const Teacher({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.email,
    required this.phone,
    required this.address,
    required this.employmentDate,
    required this.subjects,
    required this.classIds,
    required this.qualification,
    required this.experience,
    this.profileImageUrl,
  });

  // Full name getter
  String get fullName => '$firstName $lastName';

  // Factory constructor to create from JSON
  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      employmentDate: json['employmentDate'],
      subjects: List<String>.from(json['subjects']),
      classIds: List<String>.from(json['classIds']),
      qualification: json['qualification'],
      experience: json['experience'],
      profileImageUrl: json['profileImageUrl'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'email': email,
      'phone': phone,
      'address': address,
      'employmentDate': employmentDate,
      'subjects': subjects,
      'classIds': classIds,
      'qualification': qualification,
      'experience': experience,
      'profileImageUrl': profileImageUrl,
    };
  }
}
