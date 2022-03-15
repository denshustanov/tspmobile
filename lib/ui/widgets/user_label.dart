import 'package:flutter/material.dart';
import 'package:tspmobile/http_client.dart';
import 'package:tspmobile/model/user.dart';
import 'package:tspmobile/ui/pages/user_profie_page.dart';

Widget userLabel(User user, context) {
  final HttpClient httpClient = HttpClient();
  return GestureDetector(
    child: Row(
      children: [
        CircleAvatar(
          radius: 10,
          backgroundImage: NetworkImage(
              httpClient.serverURL + '/user/' + user.username! + '/avatar',
              headers: {'Authorization': httpClient.getAuthorizationHeader()}),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          user.username!,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ),
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UserProfilePage(user.username!)));
    },
  );
}
