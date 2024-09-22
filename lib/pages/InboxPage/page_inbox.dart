import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:MysteryConnect/network/services/PhotoService/photo_service.dart';
import 'package:MysteryConnect/pages/PhotoReplyPage/photo_reply_page.dart';
import 'package:MysteryConnect/utilities/constants.dart';
import 'package:uuid/uuid.dart';
import '../../network/entity/photo.dart';
import '../../network/entity/user.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  late List<Photo> photos = [];

  Future<void> getMyPhotos(String id) async {
    Dio dio = Dio();
    PhotoService photoService = PhotoService(dio,baseUrl: "http://$baseIP/api/v1/");

    try {
      final res = await photoService.getMyPhotos(id);
      print("Inbox Res : ${res}");
      if (res.isNotEmpty) {
        setState(() {
          photos = res;
        });
        print(res);
      }
    } catch (err) {
      print(err.toString());
      setState(() {
        photos = [];
      });
    }
  }

  late Timer timer;

  @override
  void dispose() {
    super.dispose();
  }

  late User user;

  @override
  void initState() {
    user = userTemp;
    super.initState();
    getMyPhotos(user.id);
  }

  @override
  Widget build(BuildContext context) {
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
          child: photos.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: photos.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _photoRow(photos[index]);
                  })
              : Container(
                  child: const Center(
                    child: Text(
                      "No Photo Yet",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
        ),
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              getMyPhotos(user.id);
            });
          });
        });
  }

  String createAnonName(Photo photo) {
    var uuid = const Uuid();
    var anonName = uuid.v5(Uuid.NAMESPACE_URL, photo.photoUrl.toString());
    return anonName.split('-')[4];
  }

  String trimPhotoDate(Photo photo) {
    List splitOne = photo.photoUrl.split('-');
    List splitTwo = splitOne[1].toString().split('.');

    int timestamp = int.parse(splitTwo[0]);

    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    List splitDate = date.toString().split(' ');
    return splitDate[0];
  }

  // ignore: non_constant_identifier_names
  Widget PhotoPage1(Photo photo) {
    return Center(
        child: GestureDetector(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.network(
              "http://$baseIP/api/v1/photo/getPhotoById/${photo.id}",
              fit: BoxFit.contain,
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: SizedBox(
                  child: FloatingActionButton(
                    heroTag: "btnPhotoOpen",
                    backgroundColor: const Color(0xFFFF9A00),
                    elevation: 4,
                    onPressed: (() async {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PhotoReplyPage(
                                receiverId: photo.senderId,
                              )));
                    }),
                    child: const Icon(
                      Icons.replay,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              )),
        ],
      ),
      onTap: () {
        Navigator.pop(context);
        setState(() {
          getMyPhotos(user.id);
        });
      },
    ));
  }

  Widget _photoRow(Photo photo) {
    return Column(
      children: [
        Container(
          height: 56,
          padding: EdgeInsets.only(left: 8, right: 8),
          // ignore: sort_child_properties_last
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 46,
                    width: 46,
                    child: CircleAvatar(
                      backgroundColor: Color(0xFFec7034),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => PhotoPage1(photo)))
                              .then((value) => {
                                    removePhoto(photo.id),
                                    getMyPhotos(user.id),
                                  });
                        },
                        icon: const Icon(
                          Icons.photo_sharp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "NoName-${createAnonName(photo)}",
                    style: const TextStyle(
                        color: Color(0xFF090303), fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    trimPhotoDate(photo),
                    style: const TextStyle(
                        color: Color(0xFFc1c4bb), fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 9,
                  ),
                  SizedBox(
                    height: 46,
                    width: 46,
                    child: CircleAvatar(
                      backgroundColor: Color(0xFFec7034),
                      child: IconButton(
                        onPressed: () {
                          removePhoto(photo.id);
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Color(0xFFc6151b),
                    offset: Offset(0.0, 0.1),
                    blurRadius: 3.0)
              ],
              color: Color(0xFFFFF7EF),
              borderRadius: BorderRadius.all(
                Radius.circular(29.0),
              )),
        ),
        const SizedBox(
          height: 18,
        ),
      ],
    );
  }

  Future<void> _deletePhoto(Photo photo) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: const Text('Deleting a photo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                const Text('Are you sure you want to delete the photo?'),
                SizedBox(
                  height: 15,
                ),
                // const Divider(color: Colors.black),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      child: const Text('Delete',
                          style: TextStyle(color: Colors.blue, fontSize: 20)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        photos.remove(photo);
                      },
                    ),
                    TextButton(
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  removePhoto(photoId) {
    Future<void> deleteById(String id) async {
      Dio dio = Dio();
      PhotoService photoService = PhotoService(dio,baseUrl: "http://$baseIP/api/v1/");

      try {
        final res = await photoService.deleteById(id);

        if (res.success) {
          debugPrint(res.message);
          setState(() {
            photos.clear;
            getMyPhotos(user.id);
          });
        } else {
          debugPrint("res.messagessssss");
        }
      } catch (err) {
        debugPrint(err.toString());
      }
    }

    deleteById(photoId);
  }
}
