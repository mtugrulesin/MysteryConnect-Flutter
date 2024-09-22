import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:MysteryConnect/network/entity/db_message.dart';
import 'package:MysteryConnect/network/services/ChatService/chat_service.dart';
import 'package:MysteryConnect/network/services/MessageService/message_service.dart';
import 'package:MysteryConnect/pages/MessagePage/page_message_model.dart';
import 'package:MysteryConnect/utilities/constants.dart';
import 'package:MysteryConnect/ws/wsHelper.dart';

import '../../main.dart';
import '../../network/entity/chat.dart';
import '../../network/entity/message.dart';
import '../../network/entity/photo.dart';
import '../../network/entity/user.dart';
import 'package:http/http.dart' as http;

class MessagePage extends StatefulWidget {
  final Chat chat;
  const MessagePage({super.key, required this.chat});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  wsHelper qa = MyApp.qa;
  PageMessageModel pmm = PageMessageModel();

  TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late StompClient client;
  late String receiverId;
  late List<DbMessage> _messages;

  Future<void> getChatMessages(String chatId) async {
    Dio dio = Dio();
    ChatService apiService = ChatService(dio,baseUrl: "http://$baseIP/api/v1/");
    User user = userTemp;
    try {
      final res = await apiService.getChatMessages(chatId, user.id);

      if (res.success) {
        debugPrint("User Random is Success : ${res.message}");
        setState(() {
          _messages = res.messages;
        });
      } else {
        debugPrint("User Random is not success : ${res.message}");
      }
    } catch (err) {
      debugPrint("Connection Error : ${err.toString()}");
    }
  }

  void _update(DbMessage message) {
    messagesTemp.add(message);
    setState(() {
      _messages = messagesTemp;
    });
  }

  void _scrollDown() {
    _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 120,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn);
  }

  @override
  void initState() {
    messagesTemp.clear();
    User user = userTemp;
    _messages = messagesTemp;
    client = qa.connectWS();
    getChatMessages(widget.chat.id);
    Future.delayed(
      Duration(milliseconds: 1000),
      () {
        client.subscribe(
          destination: '/user/topic/private-messages',
          headers: {},
          callback: (frame) {
            // Received a frame for this subscription
            //print(json.decode(frame.body!)["userId"]);
            String sm = json.decode(frame.body!)["content"];
            String type = json.decode(frame.body!)["type"];
            String userFrom = json.decode(frame.body!)["userId"];

            print(" Bundan geldi  $userFrom");
            if (receiverId == userFrom) {
              final message = DbMessage(
                  id: "",
                  message: sm,
                  type: type,
                  senderId: receiverId,
                  receiverId: user.id,
                  date: 0,
                  chatId: widget.chat.id);
              setState(() {
                _messages.add(message);
              });
              _scrollDown();
            }
          },
        );
        client.subscribe(
          destination: '/user/topic/private-notifications',
          headers: {},
          callback: (frame) {},
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = userTemp;
    receiverId = widget.chat.members[0] == user.id
        ? widget.chat.members[1]
        : widget.chat.members[0];

    print("Diger Kisi $receiverId");
    return Scaffold(
      backgroundColor: Color(0xFFFF9A00),
      appBar: AppBar(
        title: const Text(
          "NoName-j04tkmglk4",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFFFF9A00),
      ),
      body: Column(
        children: [
          Expanded(
              child: GroupedListView<DbMessage, DateTime>(
            controller: _scrollController,
            padding: const EdgeInsets.all(8),
            elements: _messages,
            groupBy: (message) => DateTime(2023),
            groupHeaderBuilder: (DbMessage) => const SizedBox(
              height: 40,
              child: Center(
                child: Card(
                  color: Colors.blue,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Messages are deleted after viewing.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            itemBuilder: (context, DbMessage message) => Align(
              alignment: message.senderId == user.id
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: message.type == "PHOTO"
                  ? message.senderId == user.id
                      ? SenderPhotoBubble(
                          message: message,
                        )
                      : ReceiverPhotoBubble(
                          message: message,
                        )
                  : message.senderId == user.id
                      ? SenderBubble(
                          message: message,
                        )
                      : ReceiverBubble(
                          message: message,
                        ),
            ),
          )),
          Container(
            decoration: BoxDecoration(color: Color(0xFFFF9A00)),
            padding: const EdgeInsets.all(13),
            child: Row(
              children: [
                Flexible(
                  child: Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(29),
                            bottomLeft: Radius.circular(29),
                            bottomRight: Radius.circular(29),
                            topRight: Radius.circular(29))),
                    child: Row(
                      children: [
                        Flexible(
                          child: TextField(
                            controller: messageController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(12),
                              hintText: "Type Your Message Here",
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                            ),
                          ),
                        ),
                        FloatingActionButton(
                          heroTag: "btnMsgSend",
                          onPressed: () {
                            //qa.sendMessageOverSTOMP(client, messageController.text);
                            qa.sendMessageOverAPI(
                                receiverId, messageController.text, "CHAT");

                            pmm.createMessage(user.id, receiverId,
                                messageController.text, widget.chat.id);
                            final message = DbMessage(
                              id: "",
                              message: messageController.text,
                              type: "CHAT",
                              senderId: user.id,
                              receiverId: receiverId,
                              date: 0,
                              chatId: widget.chat.id,
                            );
                            setState(() {
                              _messages.add(message);
                              messageController.clear();
                            });
                            _scrollDown();
                          },
                          child: const Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                ),
                FloatingActionButton(
                  heroTag: "btnTakePhotoInMsg",
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) => PhotoReplyPage2(
                              receiverId: receiverId,
                              chatId: widget.chat.id,
                              va: _update,
                            ),
                          ),
                        )
                        .then((value) => {});
                    setState(() {
                      _messages = messagesTemp;
                    });
                  },
                  child: const Icon(Icons.camera_alt),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SenderBubble extends StatelessWidget {
  const SenderBubble({
    Key? key,
    required this.message,
  }) : super(key: key);
  final DbMessage message;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 38,
        top: 10,
      ),
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(29),
                bottomLeft: Radius.circular(29),
                bottomRight: Radius.circular(29))),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            message.message,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class ReceiverBubble extends StatelessWidget {
  const ReceiverBubble({
    Key? key,
    required this.message,
  }) : super(key: key);
  final DbMessage message;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
          right: 38,
          top: 10,
        ),
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(29),
                  bottomLeft: Radius.circular(29),
                  bottomRight: Radius.circular(29))),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              message.message,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ));
  }
}

class ReceiverPhotoBubble extends StatelessWidget {
  const ReceiverPhotoBubble({
    Key? key,
    required this.message,
  }) : super(key: key);
  final DbMessage message;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 38,
        top: 10,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  PhotoPageInMessagePage(message.message, context)));
        },
        child: Card(
          color: Colors.red,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(29),
                  bottomLeft: Radius.circular(29),
                  bottomRight: Radius.circular(29))),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: 150,
              child: Row(
                children: const [
                  Icon(
                    Icons.filter_1,
                    color: Colors.white,
                    size: 26,
                  ),
                  Spacer(),
                  Text(
                    "Open Photo",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
Widget PhotoPageInMessagePage(String photo, BuildContext context) {
  return Center(
      child: GestureDetector(
    child: Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Image.network(
            "http://$baseIP/api/v1/photo/getPhotoByUrl/$photo",
            fit: BoxFit.contain,
          ),
        ),
      ],
    ),
    onTap: () {
      Navigator.pop(context);
    },
  ));
}

