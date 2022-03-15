import 'package:flutter/material.dart';
import 'package:tspmobile/http_client.dart';
import 'package:tspmobile/model/post.dart';
import 'package:tspmobile/model/user.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  TextEditingController _postTextController = new TextEditingController();
  final HttpClient _httpClient = HttpClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1
          )
        ),
        title: const Text('New post'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(onPressed: ()=>savePost(), icon: const Icon(Icons.done, color: Colors.grey))
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
                    border: InputBorder.none,
                    hintText: 'Post text'
                  ),
                ),
              ),
            ),
            IconButton(onPressed: (){}, icon: const Icon(Icons.image_outlined, color: Colors.grey, size: 30,))
          ],
        ),
      ),
    );
  }

  Future savePost() async{
    Post post = Post(
      _postTextController.text,
      User(),
      [],
      0,
      0,
      DateTime.now()
    );

    await _httpClient.createPost(post);

    Navigator.of(context).pop();
  }
}
