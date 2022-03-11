import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:tspmobile/model/post.dart';

Card post(Post post) {
  return Card(
    child: Column(
      children: [
        ListTile(
          leading: const Icon(Icons.account_circle),
          title: Text(
            post.author.username!,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Align(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(post.text!),
          ),
          alignment: Alignment.centerLeft,
        ),
        Image.asset('assets/images/food.jpg'),
        DotsIndicator(
          dotsCount: 5,
          position: 0,
          decorator: const DotsDecorator(
              size: Size.square(5.0), activeSize: Size.square(9.0)),
        ),
        Row(
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.redAccent,
                )),
            Text(
              post.likesCount.toString(),
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.mode_comment,
                  color: Colors.grey,
                )),
            Text(
              post.commentsCount.toString(),
              style: TextStyle(color: Colors.grey[700]),
            )
          ],
        )
      ],
    ),
  );
}
