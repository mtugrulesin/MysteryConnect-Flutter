import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:MysteryConnect/network/services/ChatService/chat_service.dart';
import 'package:MysteryConnect/pages/MessagePage/page_message.dart';
import 'package:MysteryConnect/ws/wsHelper.dart';
import 'package:uuid/uuid.dart';

import '../../network/entity/chat.dart';
import '../../network/entity/user.dart';
import '../../utilities/constants.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  late List<Chat> chats = [];

  wsHelper ws = wsHelper();
  late StompClient stompClient;
  Future<void> getMyChats(String id) async {
    Dio dio = Dio();
    ChatService chatService = ChatService(dio,baseUrl: "http://$baseIP/api/v1/");
    try {
      final res = await chatService.getUserChats(id);
      print(res);
      if (res.isNotEmpty) {
        setState(() {
          chats = res;
        });
        print(res);
      }
    } catch (err) {
      print(err);
      setState(() {
        chats = [];
      });
    }
  }

  late User user;

  void _update(dynamic) {
    print("test");
    setState(() {
      getMyChats(user.id);
    });
  }

  @override
  void initState() {
    user = userTemp;
    super.initState();
    stompClient = ws.connectWS();
    getMyChats(user.id);
    try {
      Future.delayed(
        Duration(seconds: 2),
        () {
          stompClient.subscribe(
            destination: '/user/topic/private-notifications',
            headers: {},
            callback: (frame) {
              _update(dynamic);
            },
          );
        },
      );
    } catch (_) {
      print("No Connection to STOMP");
    }
    // setState(() {
    //   getMyChats(user.id);
    // });
  }

  @override
  Widget build(BuildContext context) {
    //getMyChats(user.id);
    User user = userTemp;
    return RefreshIndicator(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFF9A00),
                Color(0xFFFF9A00),
                Color(0xFFFF5A00),
              ],
              stops: [0.1, 0.4, 0.7],
            ),
          ),
          child: chats.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: chats.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _messageRow(chats[index], user.id, context, _update);
                  })
              : Container(
                  child: const Center(
                    child: Text(
                      "No Message Yet",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
        ),
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              getMyChats(user.id);
            });
          });
        });
  }
}

String createAnonName(Chat chat) {
  var uuid = const Uuid();
  var anonName = uuid.v5(Uuid.NAMESPACE_URL, chat.id.toString());
  return anonName.split('-')[4];
}

Widget _messageRow(
    Chat chat, String userId, BuildContext context, ValueChanged<String> vs) {
  final ValueChanged<String> va = vs;
  return GestureDetector(
    onTap: () {
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (context) => MessagePage(
                chat: chat,
              ),
            ),
          )
          .then((value) => va(""));
    },
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          alignment: Alignment.centerRight,
          // ignore: sort_child_properties_last
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ignore: prefer_const_constructors
                  CircleAvatar(
                      // ignore: prefer_const_constructors
                      backgroundImage: AssetImage("assets/user.png")),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      Text(
                        "NoName-${createAnonName(chat)}",
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Icon(Icons.check),
                          Text(
                            "Your are very dangerous",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      SizedBox(
                        height: 30,
                        child: CircleAvatar(
                          backgroundColor: chat.isRead[userId]!
                              ? Colors.transparent
                              : Colors.red,
                          child: Text(
                            chat.isRead[userId]! ? "" : "1",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
          decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.blueGrey,
                    offset: Offset(0.0, 0.1),
                    blurRadius: 6.0)
              ],
              color: Colors.white,
              border: Border(),
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
        ),
        const SizedBox(
          height: 12,
        )
      ],
    ),
  );
}
