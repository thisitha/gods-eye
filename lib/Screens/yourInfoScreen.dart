import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gods_eye/Screens/constants.dart';
import 'package:gods_eye/Screens/dashboardScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

//
// String? selectedBloodType;
// List<String> bloodTypes = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];

var pageID = "".obs;
var DOB = "".obs;
TextEditingController firstNameController = TextEditingController();
TextEditingController lastNameController = TextEditingController();
TextEditingController addressController = TextEditingController();
TextEditingController cityController = TextEditingController();
TextEditingController DOBController = TextEditingController();
TextEditingController mobileNumberController = TextEditingController();
TextEditingController genderController = TextEditingController();

//Emergency Contact
TextEditingController emergencyFirstnameController = TextEditingController();
TextEditingController emergencyLastanameController = TextEditingController();
TextEditingController emergencymobileController = TextEditingController();
TextEditingController emergencyRelationshipController = TextEditingController();

//vehical Info
TextEditingController vehicalBrandController = TextEditingController();
TextEditingController vehicalTypeController = TextEditingController();
TextEditingController vehicalModelController = TextEditingController();
TextEditingController vehicalPlateController = TextEditingController();
TextEditingController vehicalColorController = TextEditingController();

//insurance info
TextEditingController insuaranceAgencyController = TextEditingController();
TextEditingController insuarancePolicyController = TextEditingController();
TextEditingController insuaranceAgentContactController =
    TextEditingController();

//Medical Info
TextEditingController medicalConditionsController = TextEditingController();
TextEditingController medicalAllergiesController = TextEditingController();
TextEditingController medicalBloodTypeController = TextEditingController();
TextEditingController medicalMedicationController = TextEditingController();

class yourInforScreen extends StatefulWidget {
  final String pageRef;
  final bool fromDashboard;
  const yourInforScreen(
      {super.key, required this.pageRef, required this.fromDashboard});

  @override
  State<yourInforScreen> createState() => _yourInforScreenState();
}

