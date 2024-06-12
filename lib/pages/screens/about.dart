import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bachelor\'s Project'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('images/cartoon2.jpg'), // Replace 'your_picture.jpg' with your actual picture file
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to My Bachelor\'s Project!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'This application was created as a result of the institution requiring me to have a project to earn my bachelor\'s degree in computer science kindly bare with all the shortcomings of the application and enjoy using my app.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Contact Information:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Phone: +254704668123', // Replace 'Your Phone Number' with your actual phone number
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Email: rexalphonso@gmail.com', // Replace 'Your Email Address' with your actual email
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

