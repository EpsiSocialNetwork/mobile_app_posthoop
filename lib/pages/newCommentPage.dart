import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mobile_app_posthoop/models/CommentArguments.dart';

// Mobile App packages
import 'package:mobile_app_posthoop/services/authenticateService.dart';

class NewCommentPage extends StatefulWidget {
  NewCommentPage({Key key}) : super(key: key);

  @override
  _NewCommentPage createState() => _NewCommentPage();
}

class _NewCommentPage extends State<NewCommentPage> {
  final textController = TextEditingController();

  void _sendPost(String uidPost) async {
    final response = await http.post(Uri.parse('https://post.mignon.chat/comment'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthenticateService.token}',
        },
        body: jsonEncode({
          'uidUser': AuthenticateService.uidUser,
          'uidPost': uidPost,
          'text': textController.text
        })
    );
    if(response.statusCode == 201){
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final CommentArgument argument = ModalRoute.of(context).settings.arguments as CommentArgument;

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
                    onPressed: textController.text.isNotEmpty ? null:  () => _sendPost(argument.uidPost),
                  ),
                ],
              ),
              Text("Respond to @${argument.postFullname}", style: TextStyle(fontSize: 22.0)),
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