class _yourInforScreenState extends State<yourInforScreen> {
  @override
  void initState() {
    pageID.value = widget.pageRef;

    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.fromDashboard) {
        fetchEmergencyContactAndFillEmergencyContacts();
        // setState(() {});

        fetchUserDataAndFillPersonalInfo();
        fetchVehicleDataAndFillVehicalData();
        fetchMedicalDataAndFillMedicalData();
        fetchInsuranceDataAndFillInsuaranceData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          switch (pageID.value) {
            case 'emergencyContact':
              if (emergencyFirstnameController.text.isNotEmpty &&
                  emergencyLastanameController.text.isNotEmpty &&
                  emergencymobileController.text.isNotEmpty &&
                  emergencyRelationshipController.text.isNotEmpty) {
                // All emergency contact fields are filled
                Map<String, dynamic> userData = {
                  'firstName': emergencyFirstnameController.text,
                  'lastName': emergencyLastanameController.text,
                  'mobileNumber': emergencymobileController.text,
                  'relationship': emergencyRelationshipController.text,
                };

                storeUserData("emergencyContact", userData);

                if (widget.fromDashboard) {
                  //Get.back();
                  pageID.value = "vehicleInformation";
                } else {
                  pageID.value = "vehicleInformation";
                }
              } else {
                // At least one emergency contact field is empty
                print("Please fill in all emergency contact fields.");
              }

              //Navigator.pushNamed(context, '/missingEmergencyContact');
              break;
            case 'insuranceInformation':
              if (insuaranceAgencyController.text.isNotEmpty &&
                  insuarancePolicyController.text.isNotEmpty &&
                  insuaranceAgentContactController.text.isNotEmpty) {
                // All insurance fields are filled
                print("All insurance fields are filled.");
                Map<String, dynamic> userData = {
                  'agency': insuaranceAgencyController.text,
                  'policyNumber': insuarancePolicyController.text,
                  'agentContact': insuaranceAgentContactController.text,
                };

                storeUserData("insuranceInformation", userData);
                pageID.value = "medicalInformation";
              } else {
                showErrorDialog("Missing data",
                    "Please fill all data before proceeding", "Try again");
                // At least one insurance field is empty
                print("Please fill in all insurance fields.");
              }

              //Navigator.pushNamed(context, '/missingInsuranceInformation');
              break;
            case 'medicalInformation':
              // Get.to(yourInforScreen(pageRef: "medicalInformation"));
              if (medicalConditionsController.text.isNotEmpty &&
                  medicalAllergiesController.text.isNotEmpty &&
                  medicalBloodTypeController.text.isNotEmpty &&
                  medicalMedicationController.text.isNotEmpty) {
                // All medical fields are filled
                Map<String, dynamic> userData = {
                  'medicalConditions': medicalConditionsController.text,
                  'medicalAllergies': medicalAllergiesController.text,
                  'medicalBloodType': medicalBloodTypeController.text,
                  'medicalMedication': medicalMedicationController.text,
                };
                storeUserData("medicalInformation", userData);
                print("All medical fields are filled.");
              } else {
                showErrorDialog("Missing data",
                    "Please fill all data before proceeding", "Try again");
                // At least one medical field is empty
                print("Please fill in all medical fields.");
              }
              updateUserStatus();
              print("All Done");
              // Navigator.pushNamed(context, '/missingMedicalInformation');
              break;
            case 'personalData':
              if (firstNameController.text.isNotEmpty &&
                  lastNameController.text.isNotEmpty &&
                  addressController.text.isNotEmpty &&
                  cityController.text.isNotEmpty &&
                  DOBController.text.isNotEmpty &&
                  mobileNumberController.text.isNotEmpty &&
                  genderController.text.isNotEmpty) {
                print("All fields are filled.");
                Map<String, dynamic> userData = {
                  'firstName': firstNameController.text,
                  'lastName': lastNameController.text,
                  'address': addressController.text,
                  'city': cityController.text,
                  'DOB': DOBController.text,
                  'mobileNumber': mobileNumberController.text,
                  'gender': genderController.text,
                };
                box.write("userName",
                    firstNameController.text + " " + lastNameController.text);
                storeUserData("personalData", userData);
                if (widget.fromDashboard) {
                  // Get.back();
                  pageID.value = "emergencyContact";
                } else {
                  pageID.value = "emergencyContact";
                }
              } else {
                showErrorDialog("Missing data",
                    "Please fill all data before proceeding", "Try again");
              }

              break;
            case 'vehicleInformation':
              if (vehicalBrandController.text.isNotEmpty &&
                  vehicalTypeController.text.isNotEmpty &&
                  vehicalModelController.text.isNotEmpty &&
                  vehicalPlateController.text.isNotEmpty &&
                  vehicalColorController.text.isNotEmpty) {
                // All vehicle fields are filled
                print("All vehicle fields are filled.");
                Map<String, dynamic> userData = {
                  'Brand': vehicalBrandController.text,
                  'Type': vehicalTypeController.text,
                  'Model': vehicalModelController.text,
                  'Plate': vehicalPlateController.text,
                  'Color': vehicalColorController.text,
                };

                storeUserData("vehicleInformation", userData);
                pageID.value = "insuranceInformation";
              } else {
                showErrorDialog("Missing data",
                    "Please fill all data before proceeding", "Try again");
                // At least one vehicle field is empty
                print("Please fill in all vehicle fields.");
              }

              //  Navigator.pushNamed(context, '/missingVehicleInformation');
              break;
            default:
              print(
                  "No missing collection, or collection name not recognized.");
          }
        },
        child: Container(
          width: 90.w,
          height: 5.h,
          decoration: BoxDecoration(
            color: Color(0xffF4C238),
            borderRadius: BorderRadius.circular(30.sp),
          ),
          child: Center(
            child: Text(
              textAlign: TextAlign.center,
              "Next",
              style: GoogleFonts.montserrat(
                  fontSize: 15.sp, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xffF4C238),
      body: SingleChildScrollView(
        child: Container(
          height: 100.h,
          width: 100.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
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
                          GestureDetector(
                              onTap: () {
                                if (widget.fromDashboard) {
                                  Get.back();
                                }
                                switch (pageID.value) {
                                  case 'emergencyContact':
                                    fetchUserDataAndFillPersonalInfo();

                                    pageID.value = "personalData";
                                    //Navigator.pushNamed(context, '/missingEmergencyContact');
                                    break;
                                  case 'insuranceInformation':
                                    fetchVehicleDataAndFillVehicalData();
                                    pageID.value = "vehicleInformation";
                                    //Navigator.pushNamed(context, '/missingInsuranceInformation');
                                    break;
                                  case 'medicalInformation':
                                    fetchInsuranceDataAndFillInsuaranceData();
                                    pageID.value = "insuranceInformation";
                                    // Get.to(yourInforScreen(pageRef: "medicalInformation"));
                                    print("All Done");
                                    // Navigator.pushNamed(context, '/missingMedicalInformation');
                                    break;
                                  case 'personalData':
                                    // pageID.value = "emergencyContact";
                                    // Navigator.pushNamed(context, '/missingPersonalData');
                                    break;
                                  case 'vehicleInformation':
                                    fetchEmergencyContactAndFillEmergencyContacts();
                                    pageID.value = "emergencyContact";
                                    //  Navigator.pushNamed(context, '/missingVehicleInformation');
                                    break;
                                  default:
                                    print(
                                        "No missing collection, or collection name not recognized.");
                                }
                              },
                              child: Icon(Icons.arrow_back_ios)),
                          Text(
                            "Your information",
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
                  child: Obx(
                    () => pageID.value == 'emergencyContact'
                        ? emergencyContact()
                        : pageID.value == 'insuranceInformation'
                            ? insuranceInformation()
                            : pageID.value == 'medicalInformation'
                                ? medicalInformation()
                                : pageID.value == 'personalData'
                                    ? personalInformation()
                                    : pageID.value == 'vehicleInformation'
                                        ? vehicleInformation()
                                        : Container(),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class personalInformation extends StatefulWidget {
  const personalInformation({super.key});

  @override
  State<personalInformation> createState() => _personalInformationState();
}

class genderControllerGet extends GetxController {
  Rx<String?> selectedGender = Rx<String?>(null);
  List<String> genders = ["Male", "Female"];
}

class _personalInformationState extends State<personalInformation> {
  @override
  Widget build(BuildContext context) {
    final genderControllerGet genderTypeController =
        Get.put(genderControllerGet());
    return Container(
      height: 85.h,
      width: 100.w,
      child: Column(
        children: [
          SizedBox(
            height: 3.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    "Personal Information",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700, fontSize: 14.sp),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        prefilPersonalData();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.red.withOpacity(0.2)),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 3.w, right: 3.w, top: 1.w, bottom: 1.w),
                        child: Text(
                          "Fill data",
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w700, fontSize: 10.sp),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 2.w,
          ),
          Padding(
            padding: EdgeInsets.all(5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 43.w,
                  decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20.sp)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 3.w, left: 3.w),
                        child: Text(
                          "First name",
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w700, fontSize: 12.sp),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 3.w,
                        ),
                        child: TextField(
                          controller: firstNameController,
                          //  controller: usernameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Thisitha ",
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
                Container(
                  width: 43.w,
                  decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20.sp)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 3.w, left: 3.w),
                        child: Text(
                          "Last name",
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w700, fontSize: 12.sp),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 3.w,
                        ),
                        child: TextField(
                          controller: lastNameController,
                          //  controller: usernameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Kavinda",
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
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20.sp)),
            width: 90.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 3.w, left: 3.w),
                  child: Text(
                    "Address",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700, fontSize: 12.sp),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 3.w,
                  ),
                  child: TextField(
                    controller: addressController,
                    //  controller: usernameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "73/l, Church road, Maharagama",
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
          SizedBox(
            height: 5.w,
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20.sp)),
            width: 90.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 3.w, left: 3.w),
                  child: Text(
                    "City",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700, fontSize: 12.sp),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 3.w,
                  ),
                  child: TextField(
                    controller: cityController,
                    //  controller: usernameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Maharagama",
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
          SizedBox(
            height: 5.w,
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20.sp)),
            width: 90.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 3.w, left: 3.w),
                  child: Text(
                    "Date of Birth",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700, fontSize: 12.sp),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                      left: 3.w,
                    ),
                    child: GestureDetector(
                        onTap: () async {
                          DateTime? newDateTime = await showRoundedDatePicker(
                            context: context,
                            theme: ThemeData.dark(),
                          );
                          DOBController.text =
                              DateFormat.yMMMEd().format(newDateTime!);

                          DOB.value = DOBController.text;
                        },
                        child: Container(
                            height: 5.h,
                            width: 90.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Spacer(),
                                Obx(() => Text(
                                      DOB.value,
                                      style: GoogleFonts.montserrat(
                                        color: Color.fromRGBO(179, 179, 179, 1),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10.sp,
                                        // letterSpacing: 1.sp
                                      ),
                                    )),
                                Spacer(),
                              ],
                            )))

                    // TextField(
                    //   controller: DOBController,
                    //   //  controller: usernameController,
                    //   decoration: InputDecoration(
                    //     border: InputBorder.none,
                    //     hintText: "DD/MM/YYYY",
                    //     hintStyle: GoogleFonts.montserrat(
                    //       color: Color.fromRGBO(179, 179, 179, 1),
                    //       fontWeight: FontWeight.w600,
                    //       fontSize: 10.sp,
                    //       // letterSpacing: 1.sp
                    //     ),
                    //   ),
                    //   style: GoogleFonts.montserrat(
                    //     color: Color.fromRGBO(179, 179, 179, 1),
                    //     fontWeight: FontWeight.w600,
                    //     fontSize: 10.sp,
                    //     // letterSpacing: 1.sp
                    //   ),
                    // ),
                    ),
              ],
            ),
          ),
          SizedBox(
            height: 5.w,
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20.sp)),
            width: 90.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 3.w, left: 3.w),
                  child: Text(
                    "Mobile number",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700, fontSize: 12.sp),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 3.w,
                  ),
                  child: TextField(
                    controller: mobileNumberController,
                    //  controller: usernameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "071234567",
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
          SizedBox(
            height: 5.w,
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20.sp)),
            width: 90.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 3.w, left: 3.w),
                  child: Text(
                    "Gender",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700, fontSize: 12.sp),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                      left: 3.w,
                    ),
                    child: Container(
                        width: 90.w,
                        child: Obx(
                          () => DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: genderTypeController.selectedGender.value,
                              onChanged: (newValue) {
                                genderTypeController.selectedGender.value =
                                    newValue!;
                                genderController.text = newValue;
                              },

                              items: genderTypeController.genders
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              style: GoogleFonts.montserrat(
                                color: Color.fromRGBO(179, 179, 179, 1),
                                fontWeight: FontWeight.w600,
                                fontSize: 10.sp,
                                // letterSpacing: 1.sp
                              ),
                              // decoration: InputDecoration(
                              //   contentPadding: EdgeInsets.symmetric(
                              //       horizontal: 12.0, vertical: 8.0),
                              //   isDense: true,
                              //   // border: OutlineInputBorder(
                              //   //   borderRadius: BorderRadius.circular(8.0),
                              //   //   borderSide: BorderSide(),
                              //   // ),
                              // ),
                            ),
                          ),
                        ))
                    // TextField(
                    //   controller: genderController,
                    //   //  controller: usernameController,
                    //   decoration: InputDecoration(
                    //     border: InputBorder.none,
                    //     hintText: "Male",
                    //     hintStyle: GoogleFonts.montserrat(
                    //       color: Color.fromRGBO(179, 179, 179, 1),
                    //       fontWeight: FontWeight.w600,
                    //       fontSize: 10.sp,
                    //       // letterSpacing: 1.sp
                    //     ),
                    //   ),
                    //   style: GoogleFonts.montserrat(
                    //     color: Color.fromRGBO(179, 179, 179, 1),
                    //     fontWeight: FontWeight.w600,
                    //     fontSize: 10.sp,
                    //     // letterSpacing: 1.sp
                    //   ),
                    // ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class emergencyContact extends StatefulWidget {
  const emergencyContact({super.key});

  @override
  State<emergencyContact> createState() => _emergencyContactState();
}

