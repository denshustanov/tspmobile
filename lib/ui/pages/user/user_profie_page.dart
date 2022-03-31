import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tspmobile/authentication_service.dart';
import 'package:tspmobile/http_client.dart';
import 'package:tspmobile/model/post.dart';
import 'package:tspmobile/model/user.dart';
import 'package:tspmobile/model/user_list.dart';
import 'package:tspmobile/ui/pages/login_page.dart';
import 'package:tspmobile/ui/pages/user/users_list_page.dart';
import 'package:tspmobile/ui/widgets/pick_image.dart';
import 'package:tspmobile/ui/widgets/post.dart';

class UserProfilePage extends StatefulWidget {
  UserProfilePage(this.username);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();

  final String username;
}

class _UserProfilePageState extends State<UserProfilePage> {
  final HttpClient _httpClient = HttpClient();
  final AuthenticationService _authenticationService = AuthenticationService();
  bool _subscribed = false;

  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: loadUser(widget.username),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(widget.username),
              actions: [
                Visibility(
                    child: IconButton(
                  onPressed: () {
                    _httpClient.signOut();
                    _authenticationService.deleteCredentials();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LoginPage()));
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.grey,
                  ),
                ))
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                setState(() {});
                loadPosts();
              },
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        itemCount: _posts.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 30,
                                        backgroundImage: CachedNetworkImageProvider(
                                            _httpClient.serverURL +
                                                '/user/' +
                                                widget.username +
                                                '/avatar',
                                            headers: {
                                              'Authorization': _httpClient
                                                  .getAuthorizationHeader()
                                            }),
                                      ),
                                      onTap: () async {
                                        if (widget.username ==
                                            _httpClient.username) {
                                          XFile? image =
                                              await pickSingleImage(context);
                                          if (image != null) {
                                            File imageFile = File(image.path);
                                            _httpClient.updateUserAvatar(
                                                await imageFile.readAsBytes());
                                            setState(() {});
                                          }
                                        }
                                      },
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          snapshot.data!.postsCount.toString(),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text("Posts")
                                      ],
                                    ),
                                    GestureDetector(
                                      child: Column(
                                        children: [
                                          Text(
                                            snapshot.data!.subscribersCount
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Text("Subscribers")
                                        ],
                                      ),
                                      onTap: () => openSubscribers(),
                                    ),
                                    GestureDetector(
                                      child: Column(
                                        children: [
                                          Text(
                                            snapshot.data!.subscriptionsCount
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Text("Subscriptions")
                                        ],
                                      ),
                                      onTap: () => openSubscriptions(),
                                    )
                                  ],
                                ),
                                if (snapshot.data!.bio != null) ...[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, top: 8.0, bottom: 8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          snapshot.data!.bio!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Visibility(
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.grey,
                                              size: 20,
                                            ),
                                          ),
                                          visible: widget.username ==
                                              _httpClient.username,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                                if (widget.username !=
                                    _httpClient.username) ...[
                                  Align(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (!_subscribed) {
                                          await _httpClient
                                              .subscribe(widget.username);
                                        } else {
                                          await _httpClient
                                              .unsubscribe(widget.username);
                                        }
                                        setState(() {
                                          _subscribed = !_subscribed;
                                        });
                                      },
                                      child: Text(
                                        !_subscribed
                                            ? 'Subscribe'
                                            : 'Unsubscribe',
                                        style: TextStyle(
                                            color: _subscribed
                                                ? Colors.grey[700]
                                                : Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          primary: _subscribed
                                              ? Colors.grey[300]
                                              : Colors.blue),
                                    ),
                                    alignment: Alignment.center,
                                  )
                                ],
                                const Divider(
                                  height: 5,
                                  color: Colors.grey,
                                  indent: 5,
                                  endIndent: 5,
                                ),
                              ],
                            );
                          }
                          return PostWidget(
                              _posts.elementAt(index - 1), loadPosts);
                        }),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error loading data'),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<User> loadUser(String username) async {
    return await _httpClient.getUser(widget.username);
  }

  Future loadPosts() async {
    bool subscribed = await _httpClient.checkSubscription(widget.username);
    List<Post> posts = await _httpClient.loadUserPosts(widget.username);
    posts.sort((a, b) {
      return b.publicationDate!.compareTo(a.publicationDate!);
    });
    setState(() {
      _subscribed = subscribed;
      _posts = posts;
    });
  }

  void openSubscribers() async {
    List<User> users = await _httpClient.getUserSubscribers(widget.username);
    UserList userList = UserList(widget.username + '\'s subscribers', users);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => UserListPage(userList)));
  }

  void openSubscriptions() async {
    List<User> users = await _httpClient.getUserSubscriptions(widget.username);
    UserList userList = UserList(widget.username + '\'s subscriptions', users);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => UserListPage(userList)));
  }
}
