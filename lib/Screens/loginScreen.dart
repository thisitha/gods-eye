import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gods_eye/Screens/constants.dart';
import 'package:gods_eye/Screens/signUpScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class _loginScreenState extends State<loginScreen> {
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
                      "Login",
                      style: GoogleFonts.montserrat(
                          fontSize: 25.sp, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 5.h,
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
                      height: 1.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (emailController.text.isNotEmpty) {
                          sendPasswordResetEmail();
                        } else {
                          showErrorDialog(
                              "Missing email",
                              "Enter the email which you want to rest the password",
                              "Okay");
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 5.w),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            textAlign: TextAlign.center,
                            "Forgot password? ",
                            style: GoogleFonts.montserrat(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        print("object");
                        loginUser(
                            emailController.text, passwordController.text);
                        emailController.clear();
                        passwordController.clear();
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
                            "Login",
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
                      height: 4.h,
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
                              "Sign in with Google",
                              style: GoogleFonts.montserrat(
                                  fontSize: 15.sp, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(signUpScreen());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            "Don't have an account ? ",
                            style: GoogleFonts.montserrat(
                                fontSize: 12.sp, fontWeight: FontWeight.normal),
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            "Sign up",
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<User?> loginUser(String email, String password) async {
  GetStorage box = GetStorage();
  showLoader();
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    box.write("UID", userCredential.user?.uid);
    Get.back();
    print(box.read("UID"));
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
    checkBasicData();
    //Get.to(dashboardScreen());
    // print(userCredential.user?.displayName);

    return userCredential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      Get.back();

      showErrorDialog(
          "No user found", "Please check the email and try again", "Try again");
      print('No user found for that email.');
    } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
      Get.back();
      print('The password provided is too weak.');
      showErrorDialog("Invalid Credentials",
          "Incorrect Credentials provides please try again", "Try again");
      print('Wrong password provided.');
    }
    return null;
  }
}

Future<void> sendPasswordResetEmail() async {
  try {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text);

    showErrorDialog(
        "Reset link sent",
        "If you have entered a valid username, a link has been sent to your email",
        "Okay");
  } on FirebaseAuthException catch (e) {
    print(e.code);
    if (e.code == 'user-not-found') {
      // If the user is not found, you can handle it accordingly
      print("No user found for that email.");
    } else {
      // Handle other errors
      print("Failed to send password reset email: ${e.message}");
    }
  } catch (e) {
    // Handle any other errors that might occur
    print("An error occurred while sending password reset email: $e");
  }
}

Future<User?> signInWithGoogle() async {
  showLoader();
  try {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Sign in to Firebase with the Google [UserCredential]
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
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
    // Get.to(dashboardScreen());
    // Return the User object
    return userCredential.user;
  } catch (e) {
    print(e.toString());
    return null;
  }
}
