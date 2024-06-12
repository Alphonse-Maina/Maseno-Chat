import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import '../services/auth/auth_service.dart';
import 'package:permission_handler/permission_handler.dart';

class register extends StatefulWidget {
  final void Function()? onTap;
  const register({super.key, required this.onTap});

  @override
  State<register> createState() => _registerState();
}
class _registerState extends State<register> {
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

  String email = '';
  String pass = '';
  String error = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _loginReg = TextEditingController();
  final TextEditingController _loginpass = TextEditingController();
  final TextEditingController _loginpass1 = TextEditingController();
  final TextEditingController _loginuname = TextEditingController();
  dynamic loginReg;

  void  _register() async {

    if (_loginpass.text != _loginpass1.text){
      QuickAlert.show(context: context,
          type: QuickAlertType.warning,
          text: "Passwords don't match",
      );
      _loginpass.clear();
      _loginReg.clear();
      _loginpass1.clear();
      _loginuname.clear();
      return;
    }else {
      final authService = Provider.of<AuthService>(context, listen: false);
      try {
        await authService.signUpWithEmailAndPassword(
            _loginReg.text, _loginpass.text, file, _loginuname.text);
      } catch (e) {
        print(e.toString());
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),),);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Maseno Chat App'),
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
             Center(
              child: Stack(
                children: [
                  img != null ? CircleAvatar(
                    backgroundImage: MemoryImage(img!),
                    backgroundColor: Colors.black12,
                    radius: 100.0,
                  ):
                  const CircleAvatar(
                    backgroundImage: AssetImage('images/defaultdp.jpg'),
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
            const SizedBox(
              height: 20.0,
            ),
            const Center(
              child: Text(
                  "Let's create you an account",
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
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        labelText: 'Enter User Name',
                        fillColor: Colors.grey.shade200,
                        filled: true,
                      ),
                      controller: _loginuname,
                      validator: (String? value){
                        if(value == null || value.isEmpty){
                          return'please enter a Use Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
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
                  const SizedBox(
                    height: 50.0,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.key),
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
                    height: 50.0,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.key),
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
                    height: 20,
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
                              'Register',
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
                          child: Text('Sign in', style: TextStyle(fontWeight: FontWeight.bold),))],
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

