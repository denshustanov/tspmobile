import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tspmobile/http_client.dart';
import 'package:tspmobile/model/post.dart';
import 'package:tspmobile/model/user.dart';
import 'package:tspmobile/ui/widgets/loading_dialog.dart';
import 'package:tspmobile/ui/widgets/pick_image.dart';
import 'dart:io';

class NewPostPage extends StatefulWidget {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  TextEditingController _postTextController = new TextEditingController();
  final HttpClient _httpClient = HttpClient();

  List<File> images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const Border(bottom: BorderSide(color: Colors.grey, width: 1)),
        title: const Text('New post'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () => savePost(),
              icon: const Icon(Icons.done, color: Colors.grey))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Scrollbar(
                child: TextField(
                  autofocus: true,
                  controller: _postTextController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  cursorColor: Colors.grey,
                  cursorWidth: 1,
                  cursorHeight: 15,
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: 'Post text'),
                ),
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          width: 100,
                          height: 100,
                          // alignment: Alignment.centerLeft,
                          child: Image.file(images.elementAt(index), fit: BoxFit.cover,)
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                              onPressed: (){
                                setState(() {
                                  images.removeAt(index);
                                });
                              },
                              icon: const Icon(Icons.clear, color: Colors.grey,)
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      if(images.length<10) {
                        addImages();
                      }
                    },
                    icon: const Icon(
                      Icons.image_outlined,
                      color: Colors.grey,
                      size: 30,
                    )),
                Text(images.length.toString() + '/10', style: const TextStyle(color: Colors.grey),)
              ],
            )
          ],
        ),
      ),
    );
  }

  Future savePost() async {
    if(_postTextController.text.isNotEmpty || images.isNotEmpty) {
      List<String> encodedImages = [];
      showLoaderDialog(context);
      for (File image in images) {
        encodedImages.add(base64Encode(await image.readAsBytes()));
      }

      Post post =
      Post(_postTextController.text, User(), encodedImages,[], [],
          DateTime.now());

      await _httpClient.createPost(post);
    }
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  Future<void> addImages() async {
    List<XFile>? imageFiles = await pickMultipleImages();
    if (imageFiles != null) {
      for (XFile file in imageFiles) {
        if(images.length>=10){
          break;
        }
        images.add(File(file.path));
      }
      setState(() {});
    }
  }
}
