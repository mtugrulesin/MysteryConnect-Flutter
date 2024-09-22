import 'package:MysteryConnect/pages/PlanPage/mm.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:MysteryConnect/pages/PhotoSlideRPage/photo_slider_page.dart';
import 'package:MysteryConnect/pages/PlanPage/page_plan.dart';

import '../../network/entity/user.dart';
import '../../utilities/constants.dart';
import '../MessagePage/page_message.dart';
import '../PhotoPage/page_photo.dart';

class ProfilePageCustom extends StatelessWidget {
  final User user;

  const ProfilePageCustom({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    bool pre = true;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
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
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    const Spacer(),
                    Column(
                      children: [
                        Text(
                          "${user.userStats.messageCount}",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Messages",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    CircleAvatar(
                      radius: 70.0,
                      backgroundImage: NetworkImage(
                          "http://$baseIP/api/v1/photo/getPhotoById/${user.photoId}"),
                      backgroundColor: Colors.transparent,
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Text(
                          "${user.userStats.photoPoints}",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Photo Points",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Text(
                      "${user.fullName}, ${user.age}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_pin),
                        Text(
                          user.country,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                _profileBar(context),
                const SizedBox(
                  height: 20,
                ),
                CarouselSlider.builder(
                  options: CarouselOptions(height: 300.0),
                  itemCount: user.photoList.length,
                  itemBuilder: (context, index, realIndex) {
                    return user.photoList.isNotEmpty
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration:
                                BoxDecoration(color: Colors.transparent),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(30), // Image border
                              child: GestureDetector(
                                onTap: () {
                                  photoSliderPop(context, user);
                                },
                                child: Image.network(
                                  "http://$baseIP/api/v1/photo/getPhotoById/${user.photoList[index].id}",
                                  width: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Center(
                              child: Text(
                                "No Photos",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _navigationBottomBar(context),
    );
  }

  photoSliderPop(BuildContext context, User user) {
    return showDialog(
        context: context,
        builder: ((context) => PhotoSliderPage(
              user: user,
            )));
  }
}

Widget _navigationBottomBar(BuildContext context) {
  bool pre = false;
  return Container(
    padding: const EdgeInsets.only(bottom: 25),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFFFF9A00),
          Color(0xFFFF9A00),
          Color(0xFFFF5A00),
        ],
        stops: [0.1, 0.4, 0.7],
      ),
    ),
    child: BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.camera_alt,
            color: Colors.transparent,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: 'Send Photo',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.camera_alt,
            color: Colors.transparent,
          ),
          label: '',
        ),
      ],
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.white,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.transparent,
      onTap: (value) {
        if (!pre) {
          preControl(context);
        } else {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const PhotoPage()));
        }
      },
    ),
  );
}

Future<void> preControl(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: const Text('Sorry..'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              const Text('Do you want to buy Premium?'),
              SizedBox(
                height: 15,
              ),
              // const Divider(color: Colors.black),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: const Text('Buy',
                        style: TextStyle(color: Colors.blue, fontSize: 20)),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => MM()));
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

Widget _profileBar(BuildContext context) {
  bool pre = false;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      TextButton(
        style: ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: const BorderSide(width: 3, color: Colors.white),
            ))),
        onPressed: () {
          if (pre) {
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (context) => MessagePage()));
          } else {
            preControl(context);
          }
        },
        child: const Text(
          "MESSAGE",
          style: TextStyle(color: Colors.white),
        ),
      ),
    ],
  );
}
