// ignore_for_file: file_names

import 'dart:io';
import 'package:ourgarden/backend/back4appBackend.dart';
import 'package:ourgarden/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'HomePage.dart';

class PostPage extends StatefulWidget {
  @override
  State<PostPage> createState() => _PostPage();
}

enum PostType { offer, request, post }

class _PostPage extends State<PostPage> {
  var sliderValue = 0.0;

  PostType postType = PostType.request;
  File? image;

  final _captionController = TextEditingController();
  bool _visibilityState = false;

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

  bool validatePost() {
    if (_captionController.text.isNotEmpty) {
      Back4AppBackend().createPost(
          _captionController.text,
          image,
          _visibilityState,
          sliderValue,
          Provider.of<MyAppState>(context, listen: false).currentUser,
          postType.toString());
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    int postTypeInt;
    switch (postType) {
      case PostType.request:
        postTypeInt = 0;
        break;
      case PostType.offer:
        postTypeInt = 1;
        break;
      case PostType.post:
        postTypeInt = 2;
        break;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Create a Post'),
        leading: BackButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: ToggleSwitch(
                minWidth: 200,
                animate: false,
                initialLabelIndex: postTypeInt,
                totalSwitches: 3,
                labels: ['Request', 'Offer', 'Post'],
                onToggle: (index) => {
                      if (index == 0)
                        setState(
                          () => {postType = PostType.request, postTypeInt = 0},
                        )
                      else if (index == 1)
                        {
                          setState(
                            () => {postType = PostType.offer, postTypeInt = 1},
                          )
                        }
                      else
                        {
                          setState(
                            () => {postType = PostType.post, postTypeInt = 2},
                          )
                        }
                    }),
          ),
          postType == PostType.post
              ? Expanded(
                  child: Center(
                    child: image == null
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
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.white)),
                                  onPressed: () => clearPhoto(),
                                ),
                              ),
                            ],
                          ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    image != null
                        ? Stack(
                            children: [
                              Positioned(
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width -
                                                200,
                                        maxHeight:
                                            MediaQuery.of(context).size.height /
                                                3),
                                    child: SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      child: Image.file(
                                        image!,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 15,
                                top: 15,
                                child: IconButton(
                                  icon: Icon(Icons.close),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.white)),
                                  onPressed: () => clearPhoto(),
                                ),
                              ),
                            ],
                          )
                        : IconButton(
                            onPressed: () => {addPostPhoto(context)},
                            icon: Icon(Icons.add_photo_alternate_rounded),
                            iconSize: 90,
                          ),
                    Column(
                      children: [
                        postType == PostType.request
                            ? Text('How many are \nyou requesting?')
                            : Text("How many are \nyou offering?"),
                        Slider(
                          value: sliderValue,
                          max: 20,
                          divisions: 20,
                          label: sliderValue.round().toString(),
                          onChanged: (value) => {
                            setState(() => sliderValue = value),
                          },
                        ),
                      ],
                    )
                  ],
                ),
          Padding(
            padding: EdgeInsets.all(10),
            child: ToggleSwitch(
              minWidth: 200,
              animate: false,
              initialLabelIndex: 0,
              totalSwitches: 2,
              labels: ['Community Only', 'Public'],
              onToggle: (index) => index == 0
                  ? _visibilityState = true
                  : _visibilityState = false,
            ),
          ),
          postType == PostType.request
              ? Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _captionController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Add a plant name",
                      hintText: "What plant are you requesting?",
                    ),
                  ),
                )
              : postType == PostType.offer
                  ? Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        controller: _captionController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Add a plant name",
                          hintText: "What plant are you requesting?",
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        controller: _captionController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Caption",
                          hintText: "add a caption to your post",
                        ),
                      ),
                    ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 20),
            child: ElevatedButton(
              onPressed: () => {
                if (validatePost())
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    ),
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Post Created'),
                      ),
                    )
                  }
                else
                  {}
              },
              child: Text('Done'),
            ),
          ),
        ],
      ),
    );
  }
}
