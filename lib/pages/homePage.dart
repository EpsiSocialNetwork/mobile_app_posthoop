import 'package:flutter/material.dart';

// Mobile App packages
import 'package:mobile_app_posthoop/services/authenticateService.dart';
import 'package:mobile_app_posthoop/widget/postList.dart';

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

  void _newPost() {
    Navigator.pushNamed(context, '/new_post');
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
