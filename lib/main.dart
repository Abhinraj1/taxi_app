import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'Screens/SplashScreen/SplashScreen.dart';



 void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await GetStorage.init();
   await Firebase.initializeApp();
  runApp( const MyApp());
}


class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return   const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen()
    );
  }
}

/// PACKAGES USED FOR THIS PROJECT

/// For camera
//  camera: ^0.10.0+4

/// To Load Image
//   image_picker: ^0.8.6

/// To get Location
//   location: ^4.4.0

/// To draw polylines on routes
//   google_maps_routes: ^1.1.2

/// For Google Maps
//   google_maps_flutter: ^2.2.2

/// Ride Timer
//   stop_watch_timer: ^2.0.0

/// For Navigation and other data related functions
//   get: ^4.6.5

/// To store Data locally
//   get_storage: ^2.0.3

/// Time and Date
//   intl: ^0.17.0

/// TO user firebase and communicate with database
//   firebase_database: ^10.0.6
//   firebase_core: ^2.3.0

/// To check Connection
//   connectivity_plus: ^3.0.2