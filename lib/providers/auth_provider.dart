import 'package:flutter/material.dart';
import 'package:storyapp_dicoding/api/api_service.dart';
import 'package:storyapp_dicoding/data/preferences/auth_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService apiService;
  final AuthPreferences authPreferences;

  AuthProvider({required this.apiService, required this.authPreferences}) {
    _loadLoginStatus();
  }

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _message = '';
  String get message => _message;

  Future<void> _loadLoginStatus() async {
    _isLoggedIn = await authPreferences.isLoggedIn();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiService.login(email, password);
      if (!response.error) {
        final loginResult = response.loginResult;
        if (loginResult != null) {
          await authPreferences.saveToken(loginResult.token);
          await authPreferences.setLoggedIn(true);
          _isLoggedIn = true;
          _message = response.message;
          notifyListeners();
          return true;
        }
      }
      _message = response.message;
      notifyListeners();
      return false;
    } catch (e) {
      _message = 'Failed to connect to the server.';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiService.register(name, email, password);
      if (!response.error) {
        _message = response.message;
        notifyListeners();
        return true;
      }
      _message = response.message;
      notifyListeners();
      return false;
    } catch (e) {
      _message = 'Failed to connect to the server.';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await authPreferences.clearToken();
    await authPreferences.setLoggedIn(false);
    _isLoggedIn = false;
    notifyListeners();
  }
}
