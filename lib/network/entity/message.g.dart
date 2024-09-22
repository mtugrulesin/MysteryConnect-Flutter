// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      text: json['text'] as String,
      senderId: json['senderId'] as String,
      chatId: json['chatId'] as String,
      isPhoto: json['isPhoto'] as bool,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'text': instance.text,
      'senderId': instance.senderId,
      'chatId': instance.chatId,
      'isPhoto': instance.isPhoto,
    };
