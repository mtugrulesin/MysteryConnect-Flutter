import 'package:flutter/material.dart';
import 'package:MysteryConnect/network/entity/db_message.dart';

import '../network/entity/message.dart';

final kHintTextStyle = TextStyle(
  color: Colors.white60,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xFFFF0000),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

// ignore: prefer_typing_uninitialized_variables
late var userTemp;

String baseIP = "";

List<DbMessage> messagesTemp = [];
