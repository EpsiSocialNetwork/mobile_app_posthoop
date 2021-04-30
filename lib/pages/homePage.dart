import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Mobile App packages
import 'package:mobile_app_posthoop/services/authenticateService.dart';
import 'package:mobile_app_posthoop/widget/personalUserInfo.dart';
import 'package:mobile_app_posthoop/widget/postList.dart';
import 'package:mobile_app_posthoop/widget/userInfo.dart';
import 'package:mobile_app_posthoop/models/user.dart';

String token = "Hello";

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  AuthenticateService auth = new AuthenticateService();
  User _user = new User();

  void _newPost() {
    Navigator.pushNamed(context, '/new_post');
  }

  void getUser() async {
    final response = await http.get(Uri.parse('https://user.mignon.chat/user/${AuthenticateService.uidUser}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthenticateService.token}',
        }
    );
    print("before");
    if(response.statusCode == 200){
      print("after");
      if(response.body.isEmpty){
        print("New user");
        print(AuthenticateService.username);
        final response = await http.post(Uri.parse('https://user.mignon.chat/user'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${AuthenticateService.token}',
            },
            body: jsonEncode({
              'uid': AuthenticateService.uidUser,
              'email': AuthenticateService.email,
              'password': '',
              'username': AuthenticateService.username,
              'fullname': AuthenticateService.fullname
            })
        );
        print(response.statusCode);
      }
    };
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> _widgetOptions = <Widget>[
      PostList(),
      Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                'Index 0: Hello',
                style: optionStyle,
              ),
              GestureDetector(
                  onTap: () {
                    auth.authenticate();
                  },
                  child: Text(
                      "Login"
                  )
              ),
              Text('$token',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                  onTap: () {
                    auth.logout();
                  },
                  child: Text(
                      "disconnect"
                  ),
              ),
            ],
          ),
        ),
      ),
      PersonalUserInfoWidget()
    ];

    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
          height: height,
          child: Stack(
              children: <Widget>[
                _widgetOptions.elementAt(_selectedIndex),
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newPost,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.find_in_page_outlined),
            label: 'Research',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromRGBO(255, 0, 61, 100),
        onTap: _onItemTapped,
      ),
    );
  }
}
