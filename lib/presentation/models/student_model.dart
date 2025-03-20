class Student {
  final String id;
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String gender;
  final String classId;
  final String className;
  final String guardianName;
  final String guardianContact;
  final String guardianEmail;
  final String address;
  final String admissionDate;
  final String? profileImageUrl;

  const Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.classId,
    required this.className,
    required this.guardianName,
    required this.guardianContact,
    required this.guardianEmail,
    required this.address,
    required this.admissionDate,
    this.profileImageUrl,
  });

  // Full name getter
  String get fullName => '$firstName $lastName';

  // Factory constructor to create from JSON
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      classId: json['classId'],
      className: json['className'],
      guardianName: json['guardianName'],
      guardianContact: json['guardianContact'],
      guardianEmail: json['guardianEmail'],
      address: json['address'],
      admissionDate: json['admissionDate'],
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
      'classId': classId,
      'className': className,
      'guardianName': guardianName,
      'guardianContact': guardianContact,
      'guardianEmail': guardianEmail,
      'address': address,
      'admissionDate': admissionDate,
      'profileImageUrl': profileImageUrl,
    };
  }
}
