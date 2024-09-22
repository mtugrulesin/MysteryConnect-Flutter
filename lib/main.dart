import 'package:MysteryConnect/services/firebase_remote_config_service.dart';
import 'package:MysteryConnect/utilities/constants.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:MysteryConnect/ws/wsHelper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'pages/LoginPage/page_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

List<CameraDescription> _cameras = [];
late wsHelper _qa;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);
  _cameras = await availableCameras();
  _qa = wsHelper();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static var cameras = _cameras;
  static var qa = _qa;
  Future<void> fbRemoteConf() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final fbRCS = FirebaseRemoteConfigService(
        firebaseRemoteConfig: FirebaseRemoteConfig.instance);
    await fbRCS.init();

    String ip = fbRCS.getServIp();

    baseIP = ip;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    fbRemoteConf();
    return MaterialApp(
      title: 'MysteryConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        fontFamily: 'Ubuntu',
      ),
      home: const LoginPage(),
    );
  }
}