class _emergencyContactState extends State<emergencyContact> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      width: 100.w,
      child: Column(
        children: [
          SizedBox(
            height: 3.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    "Emergency Contact",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700, fontSize: 14.sp),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        prefillEmergencyData();
                        //prefilPersonalData();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.red.withOpacity(0.2)),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 3.w, right: 3.w, top: 1.w, bottom: 1.w),
                        child: Text(
                          "Fill data",
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w700, fontSize: 10.sp),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 2.w,
          ),
          Padding(
            padding: EdgeInsets.all(5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 43.w,
                  decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20.sp)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 3.w, left: 3.w),
                        child: Text(
                          "First name",
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w700, fontSize: 12.sp),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 3.w,
                        ),
                        child: TextField(
                          controller: emergencyFirstnameController,
                          //  controller: usernameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Thisitha ",
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
                Container(
                  width: 43.w,
                  decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20.sp)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 3.w, left: 3.w),
                        child: Text(
                          "Last name",
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w700, fontSize: 12.sp),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 3.w,
                        ),
                        child: TextField(
                          controller: emergencyLastanameController,
                          //  controller: usernameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Kavinda",
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
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20.sp)),
            width: 90.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 3.w, left: 3.w),
                  child: Text(
                    "Mobile number",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700, fontSize: 12.sp),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 3.w,
                  ),
                  child: TextField(
                    controller: emergencymobileController,
                    //  controller: usernameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "0725526252",
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
          SizedBox(
            height: 5.w,
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20.sp)),
            width: 90.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 3.w, left: 3.w),
                  child: Text(
                    "Relationship",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700, fontSize: 12.sp),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 3.w,
                  ),
                  child: TextField(
                    controller: emergencyRelationshipController,
                    //  controller: usernameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Mother",
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
          SizedBox(
            height: 5.w,
          ),
        ],
      ),
    );
  }
}

