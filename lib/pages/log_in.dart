import 'package:flutter/material.dart';
import 'package:msn_chat/services/auth.dart';
import 'package:provider/provider.dart';


class log_in extends StatefulWidget {
  final void Function()? onTap;
  const log_in({super.key, required this.onTap});

  @override
  State<log_in> createState() => _log_inState();
}

class _log_inState extends State<log_in> {

  String? reglogin = '';
  String? passlogin = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _loginReg = TextEditingController();
  final TextEditingController _loginpass = TextEditingController();
  dynamic loginReg;
  void  _login() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try{
      await authService.signInWithEmailAndPassword(_loginReg.text, _loginpass.text);
    }catch (e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString(),),),);
    }

    reglogin = _loginReg.text;
    passlogin = _loginpass.text;
    if(reglogin == 'rexalphonso@gmail.com' && passlogin == 'mainarex'){
      dynamic result = await Navigator.pushNamed(context, '/home');
    }
    else{
      dynamic result = await Navigator.pushNamed(context, '/log');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Maseno Login Chat App'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 54, 200, 244),
        actions: <Widget>[
          GestureDetector(
            onTap: widget.onTap,
            child: IconButton(
                onPressed: () async{
                  //dynamic result = await Navigator.pushNamed(context, '/register');
                },
                icon: Icon(Icons.person_add_alt_1)
            ),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,


        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 50.0,
            ),
            Center(
              child: CircleAvatar(
                backgroundImage: AssetImage('images/masenologo.png'),
                radius: 60.0,

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
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
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
                  SizedBox(
                    height: 30.0,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        labelText: 'Password',
                        fillColor: Colors.grey.shade200,
                        filled: true,
                      ),
                      controller: _loginpass,
                    ),
                  ),
                  SizedBox(
                    height: 10,
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
                  SizedBox(
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
                  SizedBox(height: 25.0),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('not a member?'),
                    const SizedBox(width: 4),
                    GestureDetector(
                        onTap: widget.onTap,
                        child: Text('Register now', style: TextStyle(fontWeight: FontWeight.bold),))],
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
