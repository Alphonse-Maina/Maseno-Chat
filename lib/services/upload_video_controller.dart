import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:masenochat/model/video.dart';
import 'package:video_compress_plus/video_compress_plus.dart';

class UploadVideoController extends GetxController{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  _compressVideo(String videopath) async{
  final compressedvideo = await VideoCompress.compressVideo(videopath, quality: VideoQuality.MediumQuality);
  return compressedvideo!.file;
  }
  _getThumbnail(videopath) async{
    final thumbnail = await VideoCompress.getFileThumbnail(videopath);
    return thumbnail;
  }
  Future<String> _uploadVideoToStorage(String id, String videopath) async{
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('videos').child(id);
    UploadTask uploadTask = ref.putFile(await _compressVideo(videopath));
    TaskSnapshot snap = await uploadTask;
    String downloadurl = await snap.ref.getDownloadURL();
    return downloadurl;

  }
  Future<String> _uploadImageToStorage(String id, String videopath) async{
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('videos').child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videopath));
    TaskSnapshot snap = await uploadTask;
    String downloadurl = await snap.ref.getDownloadURL();
    return downloadurl;

  }

  //upload video
  uploadVideo(String songName, String caption, String videoPath) async {
    try{
            String uid = FirebaseAuth.instance.currentUser!.uid;
            DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
            var allDocs = await FirebaseFirestore.instance.collection('videos').get();
            DateTime now = DateTime.now();
            String len = DateFormat('yyyyMMddHHmmss').format(now);
            print('0 got here');
            String videourl = await _uploadVideoToStorage("Video $len", videoPath);
            String thumbnail = await _uploadImageToStorage("Video $len", videoPath);
            print(videourl);
            Video video = Video(
              username: (userDoc.data()! as Map<String, dynamic>)['name'],
              uid: uid,
              id: "video $len",
              likes: [],
              commentCount: 0,
              shareCount: 0,
              songName: songName,
              caption: caption,
              videoURL: videourl,
              thumbnail: thumbnail,
              //profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
            );
            print(thumbnail);
            await firestore.collection('videos').doc('Video $len').set(video.toJson());
            Get.back();
    }catch(e){
    Get.snackbar('Error uploading video', e.toString());
    }
  }
}