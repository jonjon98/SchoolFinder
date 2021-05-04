import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tes/Favourites.dart';

class FavouritesInterface {
  static const ROOT = 'http://localhost:8080/Favourites/favourite.php';     // Change this acc to PHP
 // static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_FAVOURITES_ACTION = 'ADD_FAVOURITES';
  static const _GET_ALL_FOR_ONE_USER = 'GET_FAVOURITES_USER';
  // static const _UPDATE_EMAIL_ACTION = 'UPDATE_EMAIL';
  // static const _UPDATE_POSTAL_ACTION = 'UPDATE_POSTAL_CODE';
  // static const _UPDATE_UNITS_ACTION = 'UPDATE_UNITS';
   static const _DELETE_FAV_ACTION = 'DELETE_FAV';

  static Future<List<FAVOURITES>> getFavouritesForOneUSER(String Username) async {
    try {

      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_FOR_ONE_USER;
      map['Username']=Username;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        List<FAVOURITES> list = parseResponse(response.body);
        return list;
      } else {
        return List<FAVOURITES>();
      }
    } catch (e) {
      print("$e");
      return List<FAVOURITES>();
    }
  }
  static List<FAVOURITES> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<FAVOURITES>((json) => FAVOURITES.fromJson(json)).toList();
  }

  static Future<bool> addFAVOURITES(String username, String SchoolName) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_FAVOURITES_ACTION;
      map['Username'] = username;
      map['SchoolName'] = SchoolName;
      final response = await http.post(ROOT, body: map);
      print('addFavourite Response: ${response.body}');
      if (200 == response.statusCode) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  static Future<bool> deleteFavourite(String username, String SchoolName) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_FAV_ACTION;
      map['Username'] = username;
      map['SchoolName'] = SchoolName;
      final response = await http.post(ROOT, body: map);
      print('deleteFAV Response: ${response.body}');
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