class vehicleInformation extends StatefulWidget {
  const vehicleInformation({super.key});

  @override
  State<vehicleInformation> createState() => _vehicleInformationState();
}

class vehicalTypeControllerGet extends GetxController {
  Rx<String?> selectedBrand = Rx<String?>(null);
  List<String> vehicalBrands = [
    "Honda",
    "Suzuki",
    "Hyundai",
    "Toyota",
    "Nissan"
  ];

  Rx<String?> selectedType = Rx<String?>(null);
  List<String> vehicalTypes = ["SUV", "Sedan", "Hatchback", "Mini", "Cab"];
}

class _vehicleInformationState extends State<vehicleInformation> {
  @override
  Widget build(BuildContext context) {
    final vehicalTypeControllerGet vehicalController =
        Get.put(vehicalTypeControllerGet());
    return Container(
      height: 85.h,
      width: 100.w,
      child: Column(
        children: [
          SizedBox(
            height: 3.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    "Vehicle Information",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700, fontSize: 14.sp),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        prefillVehicalData();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.red.withOpacity(0.2)),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 3.w, right: 3.w, top: 1.w, bottom: 1.w),
                        child: Text(
                          "Fill data",
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w700, fontSize: 10.sp),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 7.w,
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20.sp)),
            width: 90.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 3.w, left: 3.w),
                  child: Text(
                    "Brand",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700, fontSize: 12.sp),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                      left: 3.w,
                    ),
                    child: Container(
                        width: 90.w,
                        child: Obx(
                          () => DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: vehicalController.selectedBrand.value,
                              onChanged: (newValue) {
                                vehicalController.selectedBrand.value =
                                    newValue!;
                                vehicalBrandController.text = newValue;
                              },

                              items: vehicalController.vehicalBrands
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              style: GoogleFonts.montserrat(
                                color: Color.fromRGBO(179, 179, 179, 1),
                                fontWeight: FontWeight.w600,
                                fontSize: 10.sp,
                                // letterSpacing: 1.sp
                              ),
                              // decoration: InputDecoration(
                              //   contentPadding: EdgeInsets.symmetric(
                              //       horizontal: 12.0, vertical: 8.0),
                              //   isDense: true,
                              //   // border: OutlineInputBorder(
                              //   //   borderRadius: BorderRadius.circular(8.0),
                              //   //   borderSide: BorderSide(),
                              //   // ),
                              // ),
                            ),
                          ),
                        ))
                    // TextField(
                    //   controller: vehicalBrandController,
                    //   //  controller: usernameController,
                    //   decoration: InputDecoration(
                    //     border: InputBorder.none,
                    //     hintText: "Toyota",
                    //     hintStyle: GoogleFonts.montserrat(
                    //       color: Color.fromRGBO(179, 179, 179, 1),
                    //       fontWeight: FontWeight.w600,
                    //       fontSize: 10.sp,
                    //       // letterSpacing: 1.sp
                    //     ),
                    //   ),
                    //   style: GoogleFonts.montserrat(
                    //     color: Color.fromRGBO(179, 179, 179, 1),
                    //     fontWeight: FontWeight.w600,
                    //     fontSize: 10.sp,
                    //     // letterSpacing: 1.sp
                    //   ),
                    // ),
                    ),
              ],
            ),
          ),
          SizedBox(
            height: 5.w,
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20.sp)),
            width: 90.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 3.w, left: 3.w),
                  child: Text(
                    "Type",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700, fontSize: 12.sp),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                      left: 3.w,
                    ),
                    child: Container(
                        width: 90.w,
                        child: Obx(
                          () => DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: vehicalController.selectedType.value,
                              onChanged: (newValue) {
                                vehicalController.selectedType.value =
                                    newValue!;
                                vehicalTypeController.text = newValue;
                              },

                              items: vehicalController.vehicalTypes
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              style: GoogleFonts.montserrat(
                                color: Color.fromRGBO(179, 179, 179, 1),
                                fontWeight: FontWeight.w600,
                                fontSize: 10.sp,
                                // letterSpacing: 1.sp
                              ),
                              // decoration: InputDecoration(
                              //   contentPadding: EdgeInsets.symmetric(
                              //       horizontal: 12.0, vertical: 8.0),
                              //   isDense: true,
                              //   // border: OutlineInputBorder(
                              //   //   borderRadius: BorderRadius.circular(8.0),
                              //   //   borderSide: BorderSide(),
                              //   // ),
                              // ),
                            ),
                          ),
                        ))
                    // TextField(
                    //   controller: vehicalTypeController,
                    //   //  controller: usernameController,
                    //   decoration: InputDecoration(
                    //     border: InputBorder.none,
                    //     hintText: "SUV",
                    //     hintStyle: GoogleFonts.montserrat(
                    //       color: Color.fromRGBO(179, 179, 179, 1),
                    //       fontWeight: FontWeight.w600,
                    //       fontSize: 10.sp,
                    //       // letterSpacing: 1.sp
                    //     ),
                    //   ),
                    //   style: GoogleFonts.montserrat(
                    //     color: Color.fromRGBO(179, 179, 179, 1),
                    //     fontWeight: FontWeight.w600,
                    //     fontSize: 10.sp,
                    //     // letterSpacing: 1.sp
                    //   ),
                    // ),
                    ),
              ],
            ),
          ),
          SizedBox(
            height: 5.w,
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20.sp)),
            width: 90.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 3.w, left: 3.w),
                  child: Text(
                    "Model",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700, fontSize: 12.sp),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 3.w,
                  ),
                  child: TextField(
                    controller: vehicalModelController,
                    //  controller: usernameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Sonata",
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
          SizedBox(
            height: 5.w,
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20.sp)),
            width: 90.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 3.w, left: 3.w),
                  child: Text(
                    "Plate Number",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700, fontSize: 12.sp),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 3.w,
                  ),
                  child: TextField(
                    controller: vehicalPlateController,
                    //  controller: usernameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "HT-3234",
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
          SizedBox(
            height: 5.w,
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20.sp)),
            width: 90.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 3.w, left: 3.w),
                  child: Text(
                    "Color",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700, fontSize: 12.sp),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 3.w,
                  ),
                  child: TextField(
                    controller: vehicalColorController,
                    //  controller: usernameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Red",
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
        ],
      ),
    );
  }
}

