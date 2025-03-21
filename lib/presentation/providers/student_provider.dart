import 'package:flutter/foundation.dart';
import 'package:insighted/data/repositories/student_repository_impl.dart';
import 'package:insighted/domain/entities/student.dart';

class StudentProvider extends ChangeNotifier {
  final StudentRepository _repository;

  List<Student> _students = [];
  Student? _selectedStudent;
  bool _isLoading = false;
  String? _error;

  StudentProvider({required StudentRepository repository})
    : _repository = repository;

  // Getters
  List<Student> get students => _students;
  Student? get selectedStudent => _selectedStudent;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  // Methods
  Future<void> loadStudents() async {
    _setLoading(true);
    try {
      _students = await _repository.getAllStudents();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshStudents() async {
    try {
      _students = await _repository.getAllStudents();
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> getStudentById(String id) async {
    _setLoading(true);
    try {
      _selectedStudent = await _repository.getStudentById(id);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addStudent(Student student) async {
    _setLoading(true);
    try {
      await _repository.saveStudent(student);
      await refreshStudents();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateStudent(Student student) async {
    _setLoading(true);
    try {
      await _repository.updateStudent(student);
      await refreshStudents();
      if (_selectedStudent != null && _selectedStudent!.id == student.id) {
        _selectedStudent = student;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteStudent(String id) async {
    _setLoading(true);
    try {
      await _repository.deleteStudent(id);
      if (_selectedStudent != null && _selectedStudent!.id == id) {
        _selectedStudent = null;
      }
      await refreshStudents();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<List<Student>> getStudentsByClass(String classId) async {
    _setLoading(true);
    try {
      final students = await _repository.getStudentsByClass(classId);
      _error = null;
      _setLoading(false);
      return students;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return [];
    }
  }

  void selectStudent(Student student) {
    _selectedStudent = student;
    notifyListeners();
  }

  void clearSelectedStudent() {
    _selectedStudent = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
