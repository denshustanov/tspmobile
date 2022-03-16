import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthenticationService{
  static final AuthenticationService _instance = AuthenticationService._();
  final storage = FlutterSecureStorage();


  AuthenticationService._();

  factory AuthenticationService(){
    return _instance;
  }

  Future<Map<String, String>?> readCredentials() async{
    Map<String, String> allValues = await storage.readAll();
    if(allValues.containsKey("username") && allValues.containsKey("password")){
      return {
        "username": allValues["username"]!,
        "password": allValues["password"]!
      };
    }
    return null;
  }

  Future saveCredentials(String username, String password) async{
    await storage.write(key: "username", value: username);
    await storage.write(key: "password", value: password);
  }

  Future deleteCredentials() async{
    await storage.delete(key: "username");
    await storage.delete(key: "password");
  }



}