import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gods_eye/Screens/emergencySituationScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import 'constants.dart';

var firstName = "".obs;
var lastName = "".obs;
var mobileNumber = "".obs;
var relationSihip = "".obs;

class servicesAlertedScreen extends StatefulWidget {
  const servicesAlertedScreen({super.key});

  @override
  State<servicesAlertedScreen> createState() => _servicesAlertedScreenState();
}

class _servicesAlertedScreenState extends State<servicesAlertedScreen> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchEmergencyContactAndFillEmergencyContacts();
    });
    saveAccidentLogWithLocation();

    // setState(() {});

    super.initState();
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
                "Emergency services has been notified",
                style: GoogleFonts.montserrat(
                    color: Color(0xfff5f5f5),
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: 10.h,
              ),
              Obx(
                () => Text(
                  textAlign: TextAlign.center,
                  "The nearest medical institution (institution name) and the emergency contact " +
                      firstName.value +
                      " " +
                      lastName.value +
                      " has been informed about the accident and an help is on the way",
                  style: GoogleFonts.montserrat(
                      color: Color(0xfff5f5f5),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w900),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  stopAccident();
                  //Get.off(dashboardScreen());
                },
                child: Container(
                  height: 50.w,
                  width: 50.w,
                  child: Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      "Return",
                      style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
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

Future<void> fetchEmergencyContactAndFillEmergencyContacts() async {
  showLoader();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  GetStorage box = GetStorage();
  // Assuming the emergency contact data is stored under the same document
  DocumentReference docRef = firestore
      .collection('users')
      .doc(box.read("UID"))
      .collection('emergencyContact')
      .doc('data');

  try {
    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      Map<String, dynamic> userData =
          docSnapshot.data() as Map<String, dynamic>;

      // Assign the fetched values to the controllers for emergency contact
      firstName.value = userData['firstName'] ?? '';
      lastName.value = userData['lastName'] ?? '';
      mobileNumber.value = userData['mobileNumber'] ?? '';
      relationSihip.value = userData['relationship'] ?? '';
      Get.back();
    } else {
      Get.back();
      print("Document does not exist.");
    }
  } catch (e) {
    Get.back();
    print("Error fetching emergency contact data: $e");
  }
}

Future<void> saveAccidentLogWithLocation() async {
  Location location = new Location();
  GetStorage box = GetStorage();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  // Check if location service is enabled
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  // Check for location permissions
  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  // Get current location
  _locationData = await location.getLocation();
  print(_locationData.latitude.toString() + "esdtyrfg");
  // Generate a random 7-character string starting with '#'
  const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final String accidentId = '#' +
      List.generate(7, (index) => chars[Random().nextInt(chars.length)])
          .join('');

  // Get the current time and format it
  final DateTime now = DateTime.now();
  final String formattedTime = "${now.hour}:${now.minute}:${now.second}";
  final String formattedDate = "${now.year}-${now.month}-${now.day}";

  final String locationName =
      "Lat: ${_locationData.latitude}, Long: ${_locationData.longitude}";

  await FirebaseFirestore.instance
      .collection('users')
      .doc(box.read("UID"))
      .collection("accidentInfo")
      .add({
        'accidentId': accidentId,
        'time': formattedTime,
        'date': formattedDate,
        'latitude': _locationData.latitude,
        'longitude': _locationData.longitude,
        'locationName': locationName,
        'accidentStatus': "Ongoing"
      })
      .then((value) => print("Accident Log Added"))
      .catchError((error) => print("Failed to add accident log: $error"));
  makeTwilioCall();
  sendTwilioMessage(); ////enable before presentations
  getUserData();
}

Future<Map<String, dynamic>> getUserData() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  GetStorage box = GetStorage();

  // Defining a map to hold all user data
  Map<String, dynamic> consolidatedUserData = {};

  // Fetch personal data
  DocumentSnapshot personalDataSnapshot = await firestore
      .collection('users')
      .doc(box.read("UID"))
      .collection("personalData")
      .doc("data")
      .get();
  if (personalDataSnapshot.exists) {
    consolidatedUserData
        .addAll(personalDataSnapshot.data() as Map<String, dynamic>);
  }

  // Fetch emergency data
  DocumentSnapshot emergencyDataSnapshot = await firestore
      .collection('users')
      .doc(box.read("UID"))
      .collection("emergencyContact")
      .doc("data")
      .get();
  if (emergencyDataSnapshot.exists) {
    consolidatedUserData
        .addAll(emergencyDataSnapshot.data() as Map<String, dynamic>);
  }

  // Fetch medical data
  DocumentSnapshot medicalDataSnapshot = await firestore
      .collection('users')
      .doc(box.read("UID"))
      .collection("medicalInformation")
      .doc("data")
      .get();
  if (medicalDataSnapshot.exists) {
    consolidatedUserData
        .addAll(medicalDataSnapshot.data() as Map<String, dynamic>);
  }

  // Fetch vehicle data
  DocumentSnapshot vehicleDataSnapshot = await firestore
      .collection('users')
      .doc(box.read("UID"))
      .collection("vehicleInformation")
      .doc("data")
      .get();
  if (vehicleDataSnapshot.exists) {
    consolidatedUserData
        .addAll(vehicleDataSnapshot.data() as Map<String, dynamic>);
  }

  // Fetch insurance data
  DocumentSnapshot insuranceDataSnapshot = await firestore
      .collection('users')
      .doc(box.read("UID"))
      .collection("insuranceInformation")
      .doc("data")
      .get();
  if (insuranceDataSnapshot.exists) {
    consolidatedUserData
        .addAll(insuranceDataSnapshot.data() as Map<String, dynamic>);
  }
  print(consolidatedUserData);

  return consolidatedUserData;
}

Future<void> makeTwilioCall() async {
  final url = Uri.parse(
      'https://api.twilio.com/2010-04-01/Accounts/ACddce06da1847f6cb235cbac75ebe9ba3/Calls.json');

  final headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Authorization':
        'Basic QUNkZGNlMDZkYTE4NDdmNmNiMjM1Y2JhYzc1ZWJlOWJhMzo0NDk3NjViMzhmZDNjZTE3MzEwODc3NjZiYjBlYzg2ZQ==',
  };

  final data = {
    'Twiml': '<Response><Say>Ahoy there!</Say></Response>',
    'To': '94713358701',
    'From': '14423334961',
  };

  final response = await http.post(url, headers: headers, body: data);

  if (response.statusCode == 200) {
    print('API call successful');
  } else {
    print('API call failed with status code: ${response.statusCode}');
  }
}

Future<void> sendTwilioMessage() async {
  final url = Uri.parse(
      'https://api.twilio.com/2010-04-01/Accounts/ACddce06da1847f6cb235cbac75ebe9ba3/Messages.json');

  final headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Authorization':
        'Basic QUNkZGNlMDZkYTE4NDdmNmNiMjM1Y2JhYzc1ZWJlOWJhMzo0NDk3NjViMzhmZDNjZTE3MzEwODc3NjZiYjBlYzg2ZQ==',
  };

  final data = {
    'To': 'whatsapp:+94713358701',
    'From': 'whatsapp:+14155238886',
    'Body': 'Emergency situation is declared for kavinda at marine drive',
  };

  final response = await http.post(url, headers: headers, body: data);

  if (response.statusCode == 200) {
    print('API call successful');
  } else {
    print('API call failed with status code: ${response.statusCode}');
  }
}
