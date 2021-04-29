import 'package:flutter/material.dart';

// Mobile App packages
import 'package:mobile_app_posthoop/models/post.dart';
import 'package:mobile_app_posthoop/widget/commentList.dart';
import 'package:mobile_app_posthoop/widget/post.dart';

class PostPage extends StatefulWidget {
  PostPage({Key key}) : super(key: key);

  @override
  _PostPage createState() => _PostPage();
}

class _PostPage extends State<PostPage> {

  @override
  Widget build(BuildContext context) {
    final Post post = ModalRoute.of(context).settings.arguments;

    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
          height: height,
          child: Column(
            children: <Widget>[
              SizedBox(height: height * .05),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextButton(
                    child: Icon(Icons.chevron_left),
                    onPressed: () {Navigator.pop(context);},
                  ),
                ],
              ),
              PostWidget(post: post),
              Text("Comments"),
              Container(
                child: CommentList(uidPost: post.uid),
              )
            ]
          )
        )
    );
  }
}