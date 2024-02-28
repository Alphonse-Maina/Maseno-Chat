import 'package:flutter/material.dart';
import 'package:msn_chat/pages/log_in.dart';
import 'package:msn_chat/pages/register.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  void togglepages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return log_in(onTap: togglepages);
    }
    else{
      return register(onTap: togglepages);
    }
  }
}
