import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gods_eye/Screens/constants.dart';
import 'package:gods_eye/Screens/servicesAlertedScreen.dart';
import 'package:google_fonts/google_fonts.dart';

late int count;
Timer? _timer;

class emergencySituationScreen extends StatefulWidget {
  const emergencySituationScreen({super.key});

  @override
  State<emergencySituationScreen> createState() =>
      _emergencySituationScreenState();
}

class _emergencySituationScreenState extends State<emergencySituationScreen> {
  @override
  void initState() {
    count = 10;
    // TODO: implement initState
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (count > 0) {
        setState(() {
          count--;
        });
      } else {
        Get.to(servicesAlertedScreen());
        t.cancel(); // Stop the timer when the count reaches 0
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffD14141),
      body: Container(
        height: 100.h,
        width: 100.w,
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Column(
            children: [
              SizedBox(
                height: 5.h,
              ),
              Text(
                textAlign: TextAlign.center,
                "Emergency situation is detected",
                style: GoogleFonts.montserrat(
                    color: Color(0xfff5f5f5),
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                textAlign: TextAlign.center,
                "We have detected an accident. If it is a false alarm or a you do not need any immediate medical assistance please press the cancellation button with in 1 minute. If not the the system will alert nearby medical institution ",
                style: GoogleFonts.montserrat(
                    color: Color(0xfff5f5f5),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: 0.h,
              ),
              Spacer(),
              Text(
                textAlign: TextAlign.center,
                count.toString(),
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 40.sp,
                    fontWeight: FontWeight.w900),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  stopAccident();
                },
                child: Container(
                  height: 50.w,
                  width: 50.w,
                  child: Center(
                      child: Text(
                    textAlign: TextAlign.center,
                    "Stop",
                    style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w900),
                  )),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100.sp)),
                ),
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}

void stopAccident() async {
  showLoader();
  GetStorage box = GetStorage();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final DocumentReference documentReference =
      firestore.collection('users').doc(box.read("UID"));

  try {
    // Update the accidentStats field to false
    await documentReference.update({
      'accidentStatus': false,
    });
    _timer?.cancel();
    //Get.back();
    print("accidentStats updated to false for document ID: " + box.read("UID"));
    //Get.off(dashboardScreen());
    // Get.off(dashboardScreen());
  } catch (e) {
    //Get.back();
    // Get.off(dashboardScreen());
    // If the document does not exist, the update operation will throw an error.
    // You might want to handle it here, for example, by creating the document.
    print("Error updating document: $e");
  }
}
