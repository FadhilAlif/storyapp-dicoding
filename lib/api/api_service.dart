import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:storyapp_dicoding/data/model/add_story_response.dart';
import 'package:storyapp_dicoding/data/model/login_response.dart';
import 'package:storyapp_dicoding/data/model/register_response.dart';
import 'package:storyapp_dicoding/data/model/story_detail_response.dart';
import 'package:storyapp_dicoding/data/model/story_response.dart';

class ApiService {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1';

  Future<RegisterResponse> register(
      String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'password': password,
      }),
    );
    return RegisterResponse.fromJson(jsonDecode(response.body));
  }

  Future<LoginResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    return LoginResponse.fromJson(jsonDecode(response.body));
  }

  Future<StoryResponse> getStories(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/stories'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    return StoryResponse.fromJson(jsonDecode(response.body));
  }

  Future<StoryDetailResponse> getStoryDetail(String id, String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/stories/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    return StoryDetailResponse.fromJson(jsonDecode(response.body));
  }

  Future<AddStoryResponse> addNewStory(
      String token, String description, String filePath) async {
    final uri = Uri.parse('$_baseUrl/stories');
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['description'] = description;

    final file = await http.MultipartFile.fromPath('photo', filePath);
    request.files.add(file);

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    return AddStoryResponse.fromJson(jsonDecode(responseBody));
  }
}
