import 'package:flutter/material.dart';
import 'package:mobile_app_posthoop/widget/button/mainButton.dart';
import 'package:mobile_app_posthoop/widget/label/welcomeLabel.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
          height: height,
          child: Stack(children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    WelcomeLabel(),
                    SizedBox(height: height * .15),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: MainButton(
                        text: 'Inscription',
                      ),
                    ),
                    SizedBox(height: height * .05),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: MainButton(
                        text: 'Connexion',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ])),
    );
  }
}
