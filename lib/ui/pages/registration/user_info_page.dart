import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tspmobile/http_client.dart';
import 'package:tspmobile/model/user.dart';
import 'package:tspmobile/ui/pages/home_page.dart';
import 'package:tspmobile/ui/pages/newsline_page.dart';
import 'dart:io';

import 'package:tspmobile/ui/widgets/loading_dialog.dart';
import 'package:tspmobile/ui/widgets/pick_image.dart';

class UserInfoPage extends StatefulWidget {
  UserInfoPage(this.user);

  final User user;

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final HttpClient _httpClient = HttpClient();
  final TextEditingController bioController = TextEditingController();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Add some info about you and account image'),
          ),
          if (_image != null) ...[
            GestureDetector(
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 55,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: FileImage(_image!),
                ),
              ),
              onTap: () => pickImage(),
            )
          ] else ...[
            IconButton(
                onPressed: () => pickImage(),
                iconSize: 110,
                icon: const Icon(
                  Icons.account_circle,
                  color: Colors.blue,
                ))
          ],
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: bioController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusColor: Colors.greenAccent,
                    labelText: 'Bio',
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () => signUp(),
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  )),
              TextButton(onPressed: () {}, child: const Text('Skip'))
            ],
          )
        ],
      ),
    );
  }

  Future signUp() async {
    User user = widget.user;
    showLoaderDialog(context);
    Response res = await _httpClient.registerUser(user);
    await _httpClient.authorize(user.username!, user.password!);

    if(res.statusCode == 200) {
      if(_image!=null) {
        int status = await _httpClient.updateUserAvatar(await _image!.readAsBytes());
      }
      if(bioController.text.isNotEmpty){
        await _httpClient.updateUserBio(bioController.text);
      }
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage())
      );
    } else{
      showDialog(
          context: context,
          builder: (context) => AlertDialog(content: Text(res.body),));
    }
  }

  Future pickImage() async {
    final XFile? image = await pickSingleImage(context);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }
}
