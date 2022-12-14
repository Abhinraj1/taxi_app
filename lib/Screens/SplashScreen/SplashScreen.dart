import 'dart:async';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import '../../Constants/Constants.dart';
import '../CameraScreen/CameraScreen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late DatabaseReference ref;

  @override
  void initState() {
    super.initState();

    /// load custom Markers
    loadMarkers();

    ///Get user location
    location.getLocation().then((value) {
      points.add(LatLng(value.latitude!, value.longitude!));
      setState(() {});
    });

    ///For firebase database
    ref = FirebaseDatabase.instance.ref().child("RideData");

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {

      ///Auto upload when connection state changes
      if(upload.value) {
      uploadData();
      }
      // Got a new connectivity status!
    });

    if(upload.value) {
      uploadData();
    }
  }

  @override
  dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
    ref;
    uploadData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Flexible(
            child: SizedBox(
              height: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 20
            ),
            child: Center(
              child: MaterialButton(
                height: 150,
                minWidth: 150,
                color: Colors.black,
                shape: const CircleBorder(
                ),
                onPressed: () {
                  Get.to(const CameraScreen());
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child:    Text( "TAP TO START",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                    ),),
                ),
              ),
            ),
          ),

                const Text(
                "ABHINETHRA",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                ),),

          const SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }

  /// Upload the data from local storage to firebase database
  uploadData(){
    Map<String,dynamic> data = {
      "startTime": box.read('startTime'),
      "endTime": box.read('endTime'),
      "totalRideTime": box.read('totalTime'),
      "distance" : box.read('totalDistance'),
      "avgSpeed" : box.read('avgSpeed')
    };
    ref.push().set(data).then((value) {
      Get.snackbar(
          "Great! You Are Online",
          "Ride Information Has Been Uploaded",
          backgroundColor: Colors.green
      );
      upload.value = false;
    });
  }


  /// Custom markers
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();

  }


  loadMarkers(){
    getBytesFromAsset("images/car.png",100).then((value) {
      carIcon = value;
      getBytesFromAsset("images/start.png",150).then((value) {
        startIcon = value;
      });
      getBytesFromAsset("images/end.png",150).then((value) {
        endIcon = value;
      });
    });
    setState(() {});
  }
}
