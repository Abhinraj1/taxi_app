import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../MapScreen/MapScreen.dart';
import '../../RideInfoScreen/RideInfoScreen.dart';


class BottomButtons extends StatelessWidget {
 final bool isLastCamera;
  const BottomButtons({Key? key,
  required this.isLastCamera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: SizedBox(
        width: 300,
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(const Size(100, 40)) ,
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const Text("Retake",
                style: TextStyle(
                    color: Colors.black
                ),),
              onPressed: () {
                Get.back();
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(const Size(100, 40)) ,
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(Colors.black),
              ),
              child: Row(
                children:  [
                  const SizedBox(
                    width: 9,
                  ),
                  isLastCamera ? const Text("Finish \nRide",
                    style: TextStyle(
                        color: Colors.white
                    ),) :
                  const  Text("Start \nRide",
                    style: TextStyle(
                        color: Colors.white
                    ),),
                  const Icon(Icons.arrow_forward_rounded)
                ],
              ),
              onPressed: () {

                /// Checking whether it is the end of ride image or starting image
                /// depending on which the user will be navigated to respective screens
                isLastCamera ?
                Get.to(const RideInfoScreen()) :
                Get.to(const MapScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
