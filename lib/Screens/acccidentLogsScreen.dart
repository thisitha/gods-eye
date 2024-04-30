import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class accidentLogs extends StatefulWidget {
  const accidentLogs({super.key});

  @override
  State<accidentLogs> createState() => _accidentLogsState();
}

class _accidentLogsState extends State<accidentLogs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF4C238),
      body: Container(
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
                              Get.back();
                            },
                            child: Icon(Icons.arrow_back_ios)),
                        Text(
                          "Accident Logs",
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
                child: FutureBuilder<List<QueryDocumentSnapshot>>(
                  future: fetchAccidentLogs(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.yellow,
                          strokeWidth: 1.sp,
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.data!.length != 0) {
                      return ListView.builder(
                        padding: EdgeInsets.only(top: 2.h),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          var document = snapshot.data![index];
                          LatLng location = LatLng(
                              document['latitude'], document['longitude']);
                          return Padding(
                            padding: EdgeInsets.only(
                                left: 5.w, right: 5.w, top: 4.w),
                            child: Container(
                              width: 90.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.sp),
                                  color: Color(0xfff5f5f5)),
                              child: Padding(
                                padding: EdgeInsets.all(3.w),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 10.h,
                                          width: 30.w,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text("Accident ID",
                                                  style: GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12.sp)),
                                              Text("Date",
                                                  style: GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12.sp)),
                                              Text("Time",
                                                  style: GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12.sp)),
                                              Text("Location",
                                                  style: GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12.sp)),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 10.h,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(document['accidentId'],
                                                  style: GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 10.sp,
                                                      color:
                                                          Color(0xff737373))),
                                              Text(document['date'],
                                                  style: GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 10.sp,
                                                      color:
                                                          Color(0xff737373))),
                                              Text(document['time'],
                                                  style: GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 10.sp,
                                                      color:
                                                          Color(0xff737373))),
                                              Container(
                                                width: 30.w,
                                                child: Text(
                                                    document['locationName'],
                                                    maxLines: 3,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 10.sp,
                                                            color: Color(
                                                                0xff737373))),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Icon(Icons.map_outlined,
                                            size: 20.w,
                                            color: Colors.grey.shade400),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      print("no Data");
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.hourglass_empty,
                            size: 20.w,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Center(
                              child: Text(
                            'No accidents are recorded',
                            style: GoogleFonts.montserrat(fontSize: 12.sp),
                          )),
                          SizedBox(
                            height: 5.h,
                          ),
                        ],
                      );
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}

Future<List<QueryDocumentSnapshot>> fetchAccidentLogs() async {
  // Fetch documents from Firestore
  GetStorage box = GetStorage();
  var querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(box.read("UID"))
      .collection("accidentInfo")
      .get();
  return querySnapshot.docs;
}
