import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insighted/domain/entities/student.dart';

abstract class StudentRemoteDataSource {
  Future<List<Student>> getAllStudents();
  Future<Student?> getStudentById(String id);
  Future<void> createStudent(Student student);
  Future<void> updateStudent(Student student);
  Future<void> deleteStudent(String id);
  Future<List<Student>> getStudentsByClass(String classId);
}

class StudentRemoteDataSourceImpl implements StudentRemoteDataSource {
  final FirebaseFirestore firestore;
  final String collectionName = 'students';

  StudentRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<Student>> getAllStudents() async {
    try {
      final snapshot = await firestore.collection(collectionName).get();
      return snapshot.docs.map((doc) => _docToStudent(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get students from Firestore: $e');
    }
  }

  @override
  Future<Student?> getStudentById(String id) async {
    try {
      final doc = await firestore.collection(collectionName).doc(id).get();
      if (!doc.exists) {
        return null;
      }
      return _docToStudent(doc);
    } catch (e) {
      throw Exception('Failed to get student from Firestore: $e');
    }
  }

  @override
  Future<void> createStudent(Student student) async {
    try {
      await firestore
          .collection(collectionName)
          .doc(student.id)
          .set(_studentToMap(student));
    } catch (e) {
      throw Exception('Failed to create student in Firestore: $e');
    }
  }

  @override
  Future<void> updateStudent(Student student) async {
    try {
      await firestore
          .collection(collectionName)
          .doc(student.id)
          .update(_studentToMap(student));
    } catch (e) {
      throw Exception('Failed to update student in Firestore: $e');
    }
  }

  @override
  Future<void> deleteStudent(String id) async {
    try {
      await firestore.collection(collectionName).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete student from Firestore: $e');
    }
  }

  @override
  Future<List<Student>> getStudentsByClass(String classId) async {
    try {
      final snapshot =
          await firestore
              .collection(collectionName)
              .where('classId', isEqualTo: classId)
              .get();
      return snapshot.docs.map((doc) => _docToStudent(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get students by class from Firestore: $e');
    }
  }

  // Helper methods
  Student _docToStudent(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Student(
      id: doc.id,
      name: data['name'],
      studentNumber: data['studentNumber'],
      gender: data['gender'],
      classId: data['classId'],
      className: data['className'],
      photoUrl: data['photoUrl'],
      dateOfBirth: (data['dateOfBirth'] as Timestamp).toDate(),
      parentId: data['parentId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> _studentToMap(Student student) {
    return {
      'name': student.name,
      'studentNumber': student.studentNumber,
      'gender': student.gender,
      'classId': student.classId,
      'className': student.className,
      'photoUrl': student.photoUrl,
      'dateOfBirth': Timestamp.fromDate(student.dateOfBirth),
      'parentId': student.parentId,
      'createdAt': Timestamp.fromDate(student.createdAt),
      'updatedAt': Timestamp.fromDate(student.updatedAt),
    };
  }
}
