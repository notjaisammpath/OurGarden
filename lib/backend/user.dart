import 'package:flutter/material.dart';
import 'package:ourgarden/backend/plant.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class User {
  List<Plant> garden = [];
  List<String> gardenCommonNames = [];
  var _displayName = "Jai Sammpath";
  var _password = "";
  List<String> communities = [];
  var hasProfilePicture = false;
  var _phoneNumber = 9726520684;
  var _email = "jai.sammpath@gmail.com";
  var objectId = "";
  List<Widget> _posts = [];

  User();

  User.justDisplayName(String disp) {
    _displayName = disp;
  }

  User.fromParseObject(ParseObject p) {
    _displayName = p.get("username");
    _phoneNumber = p.get("phoneNumber");
    objectId = p.objectId!;
    _email = p.get("email");
  }

  List<String> getGardenCommonNames() {
    return gardenCommonNames;
  }

  String setPassword(String password) {
    return _password = password;
  }

  List<String> getCommunities() {
    return communities;
  }

  String getPassword() {
    return _password;
  }

  String addCommunity(String id) {
    communities.add(id);
    return id;
  }

  List<Widget> getPosts() {
    return _posts;
  }

  int setPhoneNumber(int phoneNumber) {
    return _phoneNumber = phoneNumber;
  }

  int getPhoneNumber() {
    return _phoneNumber;
  }

  String setEmail(String email) {
    return _email = email;
  }

  String getEmail() {
    return _email;
  }

  String getDisplayName() {
    return _displayName;
  }

  String setDisplayName(String newName) {
    _displayName = newName;
    return _displayName;
  }
}
