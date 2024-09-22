import 'package:json_annotation/json_annotation.dart';

part 'stomp_message.g.dart';

@JsonSerializable()
class StompMessage {
  @JsonKey(name: 'messageContent')
  final String messageContent;

  StompMessage({
    required this.messageContent,
  });

  factory StompMessage.fromJson(Map<String, dynamic> json) =>
      _$StompMessageFromJson(json);

  Map<String, dynamic> toJson() => _$StompMessageToJson(this);
}
