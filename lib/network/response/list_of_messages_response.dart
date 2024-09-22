import 'package:json_annotation/json_annotation.dart';
import 'package:MysteryConnect/network/entity/db_message.dart';
import 'package:MysteryConnect/network/entity/message.dart';

import '../entity/user.dart';

part 'list_of_messages_response.g.dart';

@JsonSerializable()
class ListOfMessagesResponse {
  @JsonKey(name: "message")
  final String message;

  @JsonKey(name: "success")
  final bool success;

  @JsonKey(name: "messages")
  final List<DbMessage> messages;

  ListOfMessagesResponse(this.message, this.success, this.messages);

  factory ListOfMessagesResponse.fromJson(Map<String, dynamic> json) =>
      _$ListOfMessagesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListOfMessagesResponseToJson(this);
}
