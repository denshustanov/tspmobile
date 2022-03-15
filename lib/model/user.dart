import 'dart:convert';

import 'package:flutter/foundation.dart';

class User{
  String? username;
  String? password;
  String? bio;
  List<int>? avatar;
  int subscribersCount = 0;
  int subscriptionsCount = 0;
  int postsCount = 0;

  User();

  factory User.fromJson(Map<String, dynamic> json){
    User user = User();
    user.username = json["username"];
    user.bio = json["bio"];
    // if(json["avatar"]!=null) {
    //   user.avatar = base64Decode(json["avatar"]);
    // }
    user.subscribersCount = json["subscribersCount"];
    user.subscriptionsCount = json["subscriptionsCount"];
    user.postsCount = json["postsCount"];
    return user;
  }

  Map<String, dynamic> toJson(){
    return {
      'username': username,
      'password': password,
      'bio': bio,
      'avatar': avatar
    };
  }
}