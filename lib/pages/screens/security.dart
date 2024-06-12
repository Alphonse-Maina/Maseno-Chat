import 'package:flutter/material.dart';

class SecurityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return

      Scaffold(
        appBar: AppBar(
          title: const Text('Security'),
        ),
        body: const Center(
          child:Text("Connection in this application is not encrypted. Sharing of sensitive media is therefore not recommended.",
    style: TextStyle(
    fontSize: 16.0,),
        ),
      ),
      );
  }
}
