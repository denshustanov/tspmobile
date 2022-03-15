import 'package:flutter/material.dart';
import 'package:tspmobile/ui/pages/post/new_post_page.dart';

Widget newPostButton(context){
  return Card(
    color: Colors.grey[200],
    child: ListTile(
      leading: const Icon(
        Icons.edit_outlined,
        color: Colors.blueAccent,
      ),
      title: const Text(
        'Create post',
        style: TextStyle(color: Colors.blueAccent),
      ),
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NewPostPage())
        );
      },
    ),
  );
}