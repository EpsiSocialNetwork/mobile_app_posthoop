import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterLabel extends StatelessWidget {
  const RegisterLabel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
        child: Column(children: <Widget>[
          SizedBox(height: height * 0.1),
          SvgPicture.asset('assets/logo.svg',
              color: Color.fromRGBO(33, 9, 102, 100),
              height: 200,
              semanticsLabel: 'PostHoop Logo'),
          SizedBox(height: height * 0.05),
          Text(
            'Déjà Hooper ?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
            ),
          )
        ]));
  }
}
