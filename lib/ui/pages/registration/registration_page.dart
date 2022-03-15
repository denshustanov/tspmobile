import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tspmobile/http_client.dart';
import 'package:tspmobile/model/user.dart';
import 'package:tspmobile/ui/pages/login_page.dart';
import 'package:tspmobile/ui/pages/registration/user_info_page.dart';
import 'package:tspmobile/ui/widgets/loading_dialog.dart';

import '../newsline_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool obscurePassword = true;

  final HttpClient _httpClient = HttpClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: const [
                  Text(
                    'Welcome!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    'Fill in the fields to create an account',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
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
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Password',
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                              icon: Icon(obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility))),
                      validator: (value) {
                        if (value == null || value.length < 8) {
                          return 'Must be at least 8 symbols';
                        }
                        return null;
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        showLoaderDialog(context);
                        final bool usernameAvailable = await _httpClient
                            .getUsernameAvailable(usernameController.text);
                        Navigator.of(context).pop();
                        if (usernameAvailable) {
                          User user = User();
                          user.username = usernameController.text;
                          user.password = passwordController.text;
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserInfoPage(user),
                                  settings: RouteSettings(arguments: user)));
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                    content:
                                        Text('Username is already in use!'),
                                  ));
                        }
                      }
                    },
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          },
                          child: const Text('Sign in'))
                    ],
                  ),
                ],
              )
            ]),
      ),
    );
  }
}
