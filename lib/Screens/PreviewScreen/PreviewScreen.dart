import 'package:flutter/material.dart';
import 'package:taxi_app/Constants/Constants.dart';
import 'dart:io';
import 'Widgets/BottomButtons.dart';


class PreviewScreen extends StatelessWidget {
 final  bool isLastCamera;
   const PreviewScreen({Key? key,
     required this.isLastCamera
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      body :
     SizedBox(
       height: double.infinity,
       width: double.infinity,
       child: Column(
         children: [
           const SizedBox(
             height: 50,
           ),
           checkNull() ?
           const Center(
               child:  Text("No image captured")):

               ///Shows Taken Image
           imagePreview(),
           const Flexible(
             child:  SizedBox(
               height: double.infinity,
             ),
           ),

            ///Custom Button
            BottomButtons(
             isLastCamera: isLastCamera,
           ),

         ],
       ),
     )
    );
  }

  Widget imagePreview(){
    return Center(
      child: Container(
        width: 280,
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black,
            width: 1
          ),
          borderRadius: BorderRadius.circular(50)
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.file(File(
            isLastCamera ?

                /// Retrieving data from local Storage
          box.read("endingImage").path :
          box.read("staringImage").path,),
            fit: BoxFit.fill,),
        ),
      ),
    );
  }

/// Checking whether it is the end of ride image or starting image
 bool checkNull() {
   if(isLastCamera){
     if(box.read("endingImage") != null){
       return false;
     }else{
       return true;
     }
   }else{
     if(box.read("staringImage") != null){
       return false;
     }else{
       return true;
     }
   }
 }
}