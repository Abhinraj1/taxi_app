import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../../../Constants/Constants.dart';



Widget infoDataColumn({required String title, required String data, double? width}){
  return SizedBox(
    width: width ?? 100,
    height: 80,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600
          ),),
        Text(data,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w400
          ),),
      ],
    ),
  );


}