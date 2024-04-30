import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gods_eye/Screens/acccidentLogsScreen.dart';
import 'package:gods_eye/Screens/emergencySituationScreen.dart';
import 'package:gods_eye/Screens/loginScreen.dart';
import 'package:gods_eye/Screens/verifyDevice.dart';
import 'package:gods_eye/Screens/yourInfoScreen.dart';
import 'package:google_fonts/google_fonts.dart';

GetStorage box = GetStorage();
var firstName = "".obs;

class dashboardScreen extends StatefulWidget {
  const dashboardScreen({super.key});

  @override
  State<dashboardScreen> createState() => _dashboardScreenState();
}

class _dashboardScreenState extends State<dashboardScreen> {
  @override
  void initState() {
    // TODO: implement initState
    listenForAccidents();
    getFirstNameFromDoc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset(
              "assets/dashboardBackground.png",
              width: 80.w,
              height: 50.h,
              fit: BoxFit.fill,
            ),
            Container(
              height: 100.h,
              width: 100.w,
              child: Column(
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    width: 100.h,
                    height: 10.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Spacer(),
                              Obx(() => Text(
                                    "Hello " + firstName.value,
                                    style: GoogleFonts.montserratAlternates(
                                        fontSize: 9.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  )),
                              SizedBox(height: 3.sp),
                              Text(
                                "Welcome Back!",
                                style: GoogleFonts.montserratAlternates(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11.sp),
                              ),
                              Spacer()
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            GetStorage box = GetStorage();
                            box.erase();
                            Get.to(loginScreen());
                          },
                          child: Padding(
                              padding: EdgeInsets.all(10.sp),
                              child: Icon(Icons.logout_rounded)
                              // ClipRRect(
                              //   borderRadius: BorderRadius.only(
                              //       topLeft: Radius.circular(8.sp),
                              //       bottomLeft: Radius.circular(8.sp),
                              //       bottomRight: Radius.circular(8.sp),
                              //       topRight: Radius.circular(8.sp)),
                              //   child: Image.network(
                              //     height: 5.h,
                              //     width: 5.h,
                              //     fit: BoxFit.cover,
                              //     "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1BwYl1Svb2h_YRhj9tcnZk0yAuIHh3oBM03dzDa8f&s",
                              //   ),
                              // ),
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    width: 90.w,
                    decoration: BoxDecoration(
                        color: Color(0xffFFFAEC).withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20.sp)),
                    child: Padding(
                      padding: EdgeInsets.all(7.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Car Status",
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w700, fontSize: 14.sp),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          Row(
                            children: [
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.all(1.w),
                                  child: Icon(Icons.arrow_circle_right_outlined,
                                      weight: 1.w),
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.sp),
                                    color: Color(0xfff5f5f5).withOpacity(0.4)),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Air bag sensor",
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.sp),
                                  ),
                                  Text(
                                    "Service status",
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff637587),
                                        fontSize: 11.sp),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Icon(
                                Icons.verified_user_rounded,
                                size: 7.w,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Row(
                            children: [
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.all(1.w),
                                  child: Icon(Icons.arrow_circle_right_outlined,
                                      weight: 1.w),
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.sp),
                                    color: Color(0xfff5f5f5).withOpacity(0.4)),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Shock sensor",
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.sp),
                                  ),
                                  Text(
                                    "Service status",
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff637587),
                                        fontSize: 11.sp),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Icon(
                                Icons.verified_user_rounded,
                                size: 7.w,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  GestureDetector(
                    onTap: () {
                      Get.to(accidentLogs());
                    },
                    child: Container(
                      width: 90.w,
                      decoration: BoxDecoration(
                          color: Color(0xffFFFAEC).withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20.sp)),
                      child: Padding(
                        padding: EdgeInsets.all(7.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Event Log",
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15.sp),
                                    ),
                                    SizedBox(
                                      height: 1.w,
                                    ),
                                    Text(
                                      "View list a of previous accidents",
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                          fontSize: 10.sp),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Icon(
                                  Icons.event_note,
                                  size: 7.w,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  GestureDetector(
                    onTap: () {
                      Get.to(yourInforScreen(
                          pageRef: "personalData", fromDashboard: true));
                    },
                    child: Container(
                      width: 90.w,
                      decoration: BoxDecoration(
                          color: Color(0xffFFFAEC).withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20.sp)),
                      child: Padding(
                        padding: EdgeInsets.all(7.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Your Information",
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15.sp),
                                    ),
                                    SizedBox(
                                      height: 1.w,
                                    ),
                                    Text(
                                      "View and edit your information",
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                          fontSize: 10.sp),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Icon(
                                  Icons.info_outline_rounded,
                                  size: 7.w,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  GestureDetector(
                    onTap: () {
                      Get.to(verifyDeviceScreen());
                      // Get.to(yourInforScreen(
                      //     pageRef: "emergencyContact", fromDashboard: true));
                    },
                    child: Container(
                      width: 90.w,
                      decoration: BoxDecoration(
                          color: Color(0xffFFFAEC).withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20.sp)),
                      child: Padding(
                        padding: EdgeInsets.all(7.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Verify device",
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15.sp),
                                    ),
                                    SizedBox(
                                      height: 1.w,
                                    ),
                                    Text(
                                      "Enter serial to verify IOT device",
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                          fontSize: 10.sp),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Icon(
                                  Icons.emergency_outlined,
                                  size: 7.w,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  GestureDetector(
                    onTap: () {
                      triggerAcccident();
                    },
                    child: Container(
                      width: 90.w,
                      decoration: BoxDecoration(
                          color: Color(0xffFFFAEC).withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20.sp)),
                      child: Padding(
                        padding: EdgeInsets.all(7.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Trigger test crash",
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15.sp),
                                    ),
                                    SizedBox(
                                      height: 1.w,
                                    ),
                                    Text(
                                      "Dymmy button to trigger test crash",
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                          fontSize: 10.sp),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Icon(
                                  Icons.warning_amber,
                                  size: 7.w,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void listenForAccidents() {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  GetStorage box = GetStorage();
  firestore.collection('users').doc(box.read("UID")).snapshots().listen(
      (documentSnapshot) {
    if (documentSnapshot.exists) {
      Map<String, dynamic> data = documentSnapshot.data()!;
      if (data["accidentStatus"]) {
        print("Accident Happend");
        Get.to(emergencySituationScreen());
      } else {
        Get.off(dashboardScreen());
      }
      //print(data); // Do something with the data
    } else {
      print("Document does not exist");
    }
  }, onError: (error) => print("Listen failed: $error"));
}

void triggerAcccident() async {
  GetStorage box = GetStorage();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final DocumentReference documentReference =
      firestore.collection('users').doc(box.read("UID"));

  try {
    // Update the accidentStats field to false
    await documentReference.update({
      'accidentStatus': true,
    });

    //  Get.back();
    print("accidentStats updated to false for document ID: " + box.read("UID"));
    //Get.off(dashboardScreen());
    // Get.off(dashboardScreen());
  } catch (e) {
    // Get.back();
    // Get.off(dashboardScreen());
    // If the document does not exist, the update operation will throw an error.
    // You might want to handle it here, for example, by creating the document.
    print("Error updating document: $e");
  }
}

getFirstNameFromDoc() async {
  print(box.read("UID"));
  DocumentReference docRef = FirebaseFirestore.instance
      .collection('users')
      .doc(box.read("UID"))
      .collection('personalData')
      .doc("data");

  DocumentSnapshot snapshot = await docRef.get();

  if (snapshot.exists) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    if (data != null && data.containsKey('firstName')) {
      firstName.value = data['firstName'];
    } else {
      print('The document does not contain a "first name" field.');
    }
  } else {
    print('Document does not exist.');
  }
}
