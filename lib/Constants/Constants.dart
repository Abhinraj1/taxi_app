import 'dart:typed_data';
import 'package:location/location.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



var totalDistance = '0'.obs;
var upload = false.obs;
var tripStarted = true.obs;
var avgSpeed = [].obs;
final box = GetStorage();
Uint8List? startIcon;
Uint8List? endIcon;
Uint8List? carIcon;
final List<LatLng> points = [];
final Location location =  Location();


class Const{
 String apiKey = "API KEY HERE";
}

