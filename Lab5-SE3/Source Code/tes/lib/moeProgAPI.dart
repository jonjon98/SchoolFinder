import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
int count =0;
Future<List<School4>> _getSchools() async{
  int totalRecords1, totalRecords2, totalRecords3, totalRecords4, totalRecords5;
  String generalInfo_Url1a, subjectsOffered_Url2a, cca_Url3a, moeProg_Url4a, schoolDistinctiveProg_Url5a;
  //Fetch 5 APIs(General Info, Subjects Offered, CCAs, MOE Programmes, School Distinctive Programmes)

  //fetch API(General Information of School) and get total no. of records(345)
  var url1a = 'https://data.gov.sg/api/action/datastore_search?resource_id=ede26d32-01af-4228-b1ed-f05c45a1d8ee';
  var response1 = await http.get(url1a);

  if (response1.statusCode == 200) {
    generalInfo_Url1a = response1.body;
    totalRecords1 = jsonDecode(generalInfo_Url1a)['result']['total'];
  } else {
    print('Response statusCode: ${response1.statusCode}');
    throw Exception('Failed to fetch data');
  }
  //now fetch all data from API(General Information of School)
  var generalInfo_Url1 = http.get(url1a + '&limit=${totalRecords1}');

  //fetch API(Subjects Offered) and get total no. of records(8545)
  var url2a = 'https://data.gov.sg/api/action/datastore_search?resource_id=3bb9e6b0-6865-4a55-87ba-cc380bc4df39';
  var response2 = await http.get(url2a);
  if (response2.statusCode == 200) {
    subjectsOffered_Url2a = response2.body;
    totalRecords2 = jsonDecode(subjectsOffered_Url2a)['result']['total'];
  } else {
    print('Response statusCode: ${response2.statusCode}');
    throw Exception('Failed to fetch data');
  }
  //now fetch all data from API(Subjects Offered)
  var subjectsOffered_Url2 = http.get(url2a + '&limit=${totalRecords2}');

  //fetch API(CCAs) and get total no. of records(5708)
  var url3a = 'https://data.gov.sg/api/action/datastore_search?resource_id=dd7a056a-49fa-4854-bd9a-c4e1a88f1181';
  var response3 = await http.get(url3a);
  if (response3.statusCode == 200) {
    cca_Url3a = response3.body;
    totalRecords3 = jsonDecode(cca_Url3a)['result']['total'];
  } else {
    print('Response statusCode: ${response3.statusCode}');
    throw Exception('Failed to fetch data');
  }
  //now fetch all data from API(CCAs)
  var cca_Url3 = http.get(url3a + '&limit=${totalRecords3}');

  //fetch API(MOE Programmes) and get total no. of records(34)
  var url4a = 'https://data.gov.sg/api/action/datastore_search?resource_id=9a94c7ed-710b-4ba5-8e01-8588f129efcc';
  var response4 = await http.get(url4a);
  if (response4.statusCode == 200) {
    moeProg_Url4a = response4.body;
    totalRecords4 = jsonDecode(moeProg_Url4a)['result']['total'];
  } else {
    print('Response statusCode: ${response4.statusCode}');
    throw Exception('Failed to fetch data');
  }
  //now fetch all data from API(MOE Programmes)
  var moeProg_Url4 = http.get(url4a + '&limit=${totalRecords4}');

  //fetch API(School Distinctive Programmes) and get total no. of records(288)
  var url5a = 'https://data.gov.sg/api/action/datastore_search?resource_id=74362320-e29d-458f-aa56-d9971ee310fd';
  var response5 = await http.get(url5a);
  if (response5.statusCode == 200) {
    schoolDistinctiveProg_Url5a = response5.body;
    totalRecords5 = jsonDecode(schoolDistinctiveProg_Url5a)['result']['total'];
  } else {
    print('Response statusCode: ${response5.statusCode}');
    throw Exception('Failed to fetch data');
  }
  //now fetch all data from API(MOE Programmes)
  var schoolDistinctiveProg_Url5 = http.get(url5a + '&limit=${totalRecords5}');
  //------------------------------------------------------------------------------------------------------------------------
  //fetch all 5 URLs for the APIs
  var result = await Future.wait([generalInfo_Url1, subjectsOffered_Url2, cca_Url3, moeProg_Url4, schoolDistinctiveProg_Url5]);

  var generalInfo_Data = json.decode(result[0].body)['result']['records'];
  var subjectsOffered_Data = json.decode(result[1].body)['result']['records'];
  var cca_Data = json.decode(result[2].body)['result']['records'];
  var moeProg_Data = json.decode(result[3].body)['result']['records'];
  var schoolDistinctiveProg_Data = json.decode(result[4].body)['result']['records'];

  //----------------------------------------------------------------------------------------------------------------------------
  //Map Attributes
  //Map General Info (Schools' name)

  List<School4> AllSchoolList4 = [];

  for(var s in moeProg_Data){
    School4 school = School4(s['school_name'], s['moe_programme_desc']);
    AllSchoolList4.add(school);
  }
  int schoolNo = AllSchoolList4.length;
  print('Total no. of Schools in this list: $schoolNo');
  //print(AllSchoolList4[0].school_name);
  //print(AllSchoolList4[0].moe_programme_desc);

  return AllSchoolList4;
}
  //Function(s) to retrieve info/filter schools-----------------------------------------------------------------------------------------------------------------------------------------
  //Retrieve MOE Programme information of a particular school
  Future<List<String>> getmoeProg(String school_name) async {
    List<String> moeProgList = [];
    List<School4> AllSchoolList4 = await _getSchools();
    for (int i = 0; i < AllSchoolList4.length; i++){
      if (AllSchoolList4[i].school_name == school_name)
      {
        moeProgList.add(AllSchoolList4[i].moe_programme_desc);
      }
    }
    // return(moeProgList);

  }

  //Filter Schools by MOE Programme, return list of schools



