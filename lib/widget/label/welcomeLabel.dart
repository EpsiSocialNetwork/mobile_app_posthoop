import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeLabel extends StatelessWidget {
  const WelcomeLabel({Key key}) : super(key: key);

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
      SizedBox(height: height * 0.01),
      Text(
        'PostHoop',
        style: TextStyle(color: Color.fromRGBO(33, 9, 102, 100), fontSize: 30),
      ),
      SizedBox(height: height * 0.05),
      Text(
        'Modelez votre Hoop sphère à votre image.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 25,
        ),
      )
    ]));
  }
}
