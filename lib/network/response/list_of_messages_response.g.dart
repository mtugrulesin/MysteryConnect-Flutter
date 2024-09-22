// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_of_messages_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListOfMessagesResponse _$ListOfMessagesResponseFromJson(
        Map<String, dynamic> json) =>
    ListOfMessagesResponse(
      json['message'] as String,
      json['success'] as bool,
      (json['messages'] as List<dynamic>)
          .map((e) => DbMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListOfMessagesResponseToJson(
        ListOfMessagesResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'messages': instance.messages,
    };
