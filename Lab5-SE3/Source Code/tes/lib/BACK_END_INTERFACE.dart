import 'package:flutter/material.dart';
import 'package:tes/Comment.dart';
import 'package:tes/CommentDBMgr.dart';
import 'package:tes/FavouriteDBMgr.dart';
import 'package:tes/Favourites.dart';
import 'package:tes/Report.dart';
import 'package:tes/ReportDBMgr.dart';
import 'Rating.dart';
import 'userDBMgr.dart';
import 'user.dart';

class BACK_END
{
  static Future<bool> adduser(String username,String password, String email) async
  {
    bool res;
     await userDBMgr.addUSR(username,password, email).then((check)
    {
      res=check;
    });
    return res;
  }
  static Future<String> GETEMAIL(String username) async
  {
    String res;
    await userDBMgr.GETEMAIL(username)
        .then((result) {
      res=result;
    });
    return res;
  }
  static Future<String> GETPOSTAL(String username) async
  {
    String res;
    await userDBMgr.GETPOSTAL(username)
        .then((result) {
      res=result;
    });
    return res;
  }
  static Future<bool> LoginCheck(String username, String password) async
  {
      bool res;
      await userDBMgr.LoginCheck(username, password).then((check){
        res=check;
      });
      print("BACK"+res.toString());
      return res;
  }
  static Future<bool> DELUser(String Username) async
  {
    bool res;
    await userDBMgr.DelUSR(Username).then((check){
      res=check;
    });
    return res;
  }
  static Future<List<USER>> Get_All() async
  {
    List<USER> users;
    await userDBMgr.Get_All().then((user) {
        users = user;
    });
    return users;
  }
  static Future<bool> UpdatePassword(String username, String password) async
  {
    bool res;
    await userDBMgr.UpdatePassword(
        username, password)
        .then((check) {
      res = check;
      print("yayay"+res.toString());

    });
    return res;
  }
  static Future<bool> UpdateEmail(String username, String email) async
  {
    bool res;
    print("YEYEYE"+username);
    await userDBMgr.UpdateEmail(
        username, email)
        .then((check) {
      res = check;
      print("yayay"+res.toString());
    });
    return res;
  }
  static Future<bool> UpdatePostal(String username, String Postal) async
  {
    bool res;
    await userDBMgr.UpdatePostal(
        username, Postal)
        .then((check) {
      res = check;
    });
    return res;
  }
  static Future<bool> UpdateUnits(String username, String units) async
  {
    bool res;
    await userDBMgr.UpdateUnits(
        username, units)
        .then((check) {
      res = check;
    });
    return res;
  }
  static Future<bool> addComment(String username,String message, String SchoolName, String rating) async
  {
    bool res;
    await CommentMgr.addCOMMENTS(username,message,SchoolName,rating).then((check)
    {
      res=check;
    });
    return res;
  }
  static Future<List<COMMENT>> getAllForOneSchool(String SchoolName) async
  {
    List<COMMENT> Comments;
    await CommentMgr.GetAllForOneSchool(SchoolName).then((comment) {
      Comments = comment;
    });
    return Comments;
  }
  static Future<List<COMMENT>> getAllComments() async
  {
    List<COMMENT> Comments;
    await CommentMgr.Get_all_comments().then((comment) {
      Comments = comment;
    });
    return Comments;
  }
  static Future<String> Get_avg(String SchoolName) async
  {
    String res;
    await CommentMgr.Get_avg(SchoolName)
        .then((result) {
      res=result;
    });
    return res;
  }
  static Future<bool> addFavourite(String username, String SchoolName) async
  {
    bool res;
    await FavouriteMgr.addFavourite(username,SchoolName).then((check)
    {
      res=check;
    });
    return res;
  }
  static Future<List<FAVOURITES>> getallforuser(String username) async
  {
    List<FAVOURITES> Favourites;
    await FavouriteMgr.GetAllForOneUser(username).then((Favourite) {
      Favourites = Favourite;
    });
    return Favourites;
  }
  static Future<bool> DELFAV(String Username,String SchoolName) async
  {
    bool res;
    await FavouriteMgr.DELFAV(Username,SchoolName).then((check){
      res=check;
    });
    return res;
  }
  static Future<bool> addReport(String username, String message) async
  {
    bool res;
    await reportDBMgr.addREPORT(username,message).then((check)
    {
      res=check;
    });
    return res;
  }
  static Future<List<REPORT>> getallreports() async
  {
    List<REPORT> reports;
    await reportDBMgr.Get_All().then((report) {
      reports = report;
    });
    return reports;
  }


}