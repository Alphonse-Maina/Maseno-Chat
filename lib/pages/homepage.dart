import 'package:flutter/material.dart';
import 'package:masenochat/components/customicon.dart';
import 'package:masenochat/pages/screens/allusers.dart';
import 'package:masenochat/pages/screens/groupchat.dart';
import 'package:masenochat/pages/screens/noticeboard.dart';
import 'package:masenochat/pages/screens/settingsscreen.dart';
import 'package:masenochat/pages/screens/updatesscreen.dart';
import 'package:masenochat/pages/screens/videosshow.dart';
import 'package:provider/provider.dart';
import 'package:masenochat/services/auth/auth_service.dart';
import 'package:masenochat/pages/screens/chatandhomescreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // sign user out
  void signout(){
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }
  void messagenew(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AllUsers()),
    );
  }
  void newpost(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdatesScreen()),
    );
  }
  void settings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
  }

  int _selectedIndex= 0;
  static final List<Widget>_widgetOptions =<Widget>[
    ChatsAndHomeScreen(),
    UpdatesScreen(),
    TwitterHomePage(),
    SettingsScreen(),


  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  Color navbackcolor = Colors.blueGrey;
  Color iconcolor = Colors.white70;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Maseno Chat App '),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 54, 200, 244),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              if(result == 'signout'){
                signout();
              }
              else if(result == 'messagenew'){
                messagenew(context);
              }
              else if(result == 'newpost'){
                newpost(context);
              }

              print('You clicked on: $result');
              // Perform action based on selection
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'messagenew',
                child: Text('Message New Person'),
              ),

              const PopupMenuItem<String>(
                value: 'signout',
                child: Text('Sign Out'),
              ),
            ],
          ),
        ],
      ),
      body: Center(

        child:_widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: iconcolor),
            label: 'Chats',
            backgroundColor: navbackcolor,
          ),
          BottomNavigationBarItem(
            icon: CustomIcon(),
            label: 'Updates',
            backgroundColor: navbackcolor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, color: iconcolor),
            label: 'Notifications',
            backgroundColor: navbackcolor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: iconcolor),
            label: 'Settings',
            backgroundColor: navbackcolor,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[600],
        onTap: _onItemTapped,
      ),
    );

  }
}
