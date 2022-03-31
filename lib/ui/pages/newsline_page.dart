import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tspmobile/http_client.dart';
import 'package:tspmobile/model/user.dart';
import 'package:tspmobile/model/post.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:tspmobile/ui/pages/post/new_post_page.dart';
import 'package:tspmobile/ui/widgets/new_post_button.dart';
import 'package:tspmobile/ui/widgets/post.dart';

class NewslinePage extends StatefulWidget {
  const NewslinePage({Key? key}) : super(key: key);

  @override
  _NewslinePageState createState() => _NewslinePageState();
}

class _NewslinePageState extends State<NewslinePage> {
  final HttpClient _httpClient = HttpClient();

  List<Post> _posts = [];
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _refreshIndicatorKey.currentState!.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        flexibleSpace: GestureDetector(
          onTap: () {
            _scrollController.animateTo(
                _scrollController.position.minScrollExtent,
                duration: Duration(milliseconds: 500),
                curve: Curves.ease);
          },
        ),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.notifications, color: Colors.grey,))
        ],
        // leading: const Icon(Icons.account_circle),
        title: const Text('posts'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: loadPosts,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  controller: _scrollController,
                  itemCount: _posts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
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
                          onTap: () async{
                            await Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const NewPostPage())
                            );
                            _refreshIndicatorKey.currentState!.show();
                          },
                        ),
                      );
                    }
                    return PostWidget(_posts.elementAt(index - 1), loadPosts, false);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future loadPosts() async {
    List<Post> posts = await _httpClient.loadPosts();
    posts.sort((a, b) {
      return b.publicationDate!.compareTo(a.publicationDate!);
    });
    setState(() {
      _posts = posts;
    });
  }
}
