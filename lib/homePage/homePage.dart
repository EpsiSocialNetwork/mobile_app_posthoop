import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// Mobile App packages
import 'package:mobile_app_posthoop/services/authenticateService.dart';

String token = "Hello";

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;
  var posts;

  void _changeTitle(String newTitle) {
    setState(() {
      token = newTitle;
    });
  }
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    AuthenticateService auth = new AuthenticateService();
    bool _isAuth = false;
    var _token = "";

    void _callUser() async {
      print("Token Equals ?");
      print(_token == AuthenticateService.token);
      final response = await http.get(Uri.parse('https://post.mignon.chat/post'),
          headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthenticateService.token}',
        }
      );
      print(response.body);
      if(response.statusCode == 200){
        this.setState(() {
          posts = jsonDecode(response.body);
        });
      }

    }

    List<Widget> _widgetOptions = <Widget>[
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
                    _callUser();
                  },
                  child: Text(
                      "Call User"
                  ),
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
      ListView.builder(
        shrinkWrap: true,
        itemCount: posts == null ? 0 : posts.length,
        itemBuilder: (BuildContext context, int index){
          return new Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.album),
                    title: Text("Jules Peguet"),
                    subtitle: Text(posts[index]["text"], style: TextStyle(fontSize: 20)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        child: Icon(Icons.message),
                        onPressed: () {/* ... */},
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        child: Icon(Icons.favorite_border),
                        onPressed: () {/* ... */},
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        child: Icon(Icons.share),
                        onPressed: () {/* ... */},
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            );
        },
      ),
      ListView.builder(
        itemBuilder: (context, position) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(position.toString(), style: TextStyle(fontSize: 22.0),),
            ),
          );
        },
      ),
    ];

    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
          height: height,
          child: Stack(
              children: <Widget>[
                _widgetOptions.elementAt(_selectedIndex)
          ]
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.find_in_page_outlined),
            label: 'Recherche',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromRGBO(255, 0, 61, 100),
        onTap: _onItemTapped,
      ),

    );
  }
}
