import 'package:flutter/material.dart';
import 'package:tspmobile/http_client.dart';
import 'package:tspmobile/model/post.dart';
import 'package:tspmobile/model/user.dart';
import 'package:tspmobile/ui/widgets/post.dart';
import 'package:tspmobile/ui/widgets/user_label.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);


  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin{
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final HttpClient _httpClient = HttpClient();

  List<User> _foundUsers = [];
  List<Post> _foundPosts = [];

  String _usersFindString = '';
  String _postsFindString = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if(_tabController.index == 0){
        _searchController.text = _usersFindString;
      }
      else{
        _searchController.text = _postsFindString;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(5)
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(onPressed: (){
                _searchController.text = '';
              }, icon: const Icon(Icons.clear),),
              hintText: 'Search...',
                border: InputBorder.none
            ),
            onChanged: (value) async{
              if(_tabController.index == 0) {
                _usersFindString = value;
                if (value.isEmpty) {
                  _foundUsers = [];
                } else {
                  _foundUsers = await _httpClient.findUsersByUsername(value);
                }
              } else{
                _postsFindString = value;
                if (value.isEmpty) {
                  _foundPosts = [];
                } else {
                  _foundPosts = await _httpClient.findPosts(value);
                }
              }
              setState(() {});
            },
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'Users',
            ),
            Tab(
              text: "Posts",
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView.builder(
              itemCount: _foundUsers.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: userLabel(_foundUsers.elementAt(index), context, 20),
                );
              }),
          ListView.builder(
            itemCount: _foundPosts.length,
              itemBuilder: (context, index){
            return PostWidget(_foundPosts.elementAt(index), null, false);
          })
        ],
      ),

    );
  }
}
