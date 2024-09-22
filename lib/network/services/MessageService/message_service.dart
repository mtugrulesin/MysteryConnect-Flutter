import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:MysteryConnect/network/entity/chat.dart';
import 'package:MysteryConnect/network/entity/message.dart';
import 'package:MysteryConnect/network/entity/stomp_message.dart';

part 'message_service.g.dart';

@RestApi(baseUrl: 'http://192.168.1.34:5000/')
abstract class MessageService {
  factory MessageService(Dio dio, {String? baseUrl}) = _MessageService;

  @POST('/send-private-message/{receiverId}/{senderId}/{type}')
  Future<dynamic> sendMessage(
      @Path("receiverId") String receiverId,
      @Path("senderId") String senderId,
      @Body() StompMessage message,
      @Path("type") String type);
}
