import 'package:flutter/material.dart';
import 'package:tspmobile/model/User.dart';
import 'package:tspmobile/model/post.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:tspmobile/ui/widgets/post.dart';

class NewslinePage extends StatefulWidget {
  const NewslinePage({Key? key}) : super(key: key);

  @override
  _NewslinePageState createState() => _NewslinePageState();
}

class _NewslinePageState extends State<NewslinePage> {
  List<Post> _posts = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 10; i++) {
      User user = User();
      user.username = 'username';
      _posts.add(Post('#postsforfood', user, null, 42, 12));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        flexibleSpace: GestureDetector(
          onTap: (){
            _scrollController.animateTo(_scrollController.position.minScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
        ),
        // leading: const Icon(Icons.account_circle),
        title: const Text('posts'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              controller: _scrollController,
                itemCount: _posts.length+1,
                itemBuilder: (context, index) {
                  if(index == 0){
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
                        onTap: () {},
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: post(_posts.elementAt(index-1))
                  );
                }),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile')
        ],
      ),
    );
  }
}
