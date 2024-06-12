import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masenochat/services/upload_video_controller.dart';
import 'dart:io';

import 'package:video_player/video_player.dart';

class ConfirmScreen extends StatefulWidget {
  final File videofile;
  final String videopath;
  const ConfirmScreen({super.key, required this.videofile, required this.videopath});

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late VideoPlayerController controller;
  TextEditingController _songController = TextEditingController();
  TextEditingController _captionController = TextEditingController();
  UploadVideoController uploadVideoController = Get.put(UploadVideoController());

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videofile);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/1.5,
              child: VideoPlayer(controller),
            ),
            const SizedBox(
              height: 30,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10),
                    width: MediaQuery.of(context).size.width-20,
                    child: TextField(
                      controller: _songController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Song name',
                        prefixIcon: Icon(Icons.music_note),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10),
                    width: MediaQuery.of(context).size.width-20,
                    child: TextField(
                      controller: _captionController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Caption',
                        prefixIcon: Icon(Icons.closed_caption),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: () => uploadVideoController.uploadVideo(_songController.text, _captionController.text, widget.videopath),
                      child: const Text('Share', style: TextStyle(fontSize: 20, color: Colors.black),)
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
