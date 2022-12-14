import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../../../Constants/Constants.dart';



Widget dataColumn({required String title, required String subTitle, required String data}){
  return SizedBox(
    width: 100,
    height: 100,
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
        Text(subTitle,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w400
          ),),

        Text(data,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600
          ),),

      ],
    ),
  );


}