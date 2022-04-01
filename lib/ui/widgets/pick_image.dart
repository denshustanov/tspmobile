import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile?> pickSingleImage(context) async {
  ImageSource imageSource = ImageSource.gallery;
  bool pickImage = false;

  await showDialog(context: context, builder: (context) =>
  AlertDialog(
    title: const Text('Photo'),
    content:  SizedBox(
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: const Text('Upload from device'),
            onTap: (){
              pickImage = true;
              Navigator.of(context).pop();
            },
          ),
          GestureDetector(
            child: const Text('Take photo'),
            onTap: (){
              imageSource = ImageSource.camera;
              pickImage = true;
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    ),
  ));

  if(!pickImage){
    return null;
  }

  final ImagePicker imagePicker = ImagePicker();
  final XFile? image =
  await imagePicker.pickImage(source: imageSource, imageQuality: 25);
  return image;
}

Future<List<XFile>?> pickMultipleImages() async{
  final ImagePicker imagePicker = ImagePicker();
  final List<XFile>? images = await imagePicker.pickMultiImage(imageQuality: 25);

  return images;
}

Future<XFile?> takeImage() async{
  final ImagePicker imagePicker = ImagePicker();
  final XFile? image = await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 25);
  return image;
}