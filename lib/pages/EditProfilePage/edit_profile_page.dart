import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../network/entity/user.dart';
import '../../network/response/login_response.dart';
import '../../network/services/UserService/user_api_service.dart';
import '../../utilities/constants.dart';
import '../ProfilePage/page_profile.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState(user);
}

class _EditProfilePageState extends State<EditProfilePage> {
  User user;

  _EditProfilePageState(this.user);

  @override
  Widget build(BuildContext context) {
    final ImagePicker _picker = ImagePicker();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFFF9A00),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF5A00),
              Color(0xFFFF9A00),
              Color(0xFFFF9A00),
              Color(0xFFFF5A00),
            ],
            stops: [0.1, 0.4, 0.7, 0.9],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      "http://$baseIP/api/v1/photo/getPhotoById/${user.photoId}",
                    ),
                    radius: 70,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _getFromGallery(user);
                        });
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent.withAlpha(180),
                        radius: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit),
                            Text("Edit"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, mainAxisSpacing: 0, childAspectRatio: 1),
                itemCount: 9,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Colors.amber,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: index < user.photoList.length
                            ? Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      "http://$baseIP/api/v1/photo/getPhotoById/${user.photoList[index].id}",
                                    ),
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: SizedBox(
                                    height: 35,
                                    child: FloatingActionButton(
                                      heroTag: "btnRemoveSavedPhoto${index}",
                                      onPressed: () {
                                        removePhoto(context, user.id,
                                                user.photoList[index].id)
                                            .then((value) => {
                                                  Navigator.of(context).pop(),
                                                  setState(() {
                                                    user = userTemp;
                                                  })
                                                });
                                      },
                                      backgroundColor: Colors.red,
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _getFromGallery2(user);
                                  });
                                },
                                child: Icon(Icons.add_a_photo_outlined),
                              )),
                  );
                },
              ),
              TextButton(
                style: ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(width: 3, color: Colors.white),
                    ))),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Save Edits",
                    style: TextStyle(
                      color: Color.fromARGB(255, 56, 96, 164),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getFromGallery(User userT) async {
    ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    File file = File(pickedFile!.path);
    await updatePP(userT.id, file) as User;

    return user;
  }

  _getFromGallery2(User userT) async {
    ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    File file = File(pickedFile!.path);
    await updatePhotos(userT.id, file) as User;

    return user;
  }

  Future<dynamic> updatePP(String userId, File imageFile) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse("http://$baseIP/api/v1/user/updatePP"));
    request.files.add(http.MultipartFile(
        'imageFile', imageFile.readAsBytes().asStream(), imageFile.lengthSync(),
        filename: imageFile.path.split("/").last));
    request.fields['userId'] = userId;
    final res = (await request.send());
    var response = await res.stream.transform(utf8.decoder).join();
    LoginResponse lR = LoginResponse.fromJson(jsonDecode(response));

    if (lR.success) {
      setState(() {
        userTemp = lR.user;
        user = userTemp;
        ProfilePage.activeUser = userTemp;
      });
    } else {
      print(lR.message);
    }
    return lR.user;
  }

  Future<dynamic> updatePhotos(String userId, File imageFile) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse("http://$baseIP/api/v1/user/updatePhoto"));
    request.files.add(http.MultipartFile(
        'imageFile', imageFile.readAsBytes().asStream(), imageFile.lengthSync(),
        filename: imageFile.path.split("/").last));
    request.fields['userId'] = userId;
    final res = (await request.send());
    var response = await res.stream.transform(utf8.decoder).join();
    LoginResponse lR = LoginResponse.fromJson(jsonDecode(response));

    if (lR.success) {
      setState(() {
        userTemp = lR.user;
        user = userTemp;
        ProfilePage.activeUser = userTemp;
      });
    }
    return lR.user;
  }
}

Future<void> removePhoto(BuildContext context, String userId, String photoId) {
  Future<void> deletePhotoToList(String userId, String photoId) async {
    Dio dio = Dio();
    UserApiService apiService =
        UserApiService(dio, baseUrl: "http://$baseIP/api/v1/");

    try {
      final res = await apiService.deletePhotoToList(userId, photoId);
      userTemp = res.user;
    } catch (err) {
      debugPrint("Photo Delete to List Connection Error : $err");
    }
  }

  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: const Text(
          'Are you sure to Delete this photo ?',
          style: TextStyle(fontSize: 18),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 15,
              ),
              // const Divider(color: Colors.black),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: const Text('Delete',
                        style: TextStyle(color: Colors.red, fontSize: 20)),
                    onPressed: () {
                      deletePhotoToList(userId, photoId)
                          .then((value) => Navigator.of(context).pop());
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
