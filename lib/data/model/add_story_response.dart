import 'package:json_annotation/json_annotation.dart';

part 'add_story_response.g.dart';

@JsonSerializable()
class AddStoryResponse {
  final bool error;
  final String message;

  AddStoryResponse({required this.error, required this.message});

  factory AddStoryResponse.fromJson(Map<String, dynamic> json) =>
      _$AddStoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddStoryResponseToJson(this);
}
