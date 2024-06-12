import 'package:flutter/material.dart';
class Pic extends StatefulWidget {
  final String profile;
  final String uname;
  const Pic({super.key,
    required this.profile,
    required this.uname,
  });

  @override
  State<Pic> createState() => _PicState();
}

class _PicState extends State<Pic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(widget.uname),
      ),
      body: Center(
        child: Image.network(
          widget.profile, // Replace with the URL of your network image
          width: MediaQuery.of(context).size.width, // Adjust width as needed
          height: MediaQuery.of(context).size.height, // Adjust height as needed
          //fit: BoxFit.contain, // Adjust fit as needed
        ),
      ),
    );
  }
}
