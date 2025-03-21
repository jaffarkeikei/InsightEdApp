import 'package:flutter/foundation.dart';
import 'package:insighted/data/repositories/auth_repository_impl.dart';
import 'package:insighted/domain/entities/user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  AuthProvider({required AuthRepository repository}) : _repository = repository;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;
  bool get isAuthenticated => _isAuthenticated;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    try {
      _currentUser = await _repository.signIn(email, password);
      _isAuthenticated = _currentUser != null;
      _error = null;
      notifyListeners();
      return _isAuthenticated;
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void signOut() {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<bool> createUser(User user, String password) async {
    _setLoading(true);
    try {
      await _repository.createUser(user, password);
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateUser(User user) async {
    _setLoading(true);
    try {
      await _repository.updateUser(user);
      if (_currentUser != null && _currentUser!.id == user.id) {
        _currentUser = user;
      }
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<List<User>> getUsersByRole(UserRole role) async {
    _setLoading(true);
    try {
      final users = await _repository.getUsersByRole(role);
      _error = null;
      return users;
    } catch (e) {
      _error = e.toString();
      return [];
    } finally {
      _setLoading(false);
    }
  }

  Future<User?> getUserByEmail(String email) async {
    _setLoading(true);
    try {
      final user = await _repository.getUserByEmail(email);
      _error = null;
      return user;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _setLoading(false);
    }
  }
}
