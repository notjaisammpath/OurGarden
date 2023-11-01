// ignore_for_file: library_private_types_in_public_api
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ourgarden/main.dart';
import 'package:ourgarden/pages/HomePage.dart';
import 'package:provider/provider.dart';

import '../backend/back4appBackend.dart';

class CreateCommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create A Community'),
      ),
      body: CreateCommunityBody(),
    );
  }
}

class CreateCommunityBody extends StatefulWidget {
  @override
  _CreateCommunityBodyState createState() => _CreateCommunityBodyState();
}

class _CreateCommunityBodyState extends State<CreateCommunityBody> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  var _communityName = "";
  var _location = "";
  File? image;

  void clearPhoto() {
    setState(() {
      image = null;
    });
  }

  Future addPostPhoto(BuildContext context) async {
    try {
      final testImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (testImage == null) return;

      final imageTemp = File(testImage.path);

      setState(() => image = imageTemp);
    } on PlatformException catch (e) {
      print("failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Column(
    // children: <Widget>[
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          image == null
              ? IconButton(
                  onPressed: () => {addPostPhoto(context)},
                  icon: Icon(Icons.add_photo_alternate_rounded),
                  iconSize: 90,
                )
              : Stack(
                  children: [
                    Positioned(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Image.file(
                          image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 15,
                      top: 15,
                      child: IconButton(
                        icon: Icon(Icons.close),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.white)),
                        onPressed: () => clearPhoto(),
                      ),
                    ),
                  ],
                ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Community Name',
                  hintText: 'give your community a nice name'),
              onChanged: (value) => _communityName = value,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Location',
                  hintText: "describe where your community is"),
              onChanged: (value) => _location = value,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 40, right: 40),
            child: ElevatedButton(
              onPressed: () => {
                Back4AppBackend().createCommunity(
                  Provider.of<MyAppState>(context, listen: false).currentUser,
                  _communityName,
                  _location,
                  image,
                  context,
                ),
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomePage(),
                  ),
                )
              },
              child: Text(
                'Create Community',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
