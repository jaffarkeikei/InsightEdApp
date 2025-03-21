import 'package:flutter/foundation.dart';
import 'package:insighted/data/repositories/class_repository_impl.dart';
import 'package:insighted/domain/entities/class_group.dart';

class ClassProvider extends ChangeNotifier {
  final ClassRepository _repository;

  List<ClassGroup> _classes = [];
  ClassGroup? _selectedClass;
  bool _isLoading = false;
  String? _error;

  ClassProvider({required ClassRepository repository})
    : _repository = repository;

  // Getters
  List<ClassGroup> get classes => _classes;
  ClassGroup? get selectedClass => _selectedClass;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  // Methods
  Future<void> loadClasses() async {
    _setLoading(true);
    try {
      _classes = await _repository.getAllClasses();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshClasses() async {
    try {
      _classes = await _repository.getAllClasses();
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> getClassById(String id) async {
    _setLoading(true);
    try {
      _selectedClass = await _repository.getClassById(id);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addClass(ClassGroup classGroup) async {
    _setLoading(true);
    try {
      await _repository.saveClass(classGroup);
      await refreshClasses();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateClass(ClassGroup classGroup) async {
    _setLoading(true);
    try {
      await _repository.updateClass(classGroup);
      await refreshClasses();
      if (_selectedClass != null && _selectedClass!.id == classGroup.id) {
        _selectedClass = classGroup;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteClass(String id) async {
    _setLoading(true);
    try {
      await _repository.deleteClass(id);
      if (_selectedClass != null && _selectedClass!.id == id) {
        _selectedClass = null;
      }
      await refreshClasses();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<List<ClassGroup>> getClassesByTeacher(String teacherId) async {
    _setLoading(true);
    try {
      final classes = await _repository.getClassesByTeacher(teacherId);
      _error = null;
      _setLoading(false);
      return classes;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return [];
    }
  }

  void selectClass(ClassGroup classGroup) {
    _selectedClass = classGroup;
    notifyListeners();
  }

  void clearSelectedClass() {
    _selectedClass = null;
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
