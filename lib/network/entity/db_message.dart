import 'package:json_annotation/json_annotation.dart';

part 'db_message.g.dart';

@JsonSerializable()
class DbMessage {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'senderId')
  final String senderId;

  @JsonKey(name: 'receiverId')
  final String receiverId;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'date')
  final int date;

  @JsonKey(name: 'chatId')
  final String chatId;

  DbMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.type,
    required this.date,
    required this.chatId,
  });

  factory DbMessage.fromJson(Map<String, dynamic> json) =>
      _$DbMessageFromJson(json);

  Map<String, dynamic> toJson() => _$DbMessageToJson(this);
}
