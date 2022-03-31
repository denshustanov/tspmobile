import 'package:intl/intl.dart';
import 'package:tspmobile/model/PostAttachment.dart';
import 'package:tspmobile/model/post_comment.dart';

import 'user.dart';

class Post {
  String? text;
  User author;
  List<String> usersLiked;
  List<PostComment> comments;
  List<String>? attachments;
  DateTime? publicationDate;
  String? id;

  Post(this.text, this.author, this.attachments, this.usersLiked,
      this.comments, this.publicationDate);

  factory Post.fromJson(Map<String, dynamic> json) {
    Post post =  Post(
        json["text"],
        User.fromJson(json["author"]),
        List<String>.from(
            json["attachmentIDs"].map((value) => value.toString())),
        List<String>.from(
            json["usersLiked"].map((value) => value.toString())),
        List<PostComment>.from(
          json["comments"].map((value) => PostComment.fromJson(value))),
        DateTime.parse(json["publicationDate"]));
    post.id = json["id"];
    return post;
  }

  Map<String, dynamic> toJson() {
    final DateFormat formatter = DateFormat('yyyy-MM-ddThh:mm:ss');
    return {
      "text": text,
      "publicationDate": formatter.format(publicationDate!),
      "attachments": attachments
    };
  }
}
