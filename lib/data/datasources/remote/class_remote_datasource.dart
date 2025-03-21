import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insighted/domain/entities/class_group.dart';

abstract class ClassRemoteDataSource {
  Future<List<ClassGroup>> getAllClasses();
  Future<ClassGroup?> getClassById(String id);
  Future<void> createClass(ClassGroup classGroup);
  Future<void> updateClass(ClassGroup classGroup);
  Future<void> deleteClass(String id);
  Future<List<ClassGroup>> getClassesByTeacher(String teacherId);
}

class ClassRemoteDataSourceImpl implements ClassRemoteDataSource {
  final FirebaseFirestore firestore;
  final String collectionName = 'classes';

  ClassRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ClassGroup>> getAllClasses() async {
    try {
      final snapshot = await firestore.collection(collectionName).get();
      return snapshot.docs.map((doc) => _docToClass(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get classes from Firestore: $e');
    }
  }

  @override
  Future<ClassGroup?> getClassById(String id) async {
    try {
      final doc = await firestore.collection(collectionName).doc(id).get();
      if (!doc.exists) {
        return null;
      }
      return _docToClass(doc);
    } catch (e) {
      throw Exception('Failed to get class from Firestore: $e');
    }
  }

  @override
  Future<void> createClass(ClassGroup classGroup) async {
    try {
      await firestore
          .collection(collectionName)
          .doc(classGroup.id)
          .set(_classToMap(classGroup));
    } catch (e) {
      throw Exception('Failed to create class in Firestore: $e');
    }
  }

  @override
  Future<void> updateClass(ClassGroup classGroup) async {
    try {
      await firestore
          .collection(collectionName)
          .doc(classGroup.id)
          .update(_classToMap(classGroup));
    } catch (e) {
      throw Exception('Failed to update class in Firestore: $e');
    }
  }

  @override
  Future<void> deleteClass(String id) async {
    try {
      await firestore.collection(collectionName).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete class from Firestore: $e');
    }
  }

  @override
  Future<List<ClassGroup>> getClassesByTeacher(String teacherId) async {
    try {
      final snapshot =
          await firestore
              .collection(collectionName)
              .where('teacherId', isEqualTo: teacherId)
              .get();
      return snapshot.docs.map((doc) => _docToClass(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get classes by teacher from Firestore: $e');
    }
  }

  // Helper methods
  ClassGroup _docToClass(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ClassGroup(
      id: doc.id,
      name: data['name'],
      description: data['description'],
      grade: data['grade'],
      teacherId: data['teacherId'],
      teacherName: data['teacherName'],
      academicYear: data['academicYear'],
      term: data['term'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> _classToMap(ClassGroup classGroup) {
    return {
      'name': classGroup.name,
      'description': classGroup.description,
      'grade': classGroup.grade,
      'teacherId': classGroup.teacherId,
      'teacherName': classGroup.teacherName,
      'academicYear': classGroup.academicYear,
      'term': classGroup.term,
      'createdAt': Timestamp.fromDate(classGroup.createdAt),
      'updatedAt': Timestamp.fromDate(classGroup.updatedAt),
    };
  }
}
