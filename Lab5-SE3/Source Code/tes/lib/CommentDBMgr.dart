import 'package:tes/InterfaceCommentDB.dart';

import 'Comment.dart';
import 'dart:async';

import 'Rating.dart';
class CommentMgr
{
  static Future<bool> addCOMMENTS(String username, String message, String SchoolName, String rating) async
  {
    bool res;
    await CommentInterface.addComment(username,message,SchoolName,rating)
        .then((result) {
      if(result)
      {
        res=true;
      }
    });
    return res;
  }
  static Future<List<COMMENT>> GetAllForOneSchool(String SchoolName) async
  {
    List<COMMENT> res;
    await CommentInterface.getCommentsForOneSchool(SchoolName)
        .then((result) {
      res=result;
    });
    return res;
  }
  static Future<List<COMMENT>> Get_all_comments() async
  {
    List<COMMENT> res;
    await CommentInterface.getComments()
        .then((result) {
      res=result;
    });
    return res;
  }
  static Future<String> Get_avg(String SchoolName) async
  {
    String res;
    await CommentInterface.get_avg(SchoolName)
        .then((result) {
      res=result;
    });
    return res;
  }
  static Future<String> Get_five(String SchoolName) async
  {
    String res;
    await CommentInterface.getfive(SchoolName)
        .then((result) {
      res=result;
    });
    return res;
  }

}