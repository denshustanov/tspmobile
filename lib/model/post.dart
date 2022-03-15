import 'package:intl/intl.dart';
import 'package:tspmobile/model/PostAttachment.dart';

import 'user.dart';

class Post {
  String? text;
  User author;
  int likesCount;
  int commentsCount;
  List<String>? attachments;
  DateTime? publicationDate;
  String? id;

  Post(this.text, this.author, this.attachments, this.likesCount,
      this.commentsCount, this.publicationDate);

  factory Post.fromJson(Map<String, dynamic> json) {
    Post post =  Post(
        json["text"],
        User.fromJson(json["author"]),
        List<String>.from(
            json["attachmentIDs"].map((value) => value.toString())),
        json["likesCount"],
        json["commentsCount"],
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