class insuranceInformation extends StatefulWidget {
  const insuranceInformation({super.key});

  @override
  State<insuranceInformation> createState() => _insuranceInformationState();
}

class _insuranceInformationState extends State<insuranceInformation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      width: 100.w,
      child: Column(
        children: [
          SizedBox(
            height: 3.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    "Insurance Information",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700, fontSize: 14.sp),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        prefillInsuaranceData();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.red.withOpacity(0.2)),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 3.w, right: 3.w, top: 1.w, bottom: 1.w),
                        child: Text(
                          "Fill data",
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w700, fontSize: 10.sp),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 7.w,
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20.sp)),
            width: 90.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 3.w, left: 3.w),
                  child: Text(
                    "Insurance Agency",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700, fontSize: 12.sp),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 3.w,
                  ),
                  child: TextField(
                    controller: insuaranceAgencyController,
                    //  controller: usernameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "SLIC",
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
          SizedBox(
            height: 5.w,
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20.sp)),
            width: 90.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 3.w, left: 3.w),
                  child: Text(
                    "Policy number",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700, fontSize: 12.sp),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 3.w,
                  ),
                  child: TextField(
                    controller: insuarancePolicyController,
                    //  controller: usernameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "4220492",
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
          SizedBox(
            height: 5.w,
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20.sp)),
            width: 90.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 3.w, left: 3.w),
                  child: Text(
                    "Agent Contact",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700, fontSize: 12.sp),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 3.w,
                  ),
                  child: TextField(
                    controller: insuaranceAgentContactController,
                    //  controller: usernameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "0432284758",
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
        ],
      ),
    );
  }
}

class medicalInformation extends StatefulWidget {
  const medicalInformation({super.key});

  @override
  State<medicalInformation> createState() => _medicalInformationState();
}

