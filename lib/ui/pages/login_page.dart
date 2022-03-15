import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
        body:Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: const [
                Center(
                  child: Icon(
                    Icons.public,
                    size: 100,
                    color: Colors.lightBlue,
                  ),
                ),
                Text('posts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                Text('Brand new social network... maybe', style: TextStyle(color: Colors.grey),)
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
                    onPressed: () => _signIn(context),
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

  Future _signIn(context) async{
    showLoaderDialog(context);
    int status = await _httpClient.authorize(usernameController.text, passwordController.text);
    Navigator.of(context).pop();
    if(status == 200){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
    } else{
      showDialog(context: context, builder: (context) => const AlertDialog(
        content: Text('error'),
      ));
    }
  }
}
