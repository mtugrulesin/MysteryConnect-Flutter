// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      id: json['id'] as String,
      members:
          (json['members'] as List<dynamic>).map((e) => e as String).toList(),
      lastMessageTime: json['lastMessageTime'] as int,
      isRead: Map<String, bool>.from(json['isRead'] as Map),
    );

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'id': instance.id,
      'members': instance.members,
      'lastMessageTime': instance.lastMessageTime,
      'isRead': instance.isRead,
    };