class medicationsControllerGet extends GetxController {
  Rx<String?> selectedMedicalCondition = Rx<String?>(null);
  List<String> medicalConditions = [
    "Diabetes",
    "Hypertension",
    "Asthma",
    "Arthritis",
    "Depression",
    "Cancer",
    "Heart Disease",
  ];

  Rx<String?> selectedAllergies = Rx<String?>(null);
  List<String> allergies = [
    "Pollen",
    "Dust Mites",
    "Latex",
    "Peanuts",
    "Shellfish",
    "Bee Stings",
    "Penicillin",
  ];

  Rx<String?> selectedBloodType = Rx<String?>(null);
  List<String> bloodTypes = [
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
    "O+",
    "O-",
  ];
}

class _medicalInformationState extends State<medicalInformation> {
  @override
  Widget build(BuildContext context) {
    final medicationsControllerGet medicalController =
        Get.put(medicationsControllerGet());
    return Container(
      height: 85.h,
      width: 100.w,
      child: Column(
        children: [
          SizedBox(
            height: 3.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    "Medical Information",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700, fontSize: 14.sp),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        prefillmedicalInfo();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.red.withOpacity(0.2)),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 3.w, right: 3.w, top: 1.w, bottom: 1.w),
                        child: Text(
                          "Fill data",
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w700, fontSize: 10.sp),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 7.w,
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20.sp)),
            width: 90.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 3.w, left: 3.w),
                  child: Text(
                    "Medical Conditions",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700, fontSize: 12.sp),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                      left: 3.w,
                    ),
                    child: Container(
                        width: 90.w,
                        child: Obx(
                          () => DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: medicalController
                                  .selectedMedicalCondition.value,
                              onChanged: (newValue) {
                                medicalController
                                    .selectedMedicalCondition.value = newValue!;
                                medicalConditionsController.text = newValue;
                              },

                              items: medicalController.medicalConditions
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              style: GoogleFonts.montserrat(
                                color: Color.fromRGBO(179, 179, 179, 1),
                                fontWeight: FontWeight.w600,
                                fontSize: 10.sp,
                                // letterSpacing: 1.sp
                              ),
                              // decoration: InputDecoration(
                              //   contentPadding: EdgeInsets.symmetric(
                              //       horizontal: 12.0, vertical: 8.0),
                              //   isDense: true,
                              //   // border: OutlineInputBorder(
                              //   //   borderRadius: BorderRadius.circular(8.0),
                              //   //   borderSide: BorderSide(),
                              //   // ),
                              // ),
                            ),
                          ),
                        ))
                    // TextField(
                    //   controller: medicalConditionsController,
                    //   //  controller: usernameController,
                    //   decoration: InputDecoration(
                    //     border: InputBorder.none,
                    //     hintText: "Diabeties, High blood preasure . . .",
                    //     hintStyle: GoogleFonts.montserrat(
                    //       color: Color.fromRGBO(179, 179, 179, 1),
                    //       fontWeight: FontWeight.w600,
                    //       fontSize: 10.sp,
                    //       // letterSpacing: 1.sp
                    //     ),
                    //   ),
                    //   style: GoogleFonts.montserrat(
                    //     color: Color.fromRGBO(179, 179, 179, 1),
                    //     fontWeight: FontWeight.w600,
                    //     fontSize: 10.sp,
                    //     // letterSpacing: 1.sp
                    //   ),
                    // ),
                    ),
              ],
            ),
          ),
          SizedBox(
            height: 5.w,
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20.sp)),
            width: 90.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 3.w, left: 3.w),
                  child: Text(
                    "Allergies",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700, fontSize: 12.sp),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                      left: 3.w,
                    ),
                    child: Container(
                        width: 90.w,
                        child: Obx(
                          () => DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: medicalController.selectedAllergies.value,
                              onChanged: (newValue) {
                                medicalController.selectedAllergies.value =
                                    newValue!;
                                medicalAllergiesController.text = newValue;
                              },

                              items: medicalController.allergies
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              style: GoogleFonts.montserrat(
                                color: Color.fromRGBO(179, 179, 179, 1),
                                fontWeight: FontWeight.w600,
                                fontSize: 10.sp,
                                // letterSpacing: 1.sp
                              ),
                              // decoration: InputDecoration(
                              //   contentPadding: EdgeInsets.symmetric(
                              //       horizontal: 12.0, vertical: 8.0),
                              //   isDense: true,
                              //   // border: OutlineInputBorder(
                              //   //   borderRadius: BorderRadius.circular(8.0),
                              //   //   borderSide: BorderSide(),
                              //   // ),
                              // ),
                            ),
                          ),
                        ))
                    // TextField(
                    //   controller: medicalAllergiesController,
                    //   //  controller: usernameController,
                    //   decoration: InputDecoration(
                    //     border: InputBorder.none,
                    //     hintText: "Peanut, Shrimp . . . . ",
                    //     hintStyle: GoogleFonts.montserrat(
                    //       color: Color.fromRGBO(179, 179, 179, 1),
                    //       fontWeight: FontWeight.w600,
                    //       fontSize: 10.sp,
                    //       // letterSpacing: 1.sp
                    //     ),
                    //   ),
                    //   style: GoogleFonts.montserrat(
                    //     color: Color.fromRGBO(179, 179, 179, 1),
                    //     fontWeight: FontWeight.w600,
                    //     fontSize: 10.sp,
                    //     // letterSpacing: 1.sp
                    //   ),
                    // ),
                    ),
              ],
            ),
          ),
          SizedBox(
            height: 5.w,
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20.sp)),
            width: 90.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 3.w, left: 3.w),
                  child: Text(
                    "Blood type",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700, fontSize: 12.sp),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                      left: 3.w,
                    ),
                    child: Container(
                        width: 90.w,
                        child: Obx(
                          () => DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: medicalController.selectedBloodType.value,
                              onChanged: (newValue) {
                                medicalController.selectedBloodType.value =
                                    newValue!;
                                medicalBloodTypeController.text = newValue;
                              },

                              items: medicalController.bloodTypes
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              style: GoogleFonts.montserrat(
                                color: Color.fromRGBO(179, 179, 179, 1),
                                fontWeight: FontWeight.w600,
                                fontSize: 10.sp,
                                // letterSpacing: 1.sp
                              ),
                              // decoration: InputDecoration(
                              //   contentPadding: EdgeInsets.symmetric(
                              //       horizontal: 12.0, vertical: 8.0),
                              //   isDense: true,
                              //   // border: OutlineInputBorder(
                              //   //   borderRadius: BorderRadius.circular(8.0),
                              //   //   borderSide: BorderSide(),
                              //   // ),
                              // ),
                            ),
                          ),
                        ))

                    // TextField(
                    //   controller: medicalBloodTypeController,
                    //   //  controller: usernameController,
                    //   decoration: InputDecoration(
                    //     border: InputBorder.none,
                    //     hintText: "B Positive",
                    //     hintStyle: GoogleFonts.montserrat(
                    //       color: Color.fromRGBO(179, 179, 179, 1),
                    //       fontWeight: FontWeight.w600,
                    //       fontSize: 10.sp,
                    //       // letterSpacing: 1.sp
                    //     ),
                    //   ),
                    //   style: GoogleFonts.montserrat(
                    //     color: Color.fromRGBO(179, 179, 179, 1),
                    //     fontWeight: FontWeight.w600,
                    //     fontSize: 10.sp,
                    //     // letterSpacing: 1.sp
                    //   ),
                    // ),
                    ),
              ],
            ),
          ),
          SizedBox(
            height: 5.w,
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20.sp)),
            width: 90.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 3.w, left: 3.w),
                  child: Text(
                    "Medications",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700, fontSize: 12.sp),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 3.w,
                  ),
                  child: TextField(
                    controller: medicalMedicationController,
                    //  controller: usernameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Metformin, Asce . . . ",
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
        ],
      ),
    );
  }
}

