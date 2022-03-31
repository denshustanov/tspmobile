import 'package:flutter/material.dart';
import 'package:tspmobile/http_client.dart';
import 'package:tspmobile/ui/pages/newsline_page.dart';
import 'package:tspmobile/ui/pages/search_page.dart';
import 'package:tspmobile/ui/pages/user/user_profie_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HttpClient _httpClient = HttpClient();

  int _index = 1;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const SearchPage(),
      const NewslinePage(),
      UserProfilePage(_httpClient.username),
    ];

    return Scaffold(
      // body: IndexedStack(
      //   children: pages,
      //   index: _index,
      // ),
      body:IndexedStack(
        children: pages,
        index: _index,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile')
        ],
        onTap: (int index){
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }
}
