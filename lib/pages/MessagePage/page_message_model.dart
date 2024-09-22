import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:MysteryConnect/network/services/ChatService/chat_service.dart';

import '../../utilities/constants.dart';

class PageMessageModel {
  Future<void> createMessage(
      String senderId, String receiverId, String context, String chatId) async {
    Dio dio = Dio();
    ChatService apiService =
        ChatService(dio, baseUrl: "http://$baseIP/api/v1/");

    try {
      var req =
          await apiService.createMessage(senderId, receiverId, context, chatId);
      print(req);
    } catch (err) {
      debugPrint("Page Message Model Req ERR : $err");
    }
  }
}