Future<void> storeUserData(
    String userDataType, Map<String, dynamic> userData) async {
  showLoader();
  GetStorage box = GetStorage();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Define the document reference
  DocumentReference docRef = firestore
      .collection('users')
      .doc(box.read("UID"))
      .collection(userDataType)
      .doc("data");

  // Set the data on the document. This will overwrite existing data.
  await docRef.set(userData).then((_) {
    Get.back();
    print("User data stored successfully.");
  }).catchError((error) {
    Get.back();
    showErrorDialog("Error", "Data storing failed", "Try again");
    print("Error storing user data: $error");
  });
}

void updateUserStatus() async {
  showLoader();
  GetStorage box = GetStorage();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final DocumentReference documentReference =
      firestore.collection('users').doc(box.read("UID"));

  try {
    // Try to get the document
    final docSnapshot = await documentReference.get();

    if (docSnapshot.exists) {
      await documentReference.update({
        'basicData': true,
      });
      Get.back();
      Get.to(dashboardScreen()); // print("Document created with ID: $userId");
    }
  } catch (e) {
    print("Error accessing Firestore: $e");
  }
}

Future<void> fetchUserDataAndFillPersonalInfo() async {
  showLoader();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  GetStorage box = GetStorage();
  // Reference to the user's personalData document
  DocumentReference docRef = firestore
      .collection('users')
      .doc(box.read("UID"))
      .collection('personalData')
      .doc('data');

  try {
    // Attempt to fetch the document
    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      // Cast the data to Map<String, dynamic>
      Map<String, dynamic> userData =
          docSnapshot.data() as Map<String, dynamic>;

      // Assign the fetched values to the controllers
      firstNameController.text = userData['firstName'] ?? '';
      lastNameController.text = userData['lastName'] ?? '';
      addressController.text = userData['address'] ?? '';
      cityController.text = userData['city'] ?? '';
      DOBController.text = userData['DOB'] ?? '';
      mobileNumberController.text = userData['mobileNumber'] ?? '';
      genderController.text = userData['gender'] ?? '';
      Get.back();
    } else {
      Get.back();
      // Handle the case where the document does not exist
      print("Document does not exist.");
    }
  } catch (e) {
    Get.back();
    // Handle any errors that occur during the fetch operation
    print("Error fetching user data: $e");
  }
}

