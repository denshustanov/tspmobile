import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart';

import 'model/user.dart';
import 'model/post.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._();

  HttpClient._();

  factory HttpClient() {
    return _instance;
  }

  // final String _registrationUsername = 'restuser';
  // final String _registrationPassword = 'restuser';

  String _username = 'restuser';
  String _password = 'restuser';
  String? _accessToken;
  String? _refreshToken;

  final String serverURL = 'http://192.168.1.13:8080';
  // final String serverURL = 'http://5.164.153.22:9090/tspserver-0.0.1-SNAPSHOT';

  final String findUsersEndpoint = '/user/find';
  final String findPostsEndpoint = '/post/find';
  final String authenticateEndpoint = '/oauth/token';
  final String registerUserEndpoint = '/user/register';
  final String getUserEndpoint = '/user/';
  final String createPostEndpoint = '/post';
  final String getAttachmentEndpoint = '/post/attachment/';

  Future<int> authorize(String username, String password) async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('client:secret'));
    Response res = await post(Uri.parse(serverURL + authenticateEndpoint),
        headers: <String, String>{
          'authorization': basicAuth,
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: 'grant_type=password&username=$username&password=$password');
    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(res.body);
      _accessToken = json['access_token'];
      _refreshToken = json['refresh_token'];
      _username = username;
      _password = password;
    }
    return res.statusCode;
  }

  Future<Response> registerUser(User user) async {
    await authorize('restuser', 'restuser');

    Response res = await post(Uri.parse(serverURL + registerUserEndpoint),
        headers: <String, String>{
          'authorization': 'Bearer ' + _accessToken!,
          'Content-type': 'application/json'
        },
        body: jsonEncode(user.toJson()));
    return res;
  }

  Future<bool> getUsernameAvailable(String username) async {
    if (_accessToken == null) {
      await authorize("restuser", "restuser");
    }
    Response res = await get(
        Uri.parse(serverURL + '/user/' + username + '/available'),
        headers: <String, String>{'authorization': 'Bearer ' + _accessToken!});
    return res.body == 'true';
  }

  Future<int> updateUserAvatar(List<int> avatar) async{
    Response res = await put(
        Uri.parse(serverURL + '/user/' + _username + '/avatar'),
        headers: <String, String>{'authorization': 'Bearer ' + _accessToken!},
        body: avatar
    );

    return res.statusCode;
  }

  Future<int> updateUserBio(String bio) async{
    Response res = await put(
        Uri.parse(serverURL + '/user/' + _username + '/bio'),
        headers: <String, String>{'authorization': 'Bearer ' + _accessToken!},
        body: bio
    );

    return res.statusCode;
  }

  Future<Uint8List> getUserAvatar(String username) async{
    Response res = await get(
      Uri.parse(serverURL + '/user/' + username + '/avatar'),
      headers: <String, String>{'authorization': 'Bearer ' + _accessToken!},
    );

    return res.bodyBytes;
  }

  String getAuthorizationHeader(){
    return 'Bearer ' + _accessToken!;
  }

  Future<List<Post>> loadPosts() async{
    Response res = await get(
      Uri.parse(serverURL + '/post/all'),
      headers: <String, String>{'authorization': 'Bearer ' + _accessToken!},
    );

    Iterable json = jsonDecode(res.body);

    return List<Post>.from(json.map((model) => Post.fromJson(model)));
  }
  
  Future<int> createPost(Post _post) async{
    Response res = await post(
      Uri.parse(serverURL + createPostEndpoint),
      headers: <String, String>{
        'authorization': 'Bearer ' + _accessToken!,
        'Content-type': 'application/json'
      },
      body: jsonEncode(_post.toJson())
    );
    
    return res.statusCode;
  }

  Future<User> getUser(String username) async{
    Response res = await get(
      Uri.parse(serverURL + '/user/'+username),
      headers: <String, String>{'authorization': 'Bearer ' + _accessToken!},
    );

    Map<String, dynamic> json = jsonDecode(res.body);

    return User.fromJson(json);
  }

  Future<List<Post>> loadUserPosts(String username) async{
    Response res = await get(
      Uri.parse(serverURL + '/user/'+username+'/posts'),
      headers: <String, String>{'authorization': 'Bearer ' + _accessToken!},
    );

    Iterable json = jsonDecode(res.body);

    return List<Post>.from(json.map((model) => Post.fromJson(model)));
  }
  
  Future deletePost(String id) async{
    await delete(
      Uri.parse(serverURL + '/post/' + id),
      headers: <String, String>{'authorization': 'Bearer ' + _accessToken!},
    );
  }
  
  Future subscribe(String username) async{
    String params = '?subscriber='+_username+'&subscription='+username;

    await post(
      Uri.parse(serverURL+ '/subscription'+ params),
        headers: <String, String>{'authorization': 'Bearer ' + _accessToken!},
    );
  }

  Future unsubscribe(String username) async{
    String params = '?subscriber='+_username+'&subscription='+username;

    await delete(
      Uri.parse(serverURL+ '/subscription'+ params),
      headers: <String, String>{'authorization': 'Bearer ' + _accessToken!},
    );
  }

  Future<bool> checkSubscription(String username) async{
    String params = '?subscriber='+_username+'&subscription='+username;

    Response  res = await get(
      Uri.parse(serverURL+ '/subscription'+ params),
      headers: <String, String>{'authorization': 'Bearer ' + _accessToken!},
    );

    return res.body == 'true';
  }

  Future<List<User>> getUserSubscribers(String username) async{
    Response  res = await get(
      Uri.parse(serverURL+ '/user/'+ username + '/subscribers'),
      headers: <String, String>{'authorization': 'Bearer ' + _accessToken!},
    );

    Iterable json = jsonDecode(res.body);

    return List<User>.from(json.map((model) => User.fromJson(model)));
  }

  Future<List<User>> getUserSubscriptions(String username) async{
    Response  res = await get(
      Uri.parse(serverURL+ '/user/'+ username + '/subscriptions'),
      headers: <String, String>{'authorization': 'Bearer ' + _accessToken!},
    );

    Iterable json = jsonDecode(res.body);

    return List<User>.from(json.map((model) => User.fromJson(model)));
  }

  Future<List<User>> findUsersByUsername(String username) async{
    Response  res = await get(
      Uri.parse(serverURL+ findUsersEndpoint +'?username='+username),
      headers: <String, String>{'authorization': 'Bearer ' + _accessToken!},
    );
    Iterable json = jsonDecode(res.body);

    return List<User>.from(json.map((model) => User.fromJson(model)));
  }

  Future<List<Post>> findPosts(String text) async{
    Response res = await get(
      Uri.parse(serverURL + findPostsEndpoint + '?text='+text),
      headers: <String, String>{'authorization': 'Bearer ' + _accessToken!},
    );

    Iterable json = jsonDecode(res.body);

    return List<Post>.from(json.map((model) => Post.fromJson(model)));
  }

  Future signOut() async{
    _accessToken = null;
    _refreshToken = null;
  }

  String get username => _username;
}
