import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  @JsonKey(name: 'text')
  final String text;

  @JsonKey(name: 'senderId')
  final String senderId;

  @JsonKey(name: 'chatId')
  final String chatId;

  @JsonKey(name: 'isPhoto')
  final bool isPhoto;

  Message(
      {required this.text,
      required this.senderId,
      required this.chatId,
      required this.isPhoto});

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
