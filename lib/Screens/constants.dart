import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gods_eye/Screens/dashboardScreen.dart';
import 'package:gods_eye/Screens/yourInfoScreen.dart';
import 'package:google_fonts/google_fonts.dart';

void showLoader() {
  Get.dialog(
    Center(
      child: CircularProgressIndicator(
        color: Colors.yellow,
        strokeWidth: 1.sp,
      ),
    ),
    barrierDismissible:
        false, // Prevent dismissing the dialog by tapping outside
  );
}

void showSuccess() {
  Get.dialog(
      barrierDismissible: false,
      Dialog(
        backgroundColor: Colors.transparent,
        child: WillPopScope(
          onWillPop: () async => false,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.done_outlined,
                    color: Colors.green,
                    size: 15.w,
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Center(
                    child: Text("Update success",
                        style: GoogleFonts.montserrat(
                            fontSize: 12.sp, fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  // Image.asset(AppImage.internetConnection,height:30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Device Information Updated Successfully",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(),
                    ),
                  ),

                  SizedBox(
                    height: 3.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.off(dashboardScreen());
                    },
                    child: Center(
                      child: Container(
                        width: 30.w,
                        height: 4.h,
                        color: Colors.white,
                        child: Container(
                          width: 30.w,
                          decoration: BoxDecoration(
                              color: Color(0xffF4C238),
                              borderRadius: BorderRadius.circular(100.sp)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(),
                              Text(
                                "Okay",
                                style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
}

void showErrorDialog(String title, String content, String buttonText) {
  Get.dialog(
      barrierDismissible: false,
      Dialog(
        backgroundColor: Colors.transparent,
        child: WillPopScope(
          onWillPop: () async => false,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(title,
                        style: GoogleFonts.montserrat(
                            fontSize: 12.sp, fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  // Image.asset(AppImage.internetConnection,height:30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      content,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(),
                    ),
                  ),

                  SizedBox(
                    height: 3.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Center(
                      child: Container(
                        width: 30.w,
                        height: 4.h,
                        color: Colors.white,
                        child: Container(
                          width: 30.w,
                          decoration: BoxDecoration(
                              color: Color(0xffF4C238),
                              borderRadius: BorderRadius.circular(100.sp)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(),
                              Text(
                                buttonText,
                                style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
}

Future<void> checkBasicData() async {
  GetStorage box = GetStorage();
  // Ordered list of your collections
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late String missingCollection;
  // List of your collections under a specific user
  const List<String> collections = [
    'personalData',
    'emergencyContact',
    'vehicleInformation',
    'insuranceInformation',
    'medicalInformation',
  ];

  // Iterating over the collection names to check for their existence
  for (final String collectionName in collections) {
    // Constructing the path to each collection under the given userId
    final QuerySnapshot querySnapshot = await firestore
        .collection('users/' + box.read("UID") + '/$collectionName')
        .limit(1) // We only need to know if at least one document exists
        .get();
    if (querySnapshot.docs.isEmpty) {
      // If the collection is empty, assign its name to missingCollection and break the loop
      missingCollection = collectionName;
      break;
    } else {
      missingCollection = "";
    }
  }
  if (missingCollection != null) {
    // Switch case to navigate based on the missing collection
    switch (missingCollection) {
      case 'emergencyContact':
        print("Emergency Missing");
        Get.to(yourInforScreen(
          pageRef: "emergencyContact",
          fromDashboard: false,
        ));
        //Navigator.pushNamed(context, '/missingEmergencyContact');
        break;
      case 'insuranceInformation':
        Get.to(yourInforScreen(
          pageRef: "insuranceInformation",
          fromDashboard: false,
        ));
        print("Insuarance Missing");
        //Navigator.pushNamed(context, '/missingInsuranceInformation');
        break;
      case 'medicalInformation':
        Get.to(yourInforScreen(
          pageRef: "medicalInformation",
          fromDashboard: false,
        ));
        print("Medical Missing");
        // Navigator.pushNamed(context, '/missingMedicalInformation');
        break;
      case 'personalData':
        Get.to(yourInforScreen(
          pageRef: "personalData",
          fromDashboard: false,
        ));
        print("Personal Missing");
        // Navigator.pushNamed(context, '/missingPersonalData');
        break;
      case 'vehicleInformation':
        Get.to(yourInforScreen(
          pageRef: "vehicleInformation",
          fromDashboard: false,
        ));
        print("Vehical Missing");
        //  Navigator.pushNamed(context, '/missingVehicleInformation');
        break;
      default:
        Get.to(dashboardScreen());
        print("No missing collection, or collection name not recognized.");
    }
  } else {
    // Handle the case where all collections exist
    print("All collections exist. No navigation required.");
  }
}
