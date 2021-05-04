import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tes/FRONT_END/Login_info.dart';
import 'dart:convert';
import 'Schools.dart';


Future<List<Schools>> getSchool() async{
  var url1 = http.get(
      'https://data.gov.sg/api/action/datastore_search?resource_id=ede26d32-01af-4228-b1ed-f05c45a1d8ee');
  var url2 = http.get(
      'https://data.gov.sg//api/action/datastore_search?offset=100&resource_id=ede26d32-01af-4228-b1ed-f05c45a1d8ee');
  var url3 = http.get(
      'https://data.gov.sg//api/action/datastore_search?offset=200&resource_id=ede26d32-01af-4228-b1ed-f05c45a1d8ee');
  var url4 = http.get(
      'https://data.gov.sg//api/action/datastore_search?offset=300&resource_id=ede26d32-01af-4228-b1ed-f05c45a1d8ee');
  var result = await Future.wait([url1, url2, url3, url4]);
  var jsonData0 = json.decode(result[0].body)['result']['records'];
  var jsonData1 = json.decode(result[1].body)['result']['records'];
  var jsonData2 = json.decode(result[2].body)['result']['records'];
  var jsonData3 = json.decode(result[3].body)['result']['records'];

  final List<Schools> AllSchoolList = [];

  for (var s in jsonData0) {
    Schools school = Schools(s['school_name'], s['zone_code']);
    AllSchoolList.add(school);
  }
  for (var s in jsonData1) {
    Schools school = Schools(s['school_name'], s['zone_code']);
    AllSchoolList.add(school);
  }
  for (var s in jsonData2) {
    Schools school = Schools(s['school_name'], s['zone_code']);
    AllSchoolList.add(school);
  }
  for (var s in jsonData3) {
    Schools school = Schools(s['school_name'], s['zone_code']);
    AllSchoolList.add(school);
  }
  int schoolNo = AllSchoolList.length;
  print('Total no. of Schools: $schoolNo');
  // print(AllSchoolList[0].name);
  return AllSchoolList;
}
