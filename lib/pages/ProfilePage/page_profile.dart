import 'package:MysteryConnect/pages/PlanPage/mm.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:MysteryConnect/pages/EditProfilePage/edit_profile_page.dart';
import 'package:MysteryConnect/pages/LoginPage/page_login.dart';
import 'package:MysteryConnect/pages/PlanPage/page_plan.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../network/entity/user.dart';
import '../../network/services/UserService/user_api_service.dart';
import '../PhotoSlideRPage/photo_slider_page.dart';
import 'package:MysteryConnect/utilities/constants.dart';
import 'dart:io';

const String testDevice = 'YOUR_DEVICE_ID';
const int maxFailedLoadAttempts = 3;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  static User activeUser = userTemp;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<String> images = [];
  User activeUser = userTemp;

  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;

  @override
  void initState() {
    setState(() {
      ProfilePage.activeUser = userTemp;
    });
    _createRewardedAd();
    updateUser(activeUser.id);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _rewardedAd?.dispose();
  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-7589866814460653/5153478818'
            : 'ca-app-pub-7589866814460653/5153478818',
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      updateDia(activeUser.id, 170);
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
    _rewardedAd = null;
  }

  Future<void> updateDia(String userId, int count) async {
    Dio dio = Dio();
    UserApiService apiService =
        UserApiService(dio, baseUrl: "http://$baseIP/api/v1/");

    try {
      final res = await apiService.updateDiamondCount(
          userId, activeUser.diamondCount + 10);

      if (res.success) {
        setState(() {
          activeUser = res.user;
        });
      } else {
        debugPrint("User Create is not success : $res");
      }
    } catch (err) {
      debugPrint("Register Connection Error : $err");
    }
  }

  Future<void> updateUser(String userId) async {
    Dio dio = Dio();
    UserApiService apiService =
        UserApiService(dio, baseUrl: "http://$baseIP/api/v1/");
    print(userId);
    try {
      final res = await apiService.getUser(userId);
      print(res);

      setState(() {
        //userTemp = res;
        activeUser = res;
      });
    } catch (err) {
      debugPrint("Register Connection Error : $err");
    }
  }

  void logoutAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 30,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        color: Colors.amber,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/dia.png",
                            height: 100,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${activeUser.diamondCount}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _showRewardedAd();
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/watch.png",
                                  width: 60,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Spacer(),
                    Column(
                      children: [
                        Text(
                          "${activeUser.userStats.messageCount}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
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
                      backgroundImage: activeUser.photoId != ""
                          ? NetworkImage(
                              "http://$baseIP/api/v1/photo/getPhotoById/${activeUser.photoId}")
                          : const AssetImage("assets/person.png")
                              as ImageProvider,
                      backgroundColor: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: () {
                              //Navigator.of(context).push(MaterialPageRoute(
                              //    builder: (context) =>
                              //       EditProfilePage(user: activeUser)));
                              Navigator.of(context)
                                  .pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => EditProfilePage(
                                              user: activeUser)),
                                      ((route) => true))
                                  .then((_) => setState(() {
                                        activeUser = userTemp;
                                      }));
                            },
                            child: const Icon(
                              Icons.camera_alt,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Text(
                          "${activeUser.userStats.photoPoints}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
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
                      "${activeUser.fullName}, ${activeUser.age}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_pin),
                        Text(
                          activeUser.country,
                          style: const TextStyle(
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
                  height: 20,
                ),
                CarouselSlider.builder(
                  options: CarouselOptions(height: 300.0),
                  itemCount: activeUser.photoList.length,
                  itemBuilder: (context, index, realIndex) {
                    return activeUser.photoList.isNotEmpty
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration:
                                const BoxDecoration(color: Colors.transparent),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(30), // Image border
                              child: GestureDetector(
                                onTap: () {
                                  photoSliderPop(context, activeUser);
                                },
                                child: Image.network(
                                  "http://$baseIP/api/v1/photo/getPhotoById/${activeUser.photoList[index].id}",
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
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: const Center(
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
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side:
                                const BorderSide(width: 3, color: Colors.white),
                          ))),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => MM()));
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Buy SP+ Premium",
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
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 255, 0, 0)),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: const BorderSide(
                                width: 3,
                                color: Color.fromARGB(255, 255, 0, 0)),
                          ))),
                      onPressed: () {
                        logoutAccount();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "Log Out",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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
