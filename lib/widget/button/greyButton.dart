import 'package:flutter/material.dart';

class GreyButton extends StatelessWidget {
  const GreyButton({Key key, this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Colors.grey.shade800),
      child: Text(
        this.text,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}
