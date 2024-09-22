import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../network/entity/user.dart';
import '../../utilities/constants.dart';
import '../PhotoPage/page_photo.dart';
import 'package:http/http.dart' as http;

class PhotoReplyPage extends StatefulWidget {
  const PhotoReplyPage({super.key, required this.receiverId});

  final String receiverId;
  @override
  State<PhotoReplyPage> createState() => _PhotoReplyPageState();
}

class _PhotoReplyPageState extends State<PhotoReplyPage> {
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
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DisplayPictureScreen(
                                imagePath: image.path,
                                user: userTemp,
                                receiver: receiverId,
                              ),
                            ),
                          );
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

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final User user;
  final String receiver;
  const DisplayPictureScreen(
      {super.key,
      required this.imagePath,
      required this.user,
      required this.receiver});

  //send photo
  Future<dynamic> sendPhoto(String userId, File imageFile) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse("http://$baseIP/api/v1/photo/sendById"));
    request.files.add(http.MultipartFile(
        'imageFile', imageFile.readAsBytes().asStream(), imageFile.lengthSync(),
        filename: imageFile.path.split("/").last));
    request.fields['userId'] = userId;
    request.fields['receiverId'] = receiver;
    await request.send();
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
                    padding:
                        const EdgeInsets.only(right: 25, bottom: 25, left: 25),
                    height: 72,
                    decoration: const BoxDecoration(color: Colors.transparent),
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
