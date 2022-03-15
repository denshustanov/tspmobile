import 'package:flutter/material.dart';
import 'package:tspmobile/model/user_list.dart';
import 'package:tspmobile/ui/widgets/user_label.dart';

class UserListPage extends StatefulWidget {
  UserListPage(this.users);
  UserList users;

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.users.title),
      ),
      body: ListView.builder(
        itemCount: widget.users.users.length,
          itemBuilder: (context, index){
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: userLabel(widget.users.users.elementAt(index), context, 20),
        );
      }),
    );
  }
}
