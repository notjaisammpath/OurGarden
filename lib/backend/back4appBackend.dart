import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ourgarden/backend/user.dart';
import 'package:ourgarden/pages/MyGardenPageWidgets/plantview.dart';

import 'dart:core';
import 'dart:io';

import 'package:ourgarden/backend/plant.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../pages/post.dart';

class Back4AppBackend {
  Future<void> initParse() async {
    const keyApplicationId = '6gSqmfmHMeJl1UCuwrDrG3AIakRWp9rMx57uvbBp';
    const keyClientKey = 'AqQPMbdgjFgkdmBqlduWGemnuGMEYFyitwpMWEOA';
    const keyParseServerUrl = 'https://parseapi.back4app.com';

    await Parse().initialize(
      keyApplicationId,
      keyParseServerUrl,
      clientKey: keyClientKey,
      autoSendSessionId: true,
      debug: true,
    );
  }

  void addAcceptanceToPost(User u, Post p) async {
    ParseObject user = (await getAccount(u))[0];
    ParseObject post;

    QueryBuilder<ParseObject> requestQuery = QueryBuilder<ParseObject>(
      ParseObject('Post'),
    )..whereRelatedTo('acceptedBy', 'Account', user.objectId!);
    final ParseResponse response = await requestQuery.query();
    if (response.success &&
        (response.results == null || response.results == [])) {
      print('no results for get posts');
      return;
    } else if (response.success && response.results != null) {
      post = (response.results as List<ParseObject>)[0];
    } else {
      print('response failed');
      return;
    }

    post.addRelation("acceptedBy", [user]);
    await post.save();
  }

  Future<List<ParseObject>> getRequests(User u) async {
    ParseObject user = (await getAccount(u))[0];
    QueryBuilder<ParseObject> requestQuery = QueryBuilder<ParseObject>(
      ParseObject('Post'),
    )..whereRelatedTo('acceptedBy', 'Account', user.objectId!);
    final ParseResponse response = await requestQuery.query();
    if (response.success &&
        (response.results == null || response.results == [])) {
      print('no results for get communities');
      return [];
    } else if (response.success && response.results != null) {
      return response.results as List<ParseObject>;
    } else {
      print('response failed');
      return [];
    }
  }

  Future<List<ParseObject>> getCommunitiesFromCode(String k) async {
    QueryBuilder<ParseObject> userQuery = QueryBuilder<ParseObject>(
      ParseObject('Community'),
    );
    // ..whereEqualTo('objectId', k);
    final ParseResponse response = await userQuery.query();
    if (response.success &&
        (response.results == null || response.results == [])) {
      print('no results for get communities');
      return [];
    } else if (response.success && response.results != null) {
      return response.results as List<ParseObject>;
    } else {
      print('response failed');
      return [];
    }
  }

  Future<List<ParseObject>> getCommunities(User user) async {
    QueryBuilder<ParseObject> userQuery = QueryBuilder<ParseObject>(
      ParseObject('Account'),
    )..whereRelatedTo('members', 'Account', user.objectId);
    final ParseResponse response = await userQuery.query();
    if (response.success &&
        (response.results == null || response.results == [])) {
      print('no results for get communities');
      return [];
    } else if (response.success && response.results != null) {
      return response.results as List<ParseObject>;
    } else {
      print('response failed');
      return [];
    }
  }

  Future<List<ParseObject>> getAccount(User user) async {
    print('getting account ${user.getDisplayName()}');
    QueryBuilder<ParseObject> userQuery = QueryBuilder<ParseObject>(
      ParseObject('Account'),
    )..whereContains('username', user.getDisplayName());
    final ParseResponse response = await userQuery.query();
    if (response.success &&
        (response.results == null || response.results == [])) {
      print('no results');
      return [];
    } else if (response.success && response.results != null) {
      return response.results as List<ParseObject>;
    } else {
      print('response failed');
      return [];
    }
  }