class SenderPhotoBubble extends StatelessWidget {
  const SenderPhotoBubble({
    Key? key,
    required this.message,
  }) : super(key: key);
  final DbMessage message;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 10,
        top: 38,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  PhotoPageInMessagePage(message.message, context)));
        },
        child: Card(
          color: Colors.red,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(29),
                  bottomLeft: Radius.circular(29),
                  bottomRight: Radius.circular(29))),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: 150,
              child: Row(
                children: const [
                  Icon(
                    Icons.filter_1,
                    color: Colors.white,
                    size: 26,
                  ),
                  Spacer(),
                  Text(
                    "Open Photo",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PhotoReplyPage2 extends StatefulWidget {
  const PhotoReplyPage2(
      {super.key,
      required this.receiverId,
      required this.chatId,
      required this.va});
  final String chatId;
  final String receiverId;
  final ValueChanged<DbMessage> va;
  @override
  State<PhotoReplyPage2> createState() => _PhotoReplyPageState2();
}

class _PhotoReplyPageState2 extends State<PhotoReplyPage2> {
  late String receiverId;
  late CameraController controller;
  bool camDir = false;
  late bool camFlash;

  @override
  void initState() {
    super.initState();
    controller = CameraController(MyApp.cameras[0], ResolutionPreset.max);
    camDir = true;
    camFlash = true;
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            break;
          default:
            break;
        }
      }
    });
    receiverId = widget.receiverId;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.value.isInitialized) {
      final size = MediaQuery.of(context).size;

      var scale = size.aspectRatio * controller.value.aspectRatio;
      if (scale < 1) scale = 1 / scale;

      // to prevent scaling down, invert the value

      return Scaffold(
        backgroundColor: Colors.black,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: Stack(children: [
                Transform.scale(
                  scale: scale,
                  alignment: Alignment.topCenter,
                  child: Center(
                    child: CameraPreview(controller),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Container(
                      padding: const EdgeInsets.only(bottom: 15),
                      margin: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                      child: FloatingActionButton(
                        heroTag: "btnTakePic",
                        elevation: 4,
                        onPressed: (() async {
                          final image = await controller.takePicture();
                          controller.setFlashMode(FlashMode.off);

                          // ignore: use_build_context_synchronously
                          await Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (context) => DisplayPictureScreen2(
                                    imagePath: image.path,
                                    user: userTemp,
                                    receiver: receiverId,
                                    chatId: widget.chatId,
                                    va: widget.va,
                                  ),
                                ),
                              )
                              .then((value) => Navigator.of(context).pop());
                        }),
                        child: const Icon(Icons.camera_alt),
                      )),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Container(
                      padding: const EdgeInsets.only(bottom: 15, left: 25),
                      margin: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                      child: FloatingActionButton(
                        heroTag: "btnSetFlash",
                        backgroundColor: Colors.black.withAlpha(100),
                        elevation: 4,
                        onPressed: (() async {
                          if (camFlash) {
                            controller.setFlashMode(FlashMode.off);
                            camFlash = false;
                          } else {
                            controller.setFlashMode(FlashMode.torch);
                            camFlash = true;
                          }
                        }),
                        child: const Icon(
                          Icons.flash_auto,
                          color: Colors.white,
                          size: 30,
                        ),
                      )),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: Container(
                      padding: const EdgeInsets.only(bottom: 15, right: 25),
                      child: FloatingActionButton(
                        heroTag: "btnChangeMode",
                        backgroundColor: Colors.black.withAlpha(100),
                        elevation: 4,
                        onPressed: (() async {
                          //return camera
                          setState(() {
                            if (camDir) {
                              camDir = false;
                              controller = CameraController(
                                  MyApp.cameras[0], ResolutionPreset.max);
                              controller.initialize().then((_) {
                                setState(() {});
                              }).catchError((Object e) {
                                if (e is CameraException) {
                                  switch (e.code) {
                                    case 'CameraAccessDenied':
                                      break;
                                    default:
                                      break;
                                  }
                                }
                              });
                            } else {
                              camDir = true;
                              controller = CameraController(
                                  MyApp.cameras[1], ResolutionPreset.max);
                              controller.initialize().then((_) {
                                setState(() {});
                              }).catchError((Object e) {
                                if (e is CameraException) {
                                  switch (e.code) {
                                    case 'CameraAccessDenied':
                                      break;
                                    default:
                                      break;
                                  }
                                }
                              });
                            }
                          });
                        }),
                        child: const Icon(
                          Icons.change_circle_sharp,
                          color: Colors.white,
                          size: 40,
                        ),
                      )),
                ),
              ]),
            );
          },
        ),
      );
    } else {
      return Container(
        color: Colors.black,
      );
    }
  }
}

