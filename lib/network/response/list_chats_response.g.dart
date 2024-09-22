// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_chats_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListChatsResponse _$ListChatsResponseFromJson(Map<String, dynamic> json) =>
    ListChatsResponse(
      json['message'] as String,
      json['success'] as bool,
      (json['chats'] as List<dynamic>)
          .map((e) => Chat.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListChatsResponseToJson(ListChatsResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'chats': instance.chats,
    };
