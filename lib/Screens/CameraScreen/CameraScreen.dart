import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Constants/Constants.dart';
import '../PreviewScreen/PreviewScreen.dart';



class CameraScreen extends StatefulWidget{
 final  bool? isLastCamera;
  const CameraScreen({
    super.key,
  this.isLastCamera});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {

  List<CameraDescription>? cameras; //list out the camera available
  CameraController? controller; //controller for camera
  ///Image taken Before Starting the Ride
  XFile? staringImage;
  /// Image taken after the Ride
  XFile? endingImage;

  @override
  void initState() {
    loadCamera();
    super.initState();
  }

  loadCamera() async {
    cameras = await availableCameras();
    if(cameras != null){
      controller = CameraController(cameras![0], ResolutionPreset.max);
      //cameras[0] = first camera, change to 1 to another camera

      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }else{
     Get.snackbar("ERROR ", "Camera Not Found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Capture Starting Point"),
        backgroundColor: Colors.redAccent,
      ),
      body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
              children:[
                SizedBox(
                    height:double.infinity,
                    width:double.infinity,
                    child: controller == null?
                    const Center(child:Text("Loading Camera...")):
                    !controller!.value.isInitialized?
                    const Center(
                      child: CircularProgressIndicator(),
                    ):
                    CameraPreview(controller!)
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 20
                    ),
                    child: MaterialButton(
                      height: 80,
                      minWidth: 80,
                      color: Colors.black,
                      shape: const CircleBorder(
                      ),
                      onPressed: () async{
                        try {
                          if(controller != null){
                            if(controller!.value.isInitialized){
                              staringImage = await controller!.takePicture();

                              ///Checking Whether Rider starting the ride or ended the ride
                              widget.isLastCamera ?? false ?

                                  /// Storing data Locally
                              box.write("endingImage", endingImage):
                              box.write("staringImage", staringImage);
                              setState(() {});

                              ///Navigate to Image Preview Screen
                              Get.to(
                                  PreviewScreen(
                                    ///Checking Whether Rider starting the ride or ended the ride
                                    ///To show image accordingly
                                isLastCamera: widget.isLastCamera ?? false ,
                              ));
                            }
                          }
                        } catch (e) {
                         Get.snackbar('ERROR!', e.toString()); //show error
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Camera\n button",
                          style: TextStyle(
                              color: Colors.white
                          ),),
                      ),

                    ),
                  ),
                )
              ]
          )
      ),

    );
  }
}