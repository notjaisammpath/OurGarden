// ignore_for_file: camel_case_types

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ourgarden/backend/user.dart';
import 'package:ourgarden/pages/AboutPage.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class otherUserPage extends StatefulWidget {
  final Future<List<ParseObject>> u;

  otherUserPage.fromUser(this.u);

  @override
  State<otherUserPage> createState() => _otherUserPageState();
}

// ignore: camel_case_types
class _otherUserPageState extends State<otherUserPage> {
  var hasPhoto = false;
  User? user;

  void initState() {
    getUser(widget.u);
    super.initState();
  }

  void getUser(Future<List<ParseObject>> k) async {
    List<ParseObject> list = await k;
    print("user foind awelfakjwefl");

    setState(() => user = User.fromParseObject(list[0]));
  }

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      User user = this.user!;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          leading: BackButton(),
          centerTitle: true,
          title: Text("${user.getDisplayName()}'s Profile"),
        ),
        body: Center(
          child: Column(
            children: [
              hasPhoto
                  ? Placeholder()
                  : IconButton(
                      iconSize: 90,
                      onPressed: () => addPhoto(context),
                      icon: Icon(Icons.person_rounded),
                    ),
              Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  textScaleFactor: 2,
                  user.getDisplayName(),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, bottom: 12),
                child: Text(
                  user.getEmail(),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  user.getPhoneNumber().toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Placeholder();
    }
  }

  void addPhoto(BuildContext context) {
    print('added Photo');
  }
}
