import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:gods_eye/Screens/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class verifyDeviceScreen extends StatefulWidget {
  const verifyDeviceScreen({super.key});

  @override
  State<verifyDeviceScreen> createState() => _verifyDeviceScreenState();
}

class _verifyDeviceScreenState extends State<verifyDeviceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF4C238),
      body: SingleChildScrollView(
        child: Container(
          height: 100.h,
          width: 100.w,
          child: Column(
            children: [
              Container(
                height: 13.h,
                width: 100.w,
                child: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.arrow_back_ios),
                          Text(
                            "Connection status",
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold, fontSize: 16.sp),
                          ),
                          Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xffF4C238),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 87.h,
                width: 100.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.sp),
                      topRight: Radius.circular(40.sp),
                    ),
                    color: Colors.white),
                child: Column(
                  children: [
                    SizedBox(
                      height: 5.h,
                    ),
                    Container(
                      width: 90.w,
                      decoration: BoxDecoration(
                          color: Color(0xffFFFAEC).withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20.sp)),
                      child: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Gods eye device",
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w700, fontSize: 16.sp),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              "Serial number",
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600, fontSize: 12.sp),
                            ),
                            Container(
                              height: 3.h,
                              child: TextField(
                                //  controller: usernameController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter your serial number here ",
                                  hintStyle: GoogleFonts.montserrat(
                                    color: Color.fromRGBO(179, 179, 179, 1),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10.sp,
                                    // letterSpacing: 1.sp
                                  ),
                                ),
                                style: GoogleFonts.montserrat(
                                  color: Color.fromRGBO(179, 179, 179, 1),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.sp,
                                  // letterSpacing: 1.sp
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        showSuccess();
                      },
                      child: Center(
                          child: Container(
                        width: 30.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.sp),
                          color: Color(0xffF4C238),
                        ),
                        child: Center(
                          child: Text(
                            "Verify",
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600, fontSize: 12.sp),
                          ),
                        ),
                      )),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
