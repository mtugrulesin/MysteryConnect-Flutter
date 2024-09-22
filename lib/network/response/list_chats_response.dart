import 'package:json_annotation/json_annotation.dart';
import 'package:MysteryConnect/network/entity/chat.dart';

import '../entity/user.dart';

part 'list_chats_response.g.dart';

@JsonSerializable()
class ListChatsResponse {
  @JsonKey(name: "message")
  final String message;

  @JsonKey(name: "success")
  final bool success;

  @JsonKey(name: "chats")
  final List<Chat> chats;

  ListChatsResponse(this.message, this.success, this.chats);

  factory ListChatsResponse.fromJson(Map<String, dynamic> json) =>
      _$ListChatsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListChatsResponseToJson(this);
}
