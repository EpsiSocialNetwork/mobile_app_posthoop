import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// Mobile App packages
import 'package:mobile_app_posthoop/services/authenticateService.dart';

class NewPostPage extends StatefulWidget {
  NewPostPage({Key key}) : super(key: key);

  @override
  _NewPostPage createState() => _NewPostPage();
}

class _NewPostPage extends State<NewPostPage> {
  final textController = TextEditingController();

  void _sendPost() async {
    print(textController.text);
    final response = await http.post(Uri.parse('https://post.mignon.chat/post'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${AuthenticateService.token}',
      },
      body: jsonEncode({
        'uidUser': AuthenticateService.uidUser,
        'text': textController.text
      })
    );
    if(response.statusCode == 201){
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
        height: height,
        child: Column(
          children: <Widget>[
            SizedBox(height: height * .05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  child: Icon(Icons.close),
                  onPressed: () {Navigator.pop(context);},
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: Icon(Icons.send),
                  onPressed: textController.text.isNotEmpty ? null: _sendPost,
                ),
              ],
            ),
            Text("Write your new Post", style: TextStyle(fontSize: 22.0)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: textController,
                keyboardType: TextInputType.multiline,
                minLines: 2,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: '',
                ),
              ),
            )
          ],
        ),
        )
    );
  }
}