class DisplayPictureScreen2 extends StatelessWidget {
  final String imagePath;
  final User user;
  final String receiver;
  final String chatId;
  final ValueChanged<DbMessage> va;
  const DisplayPictureScreen2({
    super.key,
    required this.imagePath,
    required this.user,
    required this.receiver,
    required this.chatId,
    required this.va,
  });

  //send photo
  Future<dynamic> sendPhoto(String userId, File imageFile) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse("http://$baseIP/api/v1/photo/sendByIdFromMessage"));
    request.files.add(http.MultipartFile(
        'imageFile', imageFile.readAsBytes().asStream(), imageFile.lengthSync(),
        filename: imageFile.path.split("/").last));
    request.fields['userId'] = userId;
    request.fields['receiverId'] = receiver;
    request.fields['chatId'] = chatId;
    await request.send();
    MyApp.qa
        .sendMessageOverAPI(receiver, imageFile.path.split("/").last, "PHOTO");
    final message = DbMessage(
      id: "",
      message: imageFile.path.split("/").last,
      type: "PHOTO",
      senderId: userId,
      receiverId: receiver,
      date: 0,
      chatId: chatId,
    );
    va(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Stack(
              children: [
                Image.file(
                  File(imagePath),
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(right: 25, bottom: 25, left: 25),
                    height: 72,
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: Row(
                      children: [
                        const Spacer(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            style: ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.amber),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: const BorderSide(
                                      width: 3, color: Colors.white),
                                ))),
                            onPressed: () {
                              sendPhoto(user.id, File(imagePath))
                                  .then((value) => {
                                        Navigator.of(context).pop(),
                                      });
                            },
                            child: SizedBox(
                              child: Row(
                                children: const [
                                  Text(
                                    "Send",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
