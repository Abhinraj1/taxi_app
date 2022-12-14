import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxi_app/Screens/SplashScreen/SplashScreen.dart';
import '../../Constants/Constants.dart';
import 'Widgets/InfoDataColumn.dart';



class RideInfoScreen extends StatelessWidget {
  const RideInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Container(
              height: 300,
              width: 340,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(50)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Ride Information",
                    style: TextStyle(
                        color: Colors.deepPurpleAccent.shade700,
                        fontSize: 25,
                        fontWeight: FontWeight.w700
                    ),),
                  SizedBox(
                    width: 320,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        /// Custom widget to show data
                        /// here it shows staring time
                        infoDataColumn(
                          width: 120,
                            title: "Start Time",
                          data: box.read('startTime')
                        ),

                        infoDataColumn(
                            width: 120,
                            title: "Finish Time",
                            data: box.read('endTime')
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 320,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        infoDataColumn(
                            title: "Time",
                            data: box.read('totalTime')
                        ),
                        infoDataColumn(
                            title: "Distance",
                            data: box.read('totalDistance')
                        ),
                        infoDataColumn(
                            title: "Avg Speed",
                            data: box.read('avgSpeed')
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          ElevatedButton(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size(300, 40)) ,
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(Colors.black),
            ),
              child: const Text("Save Info",
              style: TextStyle(
                  color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18
              ),),
            onPressed: () {
              upload.value = true;
              Get.to(const SplashScreen());
            },
          )
        ],
      ),
    );
  }
}
