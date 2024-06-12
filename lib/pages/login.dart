import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String? reglogin = '';
  String? passlogin = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _loginReg = TextEditingController();
  final TextEditingController _loginpass = TextEditingController();
  dynamic loginReg;
  void  _login() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try{
      await authService.signInWithEmailAndPassword(_loginReg.text, _loginpass.text,);
    }catch (e){
      print(e.toString());
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString(),),),);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Maseno Chat App'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 54, 200, 244),

      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,


        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 100.0,
            ),
            const Center(
              child: CircleAvatar(
                backgroundImage: AssetImage('images/masenologo.png'),
                radius: 100.0,

              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Center(
              child: Text(
                'Welcome back',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
              ),
            ),
            Divider(
              height: 60.0,
              color: Colors.grey[800],
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                        labelText: 'Enter your Email',
                        fillColor: Colors.grey.shade200,
                        filled: true,
                      ),
                      controller: _loginReg,
                      validator: (String? value){
                        if(value == null || value.isEmpty){
                          return'please enter your Email';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.key),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                        labelText: 'Password',
                        fillColor: Colors.grey.shade200,
                        filled: true,
                      ),
                      controller: _loginpass,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot password?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),

                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                color: Colors.blue[400],
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            onPressed: (){
                              _login();
                            },
                          ),
                        ],
                      )
                  ),
                  const SizedBox(height: 40.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('not a member?'),
                      const SizedBox(width: 4),
                      GestureDetector(
                          onTap: widget.onTap,
                          child: const Text('Register now', style: TextStyle(fontWeight: FontWeight.bold),)
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}