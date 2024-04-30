import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/route_manager.dart';
import 'package:gods_eye/Screens/loginScreen.dart';
import 'package:gods_eye/Screens/signUpScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                "Stay safe \n Let us respond",
                style: GoogleFonts.montserrat(
                    fontSize: 24.sp, fontWeight: FontWeight.w900),
              ),
              Spacer(),
              Image.asset("assets/splashScreenImage.png"),
              SizedBox(
                height: 10.h,
              ),
              Text(
                textAlign: TextAlign.center,
                "  Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur",
                style: GoogleFonts.montserrat(
                    fontSize: 15.sp, fontWeight: FontWeight.normal),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Get.to(signUpScreen());
                },
                child: Container(
                  width: 90.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: Color(0xffF4C238),
                    borderRadius: BorderRadius.circular(30.sp),
                  ),
                  child: Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      "Sign Up",
                      style: GoogleFonts.montserrat(
                          fontSize: 20.sp, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              GestureDetector(
                onTap: (){
                  Get.to(loginScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      "Already have an account ? ",
                      style: GoogleFonts.montserrat(
                          fontSize: 12.sp, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      "Log in",
                      style: GoogleFonts.montserrat(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.normal,
                          color: Color(0xffF4C238)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
