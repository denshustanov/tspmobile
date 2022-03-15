import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tspmobile/http_client.dart';
import 'package:tspmobile/model/post.dart';
import 'package:tspmobile/ui/widgets/user_label.dart';

class PostWidget extends StatelessWidget {
  PostWidget(this.post, this.updateParent);

  Function updateParent;
  final Post post;
  final HttpClient httpClient = HttpClient();
  final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  userLabel(post.author, context),
                  PopupMenuButton(
                    itemBuilder: (context) {
                      return <PopupMenuEntry>[
                        if (post.author.username! == httpClient.username) ...[
                          PopupMenuItem(
                            child: const Text('Delete post'),
                            onTap: () {
                              Future<void>.delayed(
                                  const Duration(),
                                  () => showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: const Text('Are you sure?'),
                                            content: const Text(
                                                'This post will be lost forever!'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () async {
                                                    await httpClient
                                                        .deletePost(post.id!);
                                                    updateParent();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Ok')),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Cancel"))
                                            ],
                                          )));
                            },
                          )
                        ] else ...[
                          const PopupMenuItem(child: Text('complain')),
                        ]
                      ];
                    },
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.grey,
                    ),
                  ),
                  // IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert, color: Colors.grey,))
                ],
              )),
          Align(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: Text(post.text!),
            ),
            alignment: Alignment.centerLeft,
          ),
          if (post.attachments != null) ...[
            if (post.attachments!.isNotEmpty) ...[
              Image.network(httpClient.serverURL +
                  httpClient.getAttachmentEndpoint +
                  post.attachments!.first),
              DotsIndicator(
                dotsCount: post.attachments!.length,
                position: 0,
                decorator: const DotsDecorator(
                    size: Size.square(5.0), activeSize: Size.square(9.0)),
              ),
            ]
          ],
          Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.grey,
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
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 3.0),
            child: Text(
              formatter.format(post.publicationDate!),
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _deletePost(context) async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('This post will be lost forever!'),
              actions: [
                TextButton(
                    onPressed: () async {
                      await httpClient.deletePost(post.id!);
                      updateParent();
                    },
                    child: const Text('Ok')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"))
              ],
            ));
  }
}
