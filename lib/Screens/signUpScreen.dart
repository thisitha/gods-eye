import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gods_eye/Screens/constants.dart';
import 'package:gods_eye/Screens/loginScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class signUpScreen extends StatefulWidget {
  const signUpScreen({super.key});

  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();

class _signUpScreenState extends State<signUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xffF4C238),
          height: 100.h,
          width: 100.w,
          child: Column(
            children: [
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding: EdgeInsets.all(3.w),
                child: Image.asset(
                  "assets/logo.png",
                  height: 10.h,
                ),
              ),
              Spacer(),
              Container(
                height: 80.h,
                width: 100.w,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.sp),
                        topRight: Radius.circular(50.sp))),
                child: Column(
                  children: [
                    SizedBox(height: 3.h),
                    Text(
                      textAlign: TextAlign.center,
                      "Sign up",
                      style: GoogleFonts.montserrat(
                          fontSize: 25.sp, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20.sp)),
                      child: Container(
                        width: 90.w,
                        height: 11.h,
                        color: Color(0xfff5f5f5),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 1.h, left: 2.w),
                                child: Text(
                                  "Email",
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Container(
                                height: 30.sp,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 1.h, left: 2.w),
                                  child: TextField(
                                    controller: emailController,
                                    //controller: passWordController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "kavinda@gmaill.com",
                                      hintStyle: GoogleFonts.montserrat(
                                          color:
                                              Color.fromRGBO(179, 179, 179, 1),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    obscureText: false,
                                    obscuringCharacter: "*",
                                    style: GoogleFonts.montserrat(
                                        color: Color.fromRGBO(179, 179, 179, 1),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20.sp)),
                      child: Container(
                        width: 90.w,
                        height: 11.h,
                        color: Color(0xfff5f5f5),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 1.h, left: 2.w),
                                child: Text(
                                  "Password",
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Container(
                                height: 30.sp,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 1.h, left: 2.w),
                                  child: TextField(
                                    controller: passwordController,
                                    //controller: passWordController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "* * * * * * * * * * *",
                                      hintStyle: GoogleFonts.montserrat(
                                          color:
                                              Color.fromRGBO(179, 179, 179, 1),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    obscureText: true,
                                    obscuringCharacter: "*",
                                    style: GoogleFonts.montserrat(
                                        color: Color.fromRGBO(179, 179, 179, 1),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20.sp)),
                      child: Container(
                        width: 90.w,
                        height: 11.h,
                        color: Color(0xfff5f5f5),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 1.h, left: 2.w),
                                child: Text(
                                  "Confirm password",
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Container(
                                height: 30.sp,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 1.h, left: 2.w),
                                  child: TextField(
                                    controller: confirmPasswordController,
                                    //controller: passWordController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "* * * * * * * * * * *",
                                      hintStyle: GoogleFonts.montserrat(
                                          color:
                                              Color.fromRGBO(179, 179, 179, 1),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    obscureText: true,
                                    obscuringCharacter: "*",
                                    style: GoogleFonts.montserrat(
                                        color: Color.fromRGBO(179, 179, 179, 1),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        //  showErrorDialog();
                        if (passwordController.text ==
                            confirmPasswordController.text) {
                          createUser(
                              emailController.text, passwordController.text);
                        } else {
                          showErrorDialog(
                              "Password mismatch",
                              "Given passwords do not match each other",
                              "Try again");
                          passwordController.clear();
                          emailController.clear();
                          confirmPasswordController.clear();
                        }

                        //  Get.to(signUpScreen());
                      },
                      child: Container(
                        width: 90.w,
                        height: 7.h,
                        decoration: BoxDecoration(
                          color: Color(0xffF4C238),
                          borderRadius: BorderRadius.circular(30.sp),
                        ),
                        child: Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            "Sign Up",
                            style: GoogleFonts.montserrat(
                                fontSize: 15.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      "Or",
                      style: GoogleFonts.montserrat(
                          fontSize: 20.sp, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        signInWithGoogle();
                      },
                      child: Container(
                        width: 90.w,
                        height: 7.h,
                        decoration: BoxDecoration(
                          color: Color(0xffF4C238),
                          borderRadius: BorderRadius.circular(30.sp),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 4.h,
                              child: Image.asset("assets/google_logo.png"),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.sp),
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              "Sign up with Google",
                              style: GoogleFonts.montserrat(
                                  fontSize: 15.sp, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    GestureDetector(
                      onTap: () {
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
                    Spacer()
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

Future<User?> createUser(String email, String password) async {
  showLoader();
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // User registration successful
    // print(userCredential.user?.uid);
    Get.back();
    GetStorage box = GetStorage();
    box.write("UID", userCredential.user?.uid);
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // DocumentSnapshot personalDataSnapshot = await firestore
    //     .collection('users')
    //     .doc(box.read("UID"))
    //     .collection("personalData")
    //     .doc("data")
    //     .get();
    //
    // box.write(
    //     "userName",
    //     personalDataSnapshot["firstName"] +
    //         " " +
    //         personalDataSnapshot["lastName"]);
    createDocumentIfNotExist(box.read("UID"));
    checkBasicData();
    //Get.to(dashboardScreen());
    return userCredential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      Get.back();
      print('The password provided is too weak.');
      showErrorDialog(
          "Password too weak",
          "The password provided is too weak, provide a strong password",
          "Try again");
    } else if (e.code == 'email-already-in-use') {
      Get.back();
      showErrorDialog(
          "Account already exists",
          "An account already exists for that email, try logging in or use another email",
          "Try again");
      print('An account already exists for that email.');
    }
    //Get.back();
    return null;
  } catch (e) {
    print(e); // General error handling, for example, no internet connection.
    return null;
  }
}

Future<void> createDocumentIfNotExist(String userId) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final DocumentReference documentReference =
      firestore.collection('users').doc(userId);

  try {
    // Try to get the document
    final docSnapshot = await documentReference.get();

    if (!docSnapshot.exists) {
      // If the document does not exist, then create it
      await documentReference.set({
        'createdAt': FieldValue.serverTimestamp(),
        'basicData': false, // Example field
        'accidentStatus': false
      });
      print("Document created with ID: $userId");
    } else {
      // Document already exists
      print("Document already exists");
    }
  } catch (e) {
    print("Error accessing Firestore: $e");
  }
}
