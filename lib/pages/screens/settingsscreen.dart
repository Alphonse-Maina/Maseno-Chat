import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masenochat/pages/screens/security.dart';
import 'package:url_launcher/url_launcher.dart';

import 'about.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getCurrentUserPicture() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final snapshot = await _firestore.collection('users').doc(currentUser.uid).get();
      final userData = snapshot.data();
      return userData?['profile']; // Assuming 'profilePicture' is the field storing the picture URL
    }
    return null;
  }
  // chatsettings

  // update profile picture
  void updateProfilePicture(String userId, File newProfilePic) async {
    // Get Firestore and Firebase Storage instances
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseStorage storage = FirebaseStorage.instance;

    // Reference to the document containing user profile data
    DocumentReference userRef = firestore.collection('users').doc(userId);

    try {
      // Upload new profile picture to Cloud Storage
      TaskSnapshot uploadTask = await storage
          .ref()
          .child('profilpics')
          .child('$userId.jpg')
          .putFile(newProfilePic);

      // Get the download URL of the uploaded image
      String downloadUrl = await uploadTask.ref.getDownloadURL();

      // Update the profile picture URL in Firestore
      await userRef.update({
        'profile': downloadUrl,
      });

      print('Profile picture updated successfully!');
    } catch (e) {
      print('Error updating profile picture: $e');
    }
  }

  final String whatsappNumber = '+254752406708'; // Replace with your WhatsApp number
  final String message = 'I need help!'; // Predefined message


  Future<void> _launchWhatsApp() async {
    final Uri uri = Uri.parse('https://wa.me/$whatsappNumber/?text=${Uri.encodeFull(message)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  Uint8List? img ;
  String imgpath = '';
  late File file;
  pickimage(ImageSource src, BuildContext context) async {

    XFile? _file = await ImagePicker().pickImage(source: src);
    file = File(_file!.path);
    if( _file!= null){
      setState(() {
        imgpath = _file.path;
      });
      updateProfilePicture(_auth.currentUser!.uid, file);
      return await _file.readAsBytes();
    }

    print('no image selected');
  }

  showOptionsDialog(BuildContext context){
    return showDialog(context: context, builder: (context) => SimpleDialog(
      children: [
        SimpleDialogOption(
          onPressed: () async {
            Uint8List image = await pickimage(ImageSource.gallery, context);
            setState(() {
              img = image;
            });
            Navigator.of(context).pop();
          },
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
          onPressed:   () async {
            Uint8List image = await pickimage(ImageSource.camera, context);
            setState(() {
              img = image;
            });
            Navigator.of(context).pop();
          },
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
   String _profilePictureUrl = '';

  @override
  void initState() {
    super.initState();
    _retrieveProfilePictureUrl();
  }

  Future<void> _retrieveProfilePictureUrl() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final snapshot = await _firestore.collection('users').doc(currentUser.uid).get();
      final userData = snapshot.data();
      setState(() {
        _profilePictureUrl = userData?['profile']; // Assuming 'profilePicture' is the field storing the picture URL
      });
    }
  }
  void security(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecurityScreen()),
    );
  }
  void about(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AboutScreen()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(

        children: [
          SizedBox(height: 20),
          Center(
            child: Stack(
              children: [
                img != null ? CircleAvatar(
                  backgroundImage: MemoryImage(img!),
                  backgroundColor: Colors.black12,
                  radius: 100.0,
                ):
                 CircleAvatar(
                  backgroundImage: NetworkImage(_profilePictureUrl),
                  backgroundColor: Colors.black12,
                  radius: 100.0,

                ),
                Positioned(
                    left: 120,
                    bottom: -10,
                    child: IconButton(
                      onPressed:(){
                        showOptionsDialog(context);
                      },
                      icon: Icon(Icons.add_a_photo),
                      iconSize: 50,
                    ))
              ],
            ),
          ),
          SizedBox(height: 30),
          Divider(),
          SizedBox(height: 20),
          ListTile(
            title: Text('Account'),
            onTap: () {
              // Handle account settings
            },
          ),
          Divider(),
          ListTile(
            title: Text('Chats'),
            onTap: () {
              //chatsettings();
            },
          ),
          Divider(),
          ListTile(
            title: Text('Notifications'),
            onTap: () {
              // Handle notification settings
            },
          ),
          Divider(),
          ListTile(
            title: Text('Privacy'),
            onTap: () {
              // Handle privacy settings
            },
          ),
          Divider(),
          ListTile(
            title: Text('Security'),
            onTap: () {
              // Handle security settings
              security(context);
            },
          ),
          Divider(),
          ListTile(
            title: Text('Help'),
            onTap: () {
              _launchWhatsApp();
            },
          ),
          Divider(),
          ListTile(
            title: Text('About'),
            onTap: () {
              // Handle about settings
              about(context);
            },
          ),
        ],
      ),
    );
  }
}