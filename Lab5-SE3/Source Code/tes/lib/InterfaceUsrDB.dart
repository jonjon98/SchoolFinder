import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tes/Encrypt_Decrypt.dart';
import 'user.dart';
class UserInterface {
  static const ROOT = 'http://localhost:8080/User/userinfo.php';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const USR_LOGIN_CHECK = 'LOGIN_CHECK';
  static const _ADD_USR_ACTION = 'ADD_USER';
  static const _UPDATE_PASS_ACTION = 'UPDATE_PASSWORD';
  static const _UPDATE_EMAIL_ACTION = 'UPDATE_EMAIL';
  static const _UPDATE_POSTAL_ACTION = 'UPDATE_POSTAL_CODE';
  static const _UPDATE_UNITS_ACTION = 'UPDATE_UNITS';
  static const _DELETE_USR_ACTION = 'DELETE_USER';
  static const _GET_EMAIL_ACTION = 'GET_EMAIL';
  static const _GET_POSTAL_ACTION ='GET_POSTAL';

  static Future<List<USER>> getUsers() async {
    try {

      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {

        List<USER> list = parseResponse(response.body);
        return list;
      } else {

        return List<USER>();
      }
    } catch (e) {
      print("$e");
      return List<USER>();
    }
  }

  static List<USER> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<USER>((json) => USER.fromJson(json)).toList();
  }

  // Method to add USER to the database...
  static Future<bool> addUSER(String username, String password, String email) async {
    try {
      var map = Map<String, dynamic>();
      await encrypt.encryptString(password).then((value)  {
        password=value;
      });
      map['action'] = _ADD_USR_ACTION;
      map['Username'] = username;
      map['Password'] = password;
      map['Email'] = email;
      print( map['Password'] + ",,,,,,,");
      final response = await http.post(ROOT, body: map);
      print('addUSER Response: ${response.body}');
      if (200 == response.statusCode) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  static Future<bool> loginCHECK(String username, String password) async {
    try {
      var map = Map<String, dynamic>();
      bool res;
      map['action'] = USR_LOGIN_CHECK;
      map['Username'] = username;
      map['Password'] = password;

      print(password);
      await getUsers().then((users) async {
        for (var i in users) {
          await encrypt.decryptString(i.password).then((value)  {
            i.password=value;
          });
          if (i.username.toString() == username && i.password.toString() == password) {
            res=true;
          }
        }
      });
      if(res==true)
      {
        return true;
      }
      else
      {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> updatePASS(
      String username, String password) async {
    try {
      var map = Map<String, dynamic>();
      await encrypt.encryptString(password).then((value)  {
        password=value;
      });
      map['action'] = _UPDATE_PASS_ACTION;
      map['Username'] = username;
      map['Password'] = password;
      final response = await http.post(ROOT, body: map);
      print('updatePASS Response: ${response.body}');
      if (200 == response.statusCode) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  static Future<bool> updateEMAIL(
      String username, String email) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_EMAIL_ACTION;
      map['Username'] = username;
      map['Email'] = email;
      final response = await http.post(ROOT, body: map);
      print('updateEmail Response: ${response.body}');
      if (200 == response.statusCode) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  static Future<String> getEMAIL(
      String username) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_EMAIL_ACTION;
      map['Username'] = username;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        return jsonDecode(response.body)[0]["Email"];
      } else {
        return "-1";
      }
    } catch (e) {
      return "-1";
    }
  }
  static Future<String> getPOSTAL(
      String username) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_POSTAL_ACTION;
      map['Username'] = username;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        return jsonDecode(response.body)[0]["PostalCode"];
      } else {
        return "-1";
      }
    } catch (e) {
      return "-1";
    }
  }
  static Future<bool> updatePOSTAL(
      String username, String postal) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_POSTAL_ACTION;
      map['Username'] = username;
      map['PostalCode'] = postal;
      final response = await http.post(ROOT, body: map);
      print('updatePOSTAL Response: ${response.body}');
      if (200 == response.statusCode) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  static Future<bool> updateUNITS(
      String username, String units) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_UNITS_ACTION;
      map['Username'] = username;
      map['Units'] = units;
      final response = await http.post(ROOT, body: map);
      print('updateUnits Response: ${response.body}');
      if (200 == response.statusCode) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  static Future<bool> deleteUSER(String username) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_USR_ACTION;
      map['Username'] = username;
      final response = await http.post(ROOT, body: map);
      print('deleteUSER Response: ${response.body}');
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