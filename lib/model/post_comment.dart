import 'package:intl/intl.dart';
import 'package:tspmobile/model/user.dart';

class PostComment{
  String text;
  User? author;
  String? postId;
  DateTime publicationDate;

  PostComment(this.text, this.postId, this.author, this.publicationDate);

  factory PostComment.fromJson(Map<String, dynamic> json){
    return PostComment(
        json["text"],
        json["postId"],
        User.fromJson(json["author"]),
        DateTime.parse(json["publicationDate"]));
  }

  Map<String, dynamic> toJson(){
    final DateFormat formatter = DateFormat('yyyy-MM-ddThh:mm:ss');
    return {
      "text": text,
      "postId": postId,
      "publicationDate": formatter.format(publicationDate)
    };
  }
}