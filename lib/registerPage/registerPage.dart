import 'package:flutter/material.dart';
import 'package:mobile_app_posthoop/widget/button/greyButton.dart';
import 'package:mobile_app_posthoop/widget/button/mainButton.dart';
import 'package:mobile_app_posthoop/widget/label/registerLabel.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                    RegisterLabel(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: MainButton(text: 'Se connecter'),
                    ),
                    SizedBox(height: height * .05),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Identifiant',
                          filled: true,
                          fillColor: Colors.grey.shade300),
                    ),
                    SizedBox(height: height * .02),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Email',
                          filled: true,
                          fillColor: Colors.grey.shade300),
                    ),
                    SizedBox(height: height * .02),
                    TextFormField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          filled: true,
                          fillColor: Colors.grey.shade300),
                    ),
                    SizedBox(height: height * .02),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/');
                      },
                      child: GreyButton(
                        text: 'S\'inscrire',
                      ),
                    )
                  ],
                ),
              ),
            ),
          ])),
    );
  }
}
