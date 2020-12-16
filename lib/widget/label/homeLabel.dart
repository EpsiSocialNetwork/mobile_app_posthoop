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
      SvgPicture.asset('assets/gobelet-en-carton.svg',
          height: 200, semanticsLabel: 'PostHoop Logo'),
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
