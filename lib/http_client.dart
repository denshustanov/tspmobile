import 'dart:convert';

import 'package:http/http.dart';

class HttpClient{
  static final HttpClient _instance = HttpClient._();
  HttpClient._();
  factory HttpClient(){
    return _instance;
  }

  String _username='restuser';
  String _password='restuser';
  String? _accessToken;
  String? _refreshToken;

  final String serverURL = 'http://10.0.2.2:8080';

  final String authenticateEndpoint = '/oauth/token';
  final String registerUserEndpoint = '/user/register';
  final String getUserEndpoint = '/user/';

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





}