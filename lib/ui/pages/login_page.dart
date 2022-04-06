import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tspmobile/authentication_service.dart';
import 'package:tspmobile/http_client.dart';
import 'package:tspmobile/ui/pages/home_page.dart';
import 'package:tspmobile/ui/pages/newsline_page.dart';
import 'package:tspmobile/ui/pages/registration/registration_page.dart';
import 'package:tspmobile/ui/widgets/loading_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final HttpClient _httpClient = HttpClient();
  final AuthenticationService _authenticationService = AuthenticationService();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Visibility(
                  visible: MediaQuery.of(context).viewInsets.bottom==0,
                  child: const Center(
                    child: Icon(
                      Icons.public,
                      size: 100,
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
                const Text('posts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                const Text('Brand new social network... maybe', style: TextStyle(color: Colors.grey),)
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      focusColor: Colors.greenAccent,
                      labelText: 'User Name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () => _signIn(),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('New User?'),
                    TextButton(onPressed: (){
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => RegistrationPage())
                      );
                    }, child: const Text('Create Account'))
                  ],
                ),
              ],
            )

          ]),
    );
  }

  Future _signIn() async{
    showLoaderDialog(context);
    int status = await _httpClient.authorize(usernameController.text, passwordController.text);
    Navigator.of(context).pop();
    if(status == 200){
      _authenticationService.saveCredentials(usernameController.text, passwordController.text);
      String? token = await FirebaseMessaging.instance.getToken();
      if(token!=null){
        _httpClient.createFcmToken(token);
      }
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
    } else{
      showDialog(context: context, builder: (context) => const AlertDialog(
        content: Text('error'),
      ));
    }
  }
}
