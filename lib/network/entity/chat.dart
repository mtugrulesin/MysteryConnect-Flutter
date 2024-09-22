import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

@JsonSerializable()
class Chat {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'members')
  final List<String> members;

  @JsonKey(name: 'lastMessageTime')
  final int lastMessageTime;

  @JsonKey(name: 'isRead')
  final Map<String, bool> isRead;

  Chat({
    required this.id,
    required this.members,
    required this.lastMessageTime,
    required this.isRead,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);
}
