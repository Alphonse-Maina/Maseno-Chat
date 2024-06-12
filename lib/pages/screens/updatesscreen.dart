import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masenochat/pages/screens/ConfirmupdateScreen.dart';
import 'package:permission_handler/permission_handler.dart';

class UpdatesScreen extends StatelessWidget {

  pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    if( video!= null){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConfirmScreen(videofile: File(video.path), videopath: video.path),),);
    }
  }

  showOptionsDialog(BuildContext context){
  return showDialog(context: context, builder: (context) => SimpleDialog(
    children: [
    SimpleDialogOption(
      onPressed: () => pickVideo(ImageSource.gallery, context),
      child: const Row(
        children: [
          Icon(Icons.image),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Gallery', style: TextStyle(fontSize: 30),),
          )
        ],
      ),
    ),
      SimpleDialogOption(
        onPressed:  () => pickVideo(ImageSource.camera, context),
        child: const Row(
          children: [
            Icon(Icons.camera_alt),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Camera', style: TextStyle(fontSize: 30),),
            )
          ],
        ),
      ),SimpleDialogOption(
        onPressed: () => Navigator.of(context).pop(),
        child: const Row(
          children: [
            Icon(Icons.cancel),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Cancel', style: TextStyle(fontSize: 30),),
            )
          ],
        ),
      ),
    ],
  ),);
  }
  @override
  Widget build(BuildContext context) {
    // Your implementation for the Updates screen
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: (){
            showOptionsDialog(context);
          },
          child: Container(
            width: 200,
            height: 100,
            decoration: BoxDecoration(color: Colors.pinkAccent,
            borderRadius: BorderRadius.circular(10),),
            child: const Center(
              child: Text('Add Video',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),),
            ),
          ),
        ),
      ),
    );
  }
}