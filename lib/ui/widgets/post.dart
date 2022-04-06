import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tspmobile/http_client.dart';
import 'package:tspmobile/model/post.dart';
import 'package:tspmobile/ui/pages/post/post_comments_page.dart';
import 'package:tspmobile/ui/widgets/user_label.dart';

class PostWidget extends StatefulWidget {
  PostWidget(this.post, this.updateParent, this.detailed, {Key? key})
      : super(key: key);

  Function? updateParent;
  final Post post;
  final bool detailed;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final HttpClient httpClient = HttpClient();
  final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
  late PageController _pageController;

  int currentImage = 0;

  late final _post = widget.post;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
  }

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
                  userLabel(_post.author, context),
                  PopupMenuButton(
                    itemBuilder: (context) {
                      return <PopupMenuEntry>[
                        if (_post.author.username! == httpClient.username) ...[
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
                                                        .deletePost(_post.id!);
                                                    if (widget.updateParent !=
                                                        null) {
                                                      widget.updateParent!();
                                                    }
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
                          PopupMenuItem(
                            child: const Text('complain'),
                            onTap: () async {
                              await _complainOnPost();
                            },
                          ),
                        ]
                      ];
                    },
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.grey,
                    ),
                  ),
                ],
              )),
          Align(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: Text(_post.text!),
            ),
            alignment: Alignment.centerLeft,
          ),
          if (_post.attachments != null) ...[
            if (_post.attachments!.isNotEmpty) ...[
              CarouselSlider(
                options: CarouselOptions(
                    // height: 200.0,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentImage = index;
                      });
                    }),
                items: _post.attachments!.map<Widget>((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return CachedNetworkImage(
                        imageUrl: httpClient.serverURL +
                            httpClient.getAttachmentEndpoint +
                            i +
                            '?access_token=' +
                            httpClient.accessToken!,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              value: downloadProgress.progress,
                              color: Colors.black,
                              backgroundColor: Colors.grey,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => const Center(
                            child: Text(
                          'Unable to load image',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        )),
                      );
                    },
                  );
                }).toList(),
              ),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      List<Widget>.generate(_post.attachments!.length, (index) {
                    return Container(
                      margin: const EdgeInsets.all(3),
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                          color: currentImage == index
                              ? Colors.black
                              : Colors.black26,
                          shape: BoxShape.circle),
                    );
                  }),
                ),
              )
            ]
          ],
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    _likePost();
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: (_post.usersLiked.contains(httpClient.username))
                        ? Colors.redAccent
                        : Colors.grey,
                  )),
              Text(
                _post.usersLiked.length.toString(),
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                  onPressed: () {
                    _showPostComments();
                  },
                  icon: const Icon(
                    Icons.mode_comment,
                    color: Colors.grey,
                  )),
              Text(
                _post.comments.length.toString(),
                style: TextStyle(color: Colors.grey[700]),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 3.0),
            child: Text(
              formatter.format(_post.publicationDate!),
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _likePost() async {
    if (!_post.usersLiked.contains(httpClient.username)) {
      setState(() {
        _post.usersLiked.add(httpClient.username);
      });
      int status = await httpClient.likePost(_post.id!);
      if (status != 200) {
        _post.usersLiked.remove(httpClient.username);
      }
    } else {
      setState(() {
        _post.usersLiked.remove(httpClient.username);
      });
      int status = await httpClient.unlikePost(_post.id!);
      if (status != 200) {
        _post.usersLiked.add(httpClient.username);
      }
    }

    setState(() {});
  }

  _showPostComments() {
    if (!widget.detailed) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PostCommentsPage(_post)));
    }
  }

  _complainOnPost() async {
    bool complain = false;
    String cause = '';
    await Future<void>.delayed(
        const Duration(), // OR const Duration(milliseconds: 500),
        () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Complain on post'),
                  content: SizedBox(
                    height: 157,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: GestureDetector(
                            child: const Text('Spam'),
                            onTap: () {
                              complain = true;
                              cause = 'SPAM';
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: GestureDetector(
                            child: const Text('Fraud'),
                            onTap: () {
                              complain = true;
                              cause = 'FRAUD';
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: GestureDetector(
                            child: const Text('Violent content'),
                            onTap: () {
                              complain = true;
                              cause = 'VIOLENT';
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: GestureDetector(
                            child: const Text('Adult content'),
                            onTap: () {
                              complain = true;
                              cause = 'ADULT';
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        GestureDetector(
                          child: const Text('Abuse'),
                          onTap: () {
                            complain = true;
                            cause = 'ABUSE';
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ),
                )));
    if(complain){
      httpClient.createPostComplaint(_post.id!, cause);
    }
  }
}
