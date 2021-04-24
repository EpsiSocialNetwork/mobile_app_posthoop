import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// Mobile App packages

final _storage = FlutterSecureStorage();
String token = "Hello";

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;

  var posts = [
  {
  "uid": "24c3b9e2-6891-47b3-b755-2bba617b4c90",
  "text": "Hey, ça va ?",
  "uidUser": "8aac7604-bc02-4102-a4a8-7a9e3e50fe9b",
  "urlImage": null,
  "createdAt": "2021-04-07T09:21:15.626Z",
  "updatedAt": null
}
];

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

    void authenticate(Uri uri, String clientId) async {

      var uri = Uri.parse('https://keycloak.mignon.chat/auth/realms/posthoop/api');
      var clientId = 'api';
      var scopes = List<String>.of(['openid', 'profile']);
      var port = 4200;
      var redirectUri = Uri.parse('https://keycloak.mignon.chat/auth/realms/posthoop/api/login-back');

      var issuer = await Issuer.discover(uri);
      var client = new Client(issuer, clientId);

      urlLauncher(String url) async {
        if (await canLaunch(url)) {
          await launch(url, forceWebView: true);
        } else {
          throw 'Could not launch $url';
        }
      }

      var authenticator = new Authenticator(client,
          scopes: scopes,
          port: port,
          urlLancher: urlLauncher,
          redirectUri: redirectUri);

      var c = await authenticator.authorize();
      print(c.response);
      closeWebView();

      var mytoken= await c.getTokenResponse();

      _changeTitle(mytoken.accessToken);

      print(mytoken);
      await _storage.write(key: 'jwt', value: mytoken.toString());
    }

    void _callUser() async {
      final response = await http.get(Uri.parse('https://post.mignon.chat/post'),
          headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }
      );
      print('Token : $token');
      print(response.body);

      this.setState(() {
        posts = jsonDecode(response.body);
      });
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
                    authenticate(Uri.parse("https://keycloak.mignon.chat/auth"), "api");
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
      Text(
        'Index 2: School',
        style: optionStyle,
      ),
    ];

    final height = MediaQuery.of(context).size.height;


    return Scaffold(
      body: Container(
          height: height,
          child: Stack(children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .05),
                    _widgetOptions.elementAt(_selectedIndex),
                  ],
                ),
              ),
            ),
          ])),
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
