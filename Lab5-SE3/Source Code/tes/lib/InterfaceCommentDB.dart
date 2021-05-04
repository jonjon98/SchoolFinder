import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tes/Comment.dart';
import 'package:tes/Rating.dart';

class CommentInterface {
  static const ROOT = 'http://localhost:8080/Comment/comments.php';     // Change this acc to PHP
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_COMMENT_ACTION = 'ADD_COMMENT';
  static const _GET_ALL_FOR_ONE_SCHOOL = 'GET_COMMENT_SCHOOL';
  static const _GET_AVG_RATING = 'GET_AVG_RATING';
  static const _GET_five = 'GET_NO_5';
  static const _GET_four = 'GET_NO_4';
  static const _GET_three = 'GET_NO_3';
  static const _GET_two = 'GET_NO_2';
  static const _GET_one = 'GET_NO_1';



  static Future<List<COMMENT>> getComments() async {
    try {

      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(ROOT, body: map);
      print('getComments Response: ${response.body} :::: ${response.statusCode}');
      if (200 == response.statusCode) {

        List<COMMENT> list = parseResponse(response.body);
        for(dynamic i in list)
          {
            print(i.username);
          }
        return list;
      } else {
        print("Yes");
        return List<COMMENT>();
      }
    } catch (e) {
      print("$e");
      return List<COMMENT>();
    }
  }
  static Future<List<COMMENT>> getCommentsForOneSchool(String SchoolName) async {
    try {

      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_FOR_ONE_SCHOOL;
      map['SchoolName'] = SchoolName;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {

        List<COMMENT> list = parseResponse(response.body);
        return list;
      } else {
        return List<COMMENT>();
      }
    } catch (e) {
      print("$e");
      return List<COMMENT>();
    }
  }
  static List<COMMENT> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<COMMENT>((json) => COMMENT.fromJson(json)).toList();
  }


  // Method to add USER to the database...
  static Future<bool> addComment(String username, String message, String SchoolName,String rating) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_COMMENT_ACTION;
      map['Username'] = username;
      map['Message'] = message;
      map['SchoolName'] = SchoolName;
      map['Rating'] = rating;
      final response = await http.post(ROOT, body: map);
      print('addComment Response: ${response.body}');
      if (200 == response.statusCode) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  static Future<String> get_avg(String SchoolName) async {
    try {
      Map valueMap;
      String Res;
      var map = Map<String, dynamic>();
      map['action'] = _GET_AVG_RATING;
      map['SchoolName'] = SchoolName;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {

       valueMap = json.decode(response.body);
        Res=valueMap["AVG(Rating)"];
        return Res;
      } else {
        return Res;
      }
    } catch (e) {
      print("$e");
    }
  }
  static Future<String> getfive(String SchoolName) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_five;
      map['SchoolName'] = SchoolName;
      final response = await http.post(ROOT, body: map);
      print('AVG Response: ${response.body}');
      if (200 == response.statusCode) {
        String avg=(response.body[0]);
        return avg;
      } else {
        return "0";
      }
    } catch (e) {
      return "-1";
    }
  }
}