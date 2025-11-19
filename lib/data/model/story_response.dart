import 'package:storyapp_dicoding/data/model/story.dart';

class StoryResponse {
  final bool error;
  final String message;
  final List<Story> listStory;

  StoryResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory StoryResponse.fromJson(Map<String, dynamic> json) {
    return StoryResponse(
      error: json["error"],
      message: json["message"],
      listStory: List<Story>.from(
        json["listStory"].map((x) => Story.fromJson(x)),
      ),
    );
  }
}
