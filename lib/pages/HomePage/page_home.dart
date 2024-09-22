import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:MysteryConnect/pages/ProfilePageCustom/page_profile_custom.dart';
import 'package:MysteryConnect/utilities/constants.dart';

import '../../network/entity/user.dart';
import '../../network/services/UserService/user_api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<User> users = [];
  User user = userTemp;
  Future<void> randomUsers(String userId) async {
    Dio dio = Dio();
    UserApiService apiService =
        UserApiService(dio, baseUrl: "http://$baseIP/api/v1/");
    try {
      final res = await apiService.getListOfRandomUsers(userId);

      if (res.success) {
        debugPrint("User Random is Success : ${res.message}");
        setState(() {
          for (user in res.users) {
            if (user.photoId != "") {
              users.add(user);
            }
          }
          //users = res.users;
        });
      } else {
        debugPrint("User Random is not success : ${res.message}");
      }
    } catch (err) {
      debugPrint("Connection Error : ${err.toString()}");
    }
  }

  @override
  void initState() {
    user = userTemp;
    randomUsers(user.id);
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            users.isNotEmpty
                ? CarouselSlider.builder(
                    options: CarouselOptions(
                      scrollDirection: Axis.vertical,
                      aspectRatio: 2.0,
                      height: MediaQuery.of(context).size.height,
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                    ),
                    itemCount: users.length,
                    itemBuilder: (context, index, realIndex) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: Colors.transparent),
                        child: _storyCard(user: users[index]),
                      );
                    },
                  )
                : Container(
                    child: Center(
                        child: Text(
                      "No Users Yet",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class _storyCard extends StatelessWidget {
  const _storyCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    print(user);
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.network(
            "http://$baseIP/api/v1/photo/getPhotoById/${user.photoId}",
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.amber,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: const [
                    Colors.amber,
                    Color(0xFFFF9A50),
                    Color(0xFFFF9F99),
                  ],
                  stops: const [0.1, 0.4, 0.9],
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Spacer(),
                      TextButton(
                        style: ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ))),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePageCustom(user: user)));
                        },
                        child: Column(
                          children: [
                            Text(
                              "${user.fullName}, ${user.age}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                              textAlign: TextAlign.left,
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
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
