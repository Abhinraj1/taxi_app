import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:intl/intl.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:taxi_app/Constants/Constants.dart';
import 'package:location/location.dart';
import 'package:taxi_app/Screens/RideInfoScreen/RideInfoScreen.dart';
import 'Widgets/DataColumn.dart';



class MapScreen extends StatefulWidget {
  const MapScreen({Key? key,}) : super(key: key);


  @override
  _MapScreenState createState() => _MapScreenState();
}
class _MapScreenState extends State<MapScreen> {

  final Completer<GoogleMapController> _controller = Completer();


  final MapsRoutes route =  MapsRoutes();
  final DistanceCalculator distanceCalculator =  DistanceCalculator();

  /// Time counter when user Starts
  final StopWatchTimer stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  final String googleApiKey = Const().apiKey;
   LocationData? locationData;

   /// To switch modes based on user input
   bool tripEnded = false,
      started = false,
      loading = true;
   /// Ride time
  String totalTime = "";
  /// Ride start time and end time
  String startTime = "",
      endTime ="";



  @override
  void initState() {
    super.initState();
    getPermissions();
    updateLocation();
  }


  @override
  void dispose() async {
    super.dispose();
    getPermissions();
    updateLocation();
    updateTime();
    await stopWatchTimer.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
            body: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child:
                      /// NULL CHECK
                  startIcon == null &&
                      carIcon == null &&
                      endIcon == null &&
                      points.isNotEmpty &&
                      locationData == null ?
                  const Center(child: Text("loading...")) :
                  SizedBox(
                    height: 600,
                    child: SafeArea(
                      child: GoogleMap(
                        zoomControlsEnabled: true,
                       // myLocationButtonEnabled: !started,
                        scrollGesturesEnabled: true,
                        compassEnabled: false,
                      //  myLocationEnabled: !started,
                        zoomGesturesEnabled: true,
                        polylines:
                        <Polyline>{
                          ///TO draw lines between start and end
                           Polyline(
                             polylineId: const PolylineId("route"),
                          points: points,
                          geodesic: true,
                            width: 5,
                            color: Colors.green,
                            visible: started,
                           ),
                        },
                        markers: {

                          /// Depending on mode the marker will be either default marker or Starting point
                          /// which will be shown on user location
                          Marker(
                            markerId: const MarkerId("Start"),
                            icon: !tripStarted.value ? BitmapDescriptor.fromBytes(startIcon!) :
                            BitmapDescriptor.defaultMarker,
                            position: started ? points.first : points.last,
                            infoWindow:  InfoWindow(
                              title: tripStarted.value ?  'Pick Up Location' : "Your Location",
                              snippet: tripStarted.value ? 'Start' : " ",
                            ),
                            visible: true
                          ),

                          /// car marker which is only visible when rider is riding
                       Marker(
                              markerId: const MarkerId("driver"),
                           icon: BitmapDescriptor.fromBytes(carIcon!),
                              position:  points.last,
                           infoWindow: const InfoWindow(
                             title: 'Your Location',
                             snippet: 'Driving',
                           ),
                         visible: tripEnded
                          ),

                          /// End point marker visible after ride ends
                          Marker(
                            anchor: const Offset(0,1),
                              markerId: const MarkerId("Finished"),
                              icon:  BitmapDescriptor.fromBytes(endIcon!),
                              position:  points.last,
                              infoWindow: const InfoWindow(
                                title: 'Drop Location',
                                snippet: 'End',
                              ),
                              visible: started ? !tripEnded : false,
                          )
                        },

                        /// initial camera point @ user location
                        initialCameraPosition:  CameraPosition(
                          zoom: 25,
                          target: started ? points.first : points.last
                        ),

                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child:
                  Container(
                    height: 220,
                    width: double.infinity,
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
                        Text("Ride In Progress",
                          style: TextStyle(
                              color: Colors.deepPurpleAccent.shade700,
                              fontSize: 25,
                              fontWeight: FontWeight.w700
                          ),),
                        SizedBox(
                          width: 320,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              /// Show live  Ride time
                              StreamBuilder<int>(
                                stream: stopWatchTimer.rawTime,
                                initialData: stopWatchTimer.rawTime.value,
                                builder: (context, snap) {
                                  final value = snap.data!;
                                   totalTime =
                                  StopWatchTimer.getDisplayTime(value,hours: true,);

                                   /// Custom widget to show data.
                                  /// Here it shows Time
                                  return dataColumn(
                                      data: totalTime,
                                      subTitle: "HH:MM:SS",
                                      title: "Time"
                                  );
                                },
                              ),

                              /// Show Live Km travelled
                              Obx(
                                () {
                                  return dataColumn(
                                      data: totalDistance.value,
                                      subTitle: "KM",
                                      title: "Distance"
                                  );
                                }
                              ),

                              /// show live Average speed of ride
                              Obx(() {
                                    return   dataColumn(
                                        data: avgSpeed.value.isNotEmpty ? avgSpeed.value.last.toInt().toString() : "0",
                                        subTitle: "KM/H",
                                        title: "Avg Speed"
                                    );
                                  }
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(

                    /// to detect swipe
                    onHorizontalDragEnd: (direction){
                      if(direction.primaryVelocity! >= 10.0){
                        slideButtonFunction();
                      }
                    },
                    /// Optional
                    onTap: (){
                      slideButtonFunction();
                    },
                    child: Container(
                      width: 230,
                      height: 50,
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          /// shows message as per rider state
                          Text( started ? "Slide to Finish" :"Slide to Start",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600
                            ),),
                          const SizedBox(
                            width: 20,
                          ),
                          const Icon(Icons.arrow_forward_rounded,color: Colors.white,)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
        );

  }
/// Slide Buttoon function
  slideButtonFunction(){

    /// control timer
    tripEnded ? stopWatchTimer.onStopTimer() : stopWatchTimer.onStartTimer();

    /// save starting and end time
    updateTime();

    setState(() {
      tripStarted.value = !tripStarted.value;
      started = !started;
      tripEnded = !tripEnded;
    });
    if(!tripEnded){

      /// save all data locally
     saveDataLocally();
    Get.to(const RideInfoScreen());
    }
  }

 saveDataLocally(){
   box.write("totalTime", totalTime);
   box.write("totalDistance", totalDistance.value);
   box.write("startTime", startTime.toString());
   box.write("endTime", endTime.toString());

   ///calculate average speed and store locally
   box.write("avgSpeed", (
       avgSpeed.map((m) => m).reduce((a, b) => a + b) / avgSpeed.length).toInt().toString());
 }

 ///Update Location
    updateLocation() async{
    location.getLocation().then(
          (location) {
        locationData = location;
      },
    );

    /// update camera location when user location changes
    location.onLocationChanged.listen((LocationData currentLocation) async {
      locationData = currentLocation;
      GoogleMapController gMapController = await _controller.future;
      gMapController.animateCamera(
          CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
              currentLocation.latitude!,
              currentLocation.longitude!
            ),
            zoom: 17),
      ));

      /// adding location data to points list
      points.add(LatLng(currentLocation.latitude!, currentLocation.longitude!));
        updateDistance();
        updateSpeed();
        setState(() {});
    });
  }

  updateTime(){
    if(!tripStarted.value){
      DateTime sTime = DateTime.now();
    startTime = DateFormat('d MMM yyyy, hh:mm a').format(sTime);
    }else{
      DateTime eTime = DateTime.now();
        endTime = DateFormat('d MMM yyyy, hh:mm a').format(eTime);
      box.write("endTime", endTime.toString());
    }
  }

  updateSpeed(){
    avgSpeed.value.add(locationData!.speed!.toInt()*3.6);
  }

 /// shows ride distance
  updateDistance(){
    totalDistance.value = distanceCalculator.calculateRouteDistance(points , decimals: 1);
  }

  /// get location permissions
  getPermissions() async{
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return ;
      }
    }
    setState(() {});
  }
}