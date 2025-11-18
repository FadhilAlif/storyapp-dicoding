import 'package:flutter/material.dart';
import 'package:storyapp_dicoding/api/api_service.dart';
import 'package:storyapp_dicoding/data/model/story.dart';
import 'package:storyapp_dicoding/data/preferences/auth_preferences.dart';

enum ResultState { loading, noData, hasData, error }

class StoryProvider extends ChangeNotifier {
  final ApiService apiService;
  final AuthPreferences authPreferences;

  StoryProvider({required this.apiService, required this.authPreferences}) {
    _fetchStories();
  }

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<Story> _stories = [];
  List<Story> get stories => _stories;

  Story? _story;
  Story? get story => _story;

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  String _uploadMessage = '';
  String get uploadMessage => _uploadMessage;

  Future<void> _fetchStories() async {
    _state = ResultState.loading;
    notifyListeners();
    try {
      final token = await authPreferences.getToken();
      if (token == null) {
        _state = ResultState.error;
        _message = 'Authentication token not found.';
        notifyListeners();
        return;
      }
      final response = await apiService.getStories(token);
      if (response.listStory.isEmpty) {
        _state = ResultState.noData;
        _message = 'No stories found.';
      } else {
        _state = ResultState.hasData;
        _stories = response.listStory;
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Failed to load stories. Please check your connection.';
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchStoryDetail(String id) async {
    _state = ResultState.loading;
    notifyListeners();
    try {
      final token = await authPreferences.getToken();
      if (token == null) {
        _state = ResultState.error;
        _message = 'Authentication token not found.';
        notifyListeners();
        return;
      }
      final response = await apiService.getStoryDetail(id, token);
      _state = ResultState.hasData;
      _story = response.story;
    } catch (e) {
      _state = ResultState.error;
      _message = 'Failed to load story detail.';
    } finally {
      notifyListeners();
    }
  }

  Future<bool> addNewStory(String description, String filePath) async {
    _isUploading = true;
    notifyListeners();
    try {
      final token = await authPreferences.getToken();
      if (token == null) {
        _uploadMessage = 'Authentication token not found.';
        return false;
      }
      final response =
          await apiService.addNewStory(token, description, filePath);
      if (!response.error) {
        await refreshStories();
        return true;
      } else {
        _uploadMessage = response.message;
        return false;
      }
    } catch (e) {
      _uploadMessage = 'Failed to upload story. Please try again.';
      return false;
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  Future<void> refreshStories() async {
    await _fetchStories();
  }
}
