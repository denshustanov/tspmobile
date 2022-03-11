import 'package:tspmobile/model/PostAttachment.dart';

import 'User.dart';

class Post{
  String? text;
  User author;
  int likesCount;
  int commentsCount;
  List<PostAttachment>? attachments;

  Post(this.text, this.author, this.attachments, this.likesCount, this.commentsCount);
}