  Future<List<Post>> getPosts(User user) async {
    print(user.getDisplayName());
    print("THAT WAS THE USER");
    List<String> objectIds = user.getCommunities();
    List<ParseObject> posts = [];
    print("looping once");
    QueryBuilder<ParseObject> postQuery = QueryBuilder<ParseObject>(
      ParseObject('Post'),
    );
    // postQuery.whereNotEqualTo('authorAsString', user.getDisplayName());

    final ParseResponse postresponse = await postQuery.query();
    if (postresponse.success && postresponse.results != null) {
      print(postresponse.results!.length);
      posts.addAll(postresponse.results as List<ParseObject>);
    } else if (postresponse.results == null) {
      print("no posts found");
    }

    List<Post> results = [];
    for (ParseObject k in posts) {
      results.add(Post.fromParse(k));
    }
    return results;
  }

  Future<ParseObject> getAuthor(ParseObject p) async {
    var authorQuery = QueryBuilder<ParseObject>(ParseObject('Account'));
    authorQuery.whereRelatedTo('posts', "post", p.objectId!);
    final ParseResponse response = await authorQuery.query();
    if (response.success) {
      if (response.results != null) {
        return (response.results as List<ParseObject>)[0];
      } else {
        print('list of authors empty');
        return (response.results as List<ParseObject>)[0];
      }
    } else {
      print('response failed');
      return (response.results as List<ParseObject>)[0];
    }
  }

  Plant plantFromJson(String str) => Plant.fromJson(json.decode(str));

  String plantToJson(Plant data) => json.encode(data.toJson());

  Future<void> createPost(String caption, File? image, bool isPublic,
      double num, User author, String postType) async {
    var authorList = await getAccount(author);
    ParseObject tempAuthor = authorList[0];
    print(tempAuthor.objectId);
    List<ParseObject> communities = [];
    var communitiesQuery = QueryBuilder<ParseObject>(ParseObject('Community'));
    for (String id in author.getCommunities()) {
      communitiesQuery.whereEqualTo('objectId', id);
    }
    final ParseResponse response = await communitiesQuery.query();
    if (response.success) {
      if (response.results != null) {
        communities = response.results as List<ParseObject>;
      } else {
        print('list of communities empty');
      }
    } else {
      print('response failed');
    }
    var newPost = ParseObject('Post')
      ..set('caption', caption)
      ..set('dateTime', DateTime.now())
      ..set('postType', postType)
      ..set('numValue', num)
      ..set('isPublic', isPublic)
      ..set('authorAsString', author.getDisplayName())
      ..addRelation('author', authorList);
    if (image != null) {
      newPost.set('imageFile', ParseFile(File(image.path)));
    }
    if (communities.isNotEmpty) {
      newPost.addRelation('communities', communities);
    }
    await newPost.save();

    print("how far do we get");
    for (var com in communities) {
      print("loop started");
      com.addRelation('posts', [newPost]);
      com.save();
      print("com saved");
    }
    tempAuthor.addRelation('posts', [newPost]);
    await tempAuthor.save();
    print("tempauthor saved");
    print("post saved");
    print('post created with caption $caption');
  }

  Future<List<String>> getGardenCommonNames(User owner) async {
    var accountList = await getAccount(owner);
    return accountList[0].get("plants");
  }

  Future<void> addPlantToGarden(User owner, PlantView p) async {
    var accountList = await getAccount(owner);
    owner.gardenCommonNames.add(p.getName());
    ParseObject tempUser = accountList[0]
      ..set('plants', owner.gardenCommonNames);
    await tempUser.save();
  }

  Future<void> createCommunity(User creator, String name, String location,
      File? image, BuildContext context) async {
    var accountList = await getAccount(creator);
    ParseObject tempUser = accountList[0];
    var newCommunity = ParseObject('Community')
      ..set('communityName', name)
      ..set('location', location)
      ..addRelation('members', accountList);
    if (image != null) {
      newCommunity.set('imageFile', ParseFile(File(image.path)));
    }
    await newCommunity.save();
    creator.addCommunity(newCommunity.objectId!);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("New Community Created with ID ${newCommunity.objectId}")));
    }
    tempUser.addRelation('communities', [newCommunity]);
    await tempUser.save();

    print(
        'Community created with name: ${newCommunity.get<String>('communityName')}');
  }

  Future<void> createAccount(User newUser) async {
    var user = ParseObject('Account')
      ..set('username', newUser.getDisplayName())
      ..set('phoneNumber', newUser.getPhoneNumber())
      ..set('email', newUser.getEmail())
      ..set('password', newUser.getPassword())
      ..set('joinedCommunity', false);
    await user.save();
    print('user created with name: ${newUser.getDisplayName()}');
  }
}
