// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DbMessage _$DbMessageFromJson(Map<String, dynamic> json) => DbMessage(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      date: json['date'] as int,
      chatId: json['chatId'] as String,
    );

Map<String, dynamic> _$DbMessageToJson(DbMessage instance) => <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'message': instance.message,
      'type': instance.type,
      'date': instance.date,
      'chatId': instance.chatId,
    };
