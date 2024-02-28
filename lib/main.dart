import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:msn_chat/firebase_options.dart';
import 'package:msn_chat/pages/home.dart';
import 'package:msn_chat/services/auth.dart';
import 'package:msn_chat/services/auth_gate.dart';
import 'package:msn_chat/services/login_or_register.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
        create: (context) => AuthService(),
      child: const MyApp(),
    ),
  );
}
class MsnApp extends StatelessWidget{
   const MsnApp({super.key});

   @override
  Widget build(BuildContext context){
     return const MaterialApp(
       debugShowCheckedModeBanner: false,
       home: AuthGate(),
       routes: {
         // '/':(context) => AuthGate(),
         // '/home':(context) => MyApp(),
         // '/login':(context) => LoginOrRegister(),
       },
     );
   }
}

