import 'package:flutter/material.dart';
import 'package:tspmobile/authentication_service.dart';
import 'package:tspmobile/http_client.dart';
import 'package:tspmobile/ui/pages/home_page.dart';
import 'package:tspmobile/ui/pages/login_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var loggedIn = false;
  final HttpClient _httpClient = HttpClient();
  final AuthenticationService _authenticationService = AuthenticationService();
  Map<String, String>? credentials = await _authenticationService.readCredentials();
  print(credentials);
  if(credentials!=null){
    int status = await _httpClient.authorize(credentials["username"]!, credentials["password"]!);
    if(status == 200){
      loggedIn = true;
    }else{
      await _authenticationService.deleteCredentials();
    }
  }
  runApp(MyApp(loggedIn));
}

class MyApp extends StatelessWidget {
  const MyApp(this.loggedIn, {Key? key}) : super(key: key);
  final bool loggedIn;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: loggedIn? const HomePage(): const LoginPage(),
    );
  }
}
