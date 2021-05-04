import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tes/Report.dart';

class ReportInterface {
  static const ROOT = 'http://localhost:8080/Report/reports.php';     // Change this acc to PHP
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_REPORT_ACTION = 'ADD_REPORT';
  // static const _UPDATE_EMAIL_ACTION = 'UPDATE_EMAIL';
  // static const _UPDATE_POSTAL_ACTION = 'UPDATE_POSTAL_CODE';
  // static const _UPDATE_UNITS_ACTION = 'UPDATE_UNITS';
  // static const _DELETE_USR_ACTION = 'DELETE_USER';

  static Future<List<REPORT>> getReport() async {
    try {

      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(ROOT, body: map);
      print('getReport Response: ${response.body} :::: ${response.statusCode}');
      if (200 == response.statusCode) {

        List<REPORT> list = parseResponse(response.body);
        return list;
      } else {
        return List<REPORT>();
      }
    } catch (e) {
      print("$e");
      return List<REPORT>();
    }
  }
  static List<REPORT> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<REPORT>((json) => REPORT.fromJson(json)).toList();
  }

  // Method to add USER to the database...
  static Future<bool> addReport(String username, String message) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_REPORT_ACTION;
      map['Username'] = username;
      map['Message'] = message;
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
}