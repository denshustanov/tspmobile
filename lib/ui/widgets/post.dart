import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tspmobile/http_client.dart';
import 'package:tspmobile/model/post.dart';
import 'package:tspmobile/ui/widgets/user_label.dart';

class PostWidget extends StatefulWidget {
  PostWidget(this.post, this.updateParent);

  Function updateParent;
  final Post post;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final HttpClient httpClient = HttpClient();
  final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
  late PageController _pageController;

  int currentImage = 0;


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
                  userLabel(widget.post.author, context),
                  PopupMenuButton(
                    itemBuilder: (context) {
                      return <PopupMenuEntry>[
                        if (widget.post.author.username! ==
                            httpClient.username) ...[
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
                                                    await httpClient.deletePost(
                                                        widget.post.id!);
                                                    widget.updateParent();
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
              child: Text(widget.post.text!),
            ),
            alignment: Alignment.centerLeft,
          ),
          if (widget.post.attachments != null) ...[
            CarouselSlider(
              options: CarouselOptions(
                // height: 200.0,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason){
                  setState(() {
                    currentImage = index;
                  });
                }
              ),
              items: widget.post.attachments!.map<Widget>((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            image: DecorationImage(image: NetworkImage(httpClient.serverURL +
                                httpClient.getAttachmentEndpoint + i,
                                headers: {
                                  'Authorization': httpClient.getAuthorizationHeader()
                                }))));
                  },
                );
              }).toList(),
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(widget.post.attachments!.length, (index){
                  return Container(
                    margin: const EdgeInsets.all(3),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                        color: currentImage == index ? Colors.black : Colors.black26,
                        shape: BoxShape.circle),
                  );
                }),
              ),
            )

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
                widget.post.likesCount.toString(),
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
                widget.post.commentsCount.toString(),
                style: TextStyle(color: Colors.grey[700]),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 3.0),
            child: Text(
              formatter.format(widget.post.publicationDate!),
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
                      await httpClient.deletePost(widget.post.id!);
                      widget.updateParent();
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
