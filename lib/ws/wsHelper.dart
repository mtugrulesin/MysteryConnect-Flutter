import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:MysteryConnect/network/entity/stomp_message.dart';
import 'package:MysteryConnect/network/entity/user.dart';
import 'package:MysteryConnect/network/services/MessageService/message_service.dart';

import '../utilities/constants.dart';

class wsHelper {
  void onConnectCallback(StompFrame connectFrame) {
    // client is connected and ready
  }

  late User user;
  Future<void> sendMessageOverAPI(
      String id, String message, String type) async {
    Dio dio = Dio();
    MessageService apiService = MessageService(dio,
        baseUrl: "http://${baseIP.replaceAll(":8080", "")}:5000/");

    StompMessage sm = StompMessage(messageContent: message);
    try {
      var req = await apiService.sendMessage(id, user.id, sm, type);
      print(req);
    } catch (err) {
      debugPrint("STOMP Message Req ERR : $err");
    }
  }

  StompClient connectWS() {
    user = userTemp;
    print("ws://${baseIP.replaceAll(":8080", "")}:5000/sc-ws/websocket");
    StompClient client = StompClient(
      // ignore: prefer_const_constructors

      config: StompConfig(
        url: 'ws://${baseIP.replaceAll(":8080", "")}:5000/sc-ws/websocket',
        onConnect: onConnectCallback,
        //stompConnectHeaders: {"asd": "asd"},
        webSocketConnectHeaders: {"userId": user.id},
      ),
    );

    client.activate();

    return client;
  }

  void sendMessageOverSTOMP(StompClient client, String text) {
    print("heeee");
    client.send(
        destination: '/ws/private-message',
        // ignore: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation
        //body: "{\"messageContent\":\"" + text + "\"}",
        body: jsonEncode({
          "messageContent": text,
          "id": user.id,
        }),
        headers: {});
  }
}