//Classes
class School4 {
  String school_name;
  String moe_programme_desc;



  School4(this.school_name, this.moe_programme_desc);
}

class SchoolList4 extends StatelessWidget {
  Future<List<School4>> fetchSchools() async{
    Future<List<School4>> allSchool = _getSchools();
    return allSchool;
  }

  @override
  Widget build(BuildContext context) {
    Future<List<School4>> allSchools = fetchSchools();
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Schools'),
        actions: <Widget>[
          Container(
              child: FutureBuilder<List<School4>>(
                  future: allSchools,
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      return IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            showSearch(context: context, delegate: DataSearch(snapshot.data));
                          });
                    }
                    return IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          showSearch(context: context, delegate: DataSearch(snapshot.data));
                        });
                  }
              )
          )
          // IconButton(
          //     icon: Icon(Icons.search),
          //     onPressed: () {
          //       showSearch(context: context, delegate: DataSearch());
          //     })
        ],
      ),
      drawer: Drawer(),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: fetchSchools(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(snapshot.data[index].school_name),
                          )
                        ],
                      ),
                    );
                  });
            } else {
              count++;
              print(count.toString());
              if(count<1000000000) {
                return Center(child: CircularProgressIndicator());
              }
              else
                {
                  return ListView.builder();
                }
            }
          },
        ),
      ),
    );
  }
}


class DataSearch extends SearchDelegate<String> {

  List<School4> allSchools;

  DataSearch(this.allSchools);

  List<String> convertList(List<School4> allSchools) {
    List<String> AllSchoolList = [];
    for (int i = 0; i < allSchools.length; i++) {
      String school = allSchools[i].school_name;
      AllSchoolList.add(school);
    }

    return AllSchoolList;
  }

  // var AllSchoolList = ['random list', 'random word', 'random phrase'];
  final recentSchool = ['test'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // actions for app bar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading icon on the left of the app bar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // show some results based on the selection
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searches for something
    final suggestionList = query.isEmpty
        ? convertList(allSchools)
        : convertList(allSchools)
        .where((p) => p.contains(query.toUpperCase()))
        .toList();

    return ListView.builder(
      itemBuilder: (context, index) =>
          ListTile(
            leading: Icon(Icons.location_city),
            title: RichText(
              text: TextSpan(
                  text: suggestionList[index].substring(
                      0, suggestionList[index].indexOf(query.toUpperCase())),
                  style: TextStyle(
                      color: Colors.grey),
                  children: [
                    TextSpan(
                        text: suggestionList[index].substring(
                            suggestionList[index].indexOf(query.toUpperCase()),
                            suggestionList[index].indexOf(query.toUpperCase()) +
                                query.length),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                              text: suggestionList[index].substring(
                                  suggestionList[index].indexOf(
                                      query.toUpperCase()) + query.length,
                                  suggestionList[index].length),
                              style: TextStyle(
                                  color: Colors.grey)
                          )
                        ])
                  ]),
            ),
          ),
      itemCount: suggestionList.length,
    );
  }
}