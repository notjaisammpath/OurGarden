import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ourgarden/backend/back4appBackend.dart';
import 'package:ourgarden/backend/user.dart';
import 'package:ourgarden/main.dart';
import 'package:ourgarden/pages/NewPostPage.dart';
import 'package:ourgarden/pages/otherUserPage.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Post extends StatelessWidget {
  PostType type = PostType.post;
  String caption = "NO_CAPTION_PROVIDED";
  DateTime? dateTime;
  String author = "NO_AUTHOR_PROVIDED";
  String? imageUrl;
  int? numRequested;

  Post();

  Post.fromParse(ParseObject post) {
    switch (post.get('postType')) {
      case "PostType.request":
        type = PostType.request;
        break;
      case "PostType.offer":
        type = PostType.offer;
        break;
      case "PostType.post":
        type = PostType.post;
        break;
      default:
        type = PostType.post;
        print('no post type found');
        break;
    }
    caption = post.get("caption");
    numRequested = post.get('numValue');
    dateTime = DateTime.parse(post.get("dateTime").toString().split(" ")[0]);
    author = post.get("authorAsString").toString();
    ParseFileBase? varFile = post.get<ParseFileBase>('imageFile');
    imageUrl = varFile?.url;
    // ParseObject auth = Back4AppBackend().getAuthor(post);
    // author = auth.get("username");
  }

  @override
  Widget build(BuildContext context) {
    if (type == PostType.post) {
      return Card(
        color: MainApp.materialApp.theme!.cardColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: imageUrl != null
                    ? Image.network(imageUrl!)
                    : Padding(padding: EdgeInsets.all(0)),
              ),
              TextButton(
                child: Text(author),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => otherUserPage.fromUser(
                        Back4AppBackend().getAccount(
                          User.justDisplayName(author),
                        ),
                      ),
                    ),
                  ),
                },
              ),
              Text(caption),
              Text(dateTime.toString().split(" ")[0]),
            ],
          ),
        ),
      );
    } else if (type == PostType.offer) {
      return Card(
        color: MainApp.materialApp.theme!.cardColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: imageUrl != null
                    ? Image.network(imageUrl!)
                    : Padding(padding: EdgeInsets.all(0)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: Text(author),
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => otherUserPage.fromUser(
                            Back4AppBackend().getAccount(
                              User.justDisplayName(author),
                            ),
                          ),
                        ),
                      ),
                    },
                  ),
                  Text("is offering $numRequested")
                ],
              ),
              Text(caption),
              Text(dateTime.toString().split(" ")[0]),
            ],
          ),
        ),
      );
    } else {
      return Card(
        color: MainApp.materialApp.theme!.cardColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: imageUrl != null
                    ? Image.network(imageUrl!)
                    : Padding(padding: EdgeInsets.all(0)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: Text(author),
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => otherUserPage.fromUser(
                            Back4AppBackend().getAccount(
                              User.justDisplayName(author),
                            ),
                          ),
                        ),
                      ),
                    },
                  ),
                  Text("is requesting $numRequested")
                ],
              ),
              Text(caption),
              TextButton(
                onPressed: () => {
                  Back4AppBackend().addAcceptanceToPost(
                      Provider.of<MyAppState>(context, listen: false)
                          .currentUser,
                      this)
                },
                child: Text("Fulfill this request"),
              ),
              Text(dateTime.toString().split(" ")[0]),
            ],
          ),
        ),
      );
    }
  }
}
