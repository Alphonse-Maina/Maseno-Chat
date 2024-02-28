import 'package:flutter/material.dart';



class register extends StatefulWidget  {
  final void Function()? onTap;
  const register({super.key, required this.onTap});

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register>{


  String email = '';
  String pass = '';
  String error = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _loginReg = TextEditingController();
  final TextEditingController _loginpass = TextEditingController();
  final TextEditingController _loginpass1 = TextEditingController();
  dynamic loginReg;

  void  _register(){

    email = _loginReg.text;
    pass = _loginpass.text;

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

                },
                icon: Icon(Icons.key)
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
                        labelText: 'Enter Email',
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
                        labelText: 'Confirm Password',
                        fillColor: Colors.grey.shade200,
                        filled: true,
                      ),
                      controller: _loginpass1,
                    ),
                  ),
                  SizedBox(
                    height: 10,
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
                              'Regiser',
                              style: TextStyle(
                                color: Colors.blue[400],
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            onPressed: (){
                              _register();
                             },
                          ),
                        ],
                      )
                  ),
                  SizedBox(
                    height: 12,
                  ),

                  SizedBox(height: 25.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('Already a member?'),
                      const SizedBox(width: 4),
                      GestureDetector(
                          onTap: widget.onTap,
                          child: Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold),))],
                  ),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
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