Future<void> fetchMedicalDataAndFillMedicalData() async {
  showLoader();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  GetStorage box = GetStorage();
  // Reference to the user's personalData document
  DocumentReference docRef = firestore
      .collection('users')
      .doc(box.read("UID"))
      .collection('medicalInformation')
      .doc('data');

  try {
    // Attempt to fetch the document
    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      // Cast the data to Map<String, dynamic>
      Map<String, dynamic> userData =
          docSnapshot.data() as Map<String, dynamic>;

      // Assign the fetched values to the controllers
      medicalConditionsController.text = userData['medicalConditions'] ?? '';
      medicalAllergiesController.text = userData['medicalAllergies'] ?? '';
      medicalBloodTypeController.text = userData['medicalBloodType'] ?? '';
      medicalMedicationController.text = userData['medicalMedication'] ?? '';
      Get.back();
    } else {
      Get.back();
      // Handle the case where the document does not exist
      print("Document does not exist.");
    }
  } catch (e) {
    Get.back();
    // Handle any errors that occur during the fetch operation
    print("Error fetching user data: $e");
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
      emergencyFirstnameController.text = userData['firstName'] ?? '';
      emergencyLastanameController.text = userData['lastName'] ?? '';
      emergencymobileController.text = userData['mobileNumber'] ?? '';
      emergencyRelationshipController.text = userData['relationship'] ?? '';
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

Future<void> fetchVehicleDataAndFillVehicalData() async {
  showLoader();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  GetStorage box = GetStorage();

  // Assuming the vehicle data is stored under a unique document
  DocumentReference docRef = firestore
      .collection('users')
      .doc(box.read("UID"))
      .collection('vehicleInformation')
      .doc('data');

  try {
    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      Map<String, dynamic> vehicleData =
          docSnapshot.data() as Map<String, dynamic>;

      // Assign the fetched values to the controllers for vehicle information
      vehicalBrandController.text = vehicleData['Brand'] ?? '';
      vehicalTypeController.text = vehicleData['Type'] ?? '';
      vehicalModelController.text = vehicleData['Model'] ?? '';
      vehicalPlateController.text = vehicleData['Plate'] ?? '';
      vehicalColorController.text = vehicleData['Color'] ?? '';
      Get.back();
    } else {
      Get.back();
      print("Vehicle document does not exist.");
    }
  } catch (e) {
    Get.back();
    print("Error fetching vehicle data: $e");
  }
}

Future<void> fetchInsuaranceDataAndFillInsuaranceData() async {
  showLoader();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  GetStorage box = GetStorage();

  // Assuming the vehicle data is stored under a unique document
  DocumentReference docRef = firestore
      .collection('users')
      .doc(box.read("UID"))
      .collection('insuranceInformation')
      .doc('data');

  try {
    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      Map<String, dynamic> insuaranceData =
          docSnapshot.data() as Map<String, dynamic>;

      // Assign the fetched values to the controllers for vehicle information
      insuaranceAgencyController.text = insuaranceData['agency'] ?? '';
      insuarancePolicyController.text = insuaranceData['policyNumber'] ?? '';
      insuaranceAgentContactController.text =
          insuaranceData['agentContact'] ?? '';
      Get.back();
    } else {
      Get.back();
      print("Vehicle document does not exist.");
    }
  } catch (e) {
    Get.back();
    print("Error fetching vehicle data: $e");
  }
}

Future<void> fetchInsuranceDataAndFillInsuaranceData() async {
  showLoader();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  GetStorage box = GetStorage();

  // Assuming the insurance data is stored under a specific document
  DocumentReference docRef = firestore
      .collection('users')
      .doc(box.read("UID"))
      .collection('insuranceInformation')
      .doc('data');

  try {
    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      Map<String, dynamic> insuranceData =
          docSnapshot.data() as Map<String, dynamic>;

      // Assign the fetched values to the controllers for insurance information
      insuaranceAgencyController.text = insuranceData['agency'] ?? '';
      insuarancePolicyController.text = insuranceData['policyNumber'] ?? '';
      insuaranceAgentContactController.text =
          insuranceData['agentContact'] ?? '';
      Get.back();
    } else {
      Get.back();
      print("Insurance document does not exist.");
    }
  } catch (e) {
    Get.back();
    print("Error fetching insurance data: $e");
  }
}

void prefilPersonalData() {
  firstNameController.text = "Krish";
  lastNameController.text = "LKrish";
  addressController.text = "Address 101";
  cityController.text = "City 101";
  DOBController.text = "Thu, Apr 4, 2024";
  mobileNumberController.text = "0713358701";
  genderController.text = "Male";
}

void prefillEmergencyData() {
  emergencyFirstnameController.text = "Krish";
  emergencyLastanameController.text = "LKrish";
  emergencymobileController.text = "0713358701";
  emergencyRelationshipController.text = "Mother";
}

void prefillVehicalData() {
  vehicalBrandController.text = "Toyota";
  vehicalTypeController.text = "Sedan";
  vehicalModelController.text = "Sonata";
  vehicalPlateController.text = "HT-8933";
  vehicalColorController.text = "RED";
}

void prefillmedicalInfo() {
  medicalConditionsController.text = "Diabetes";
  medicalAllergiesController.text = "Pollen";
  medicalBloodTypeController.text = "A+";
  medicalMedicationController.text = "None";
}

void prefillInsuaranceData() {
  insuaranceAgencyController.text = "SLIC";
  insuarancePolicyController.text = "11020";
  insuaranceAgentContactController.text = "071336374";
}
