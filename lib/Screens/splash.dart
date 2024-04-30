import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gods_eye/Screens/constants.dart';
import 'package:gods_eye/Screens/splashScreen.dart';

class splashLoader extends StatefulWidget {
  const splashLoader({super.key});

  @override
  State<splashLoader> createState() => _splashLoaderState();
}

class _splashLoaderState extends State<splashLoader> {
  @override
  void initState() {
    // TODO: implement initState
    // loginCheck();
    loginCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // else {
    //   Timer(Duration(seconds: 5), () => Get.to(loginScreen()));
    // }loginCheck()

    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: 100.h,
              width: 100.w,
              child: Center(
                  child: Image.asset(
                "assets/logo.png",
                width: 50.w,
              ))),
        ],
      ),
    );
  }
}

void loginCheck() async {
  GetStorage box = GetStorage();
  print(box.read("UID"));
  if (box.hasData("UID")) {
    print("has");

    await Future.delayed(Duration(seconds: 3));
    checkBasicData();
    // Timer(Duration(seconds: 5), () => checkBasicData());
  } else {
    print("empty");
    await Future.delayed(Duration(seconds: 3));
    Get.to(splashScreen());
  }
}
