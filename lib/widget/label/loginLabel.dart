import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginLabel extends StatelessWidget {
  const LoginLabel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
        child: Column(children: <Widget>[
          SizedBox(height: height * 0.1),
          SvgPicture.asset('assets/gobelet-en-carton.svg',
              height: 200, semanticsLabel: 'PostHoop Logo'),
          SizedBox(height: height * 0.05),
          Text(
            'Nouveau Hooper ?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
            ),
          )
        ]));
  }
}
