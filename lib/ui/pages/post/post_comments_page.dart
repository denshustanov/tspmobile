import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tspmobile/http_client.dart';
import 'package:tspmobile/model/post.dart';
import 'package:tspmobile/model/post_comment.dart';
import 'package:tspmobile/ui/widgets/loading_dialog.dart';
import 'package:tspmobile/ui/widgets/post.dart';
import 'package:tspmobile/ui/widgets/user_label.dart';

class PostCommentsPage extends StatefulWidget {
  PostCommentsPage(this.post, {Key? key}) : super(key: key);
  Post post;

  @override
  _PostCommentsPageState createState() => _PostCommentsPageState();
}

class _PostCommentsPageState extends State<PostCommentsPage> {
  late final Post _post = widget.post;

  final HttpClient _httpClient = HttpClient();
  final TextEditingController _commentController = TextEditingController();
  final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
  FocusNode commentTextFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              // physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  PostWidget(_post, null, true),
                  for (PostComment comment in _post.comments) ...[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 8.0, bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              userLabel(comment.author!, context),
                              PopupMenuButton(itemBuilder: (context) {
                                return <PopupMenuEntry>[
                                  if (_post.author.username! ==
                                          _httpClient.username ||
                                      comment.author!.username ==
                                          _httpClient.username) ...[
                                    PopupMenuItem(
                                      child: const Text('Delete'),
                                      onTap: () async {
                                        await _deleteComment(comment);
                                      },
                                    )
                                  ]
                                ];
                              })
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 30.0, bottom: 8.0),
                            child: Text(comment.text),
                          ),
                          Text(
                            formatter.format(comment.publicationDate),
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey),
                          )
                        ],
                      ),
                    )
                  ]
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: TextField(
                focusNode: commentTextFocus,
                controller: _commentController,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Comment',
                    suffixIcon: IconButton(
                        onPressed: () {
                          _createComment();
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.grey,
                        ))),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future _createComment() async {
    PostComment comment = PostComment(
        _commentController.text, _post.id!, null, DateTime.now(), '');
    _commentController.text = '';
    commentTextFocus.unfocus();
    comment = await _httpClient.createPostComment(comment);
    setState(() {
      _post.comments.add(comment);
    });
  }

  Future _deleteComment(PostComment comment) async {
    showLoaderDialog(context);
    final int status = await _httpClient.deleteComment(comment);
    Navigator.of(context).pop();
    if (status == 200) {
      setState(() {
        _post.comments.remove(comment);
      });
    }
  }
}
