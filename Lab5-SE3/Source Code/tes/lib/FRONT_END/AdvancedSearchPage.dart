import 'dart:io';
import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tes/BACK_END_INTERFACE.dart';
import 'package:tes/FRONT_END/Login_info.dart';
import 'dart:convert';
import 'drawer_navigation.dart';
import '../Schools.dart';
import '../API_INTERFACE.dart';
import 'Login_info.dart';
import '../Advance_Back.dart';
// List<Schools> myList;
// void getStringList() async{
//   int i;
//   var AllSchoolList1 = [];
//   var tempList = await _getSchool();
//   myList = tempList;
//   for (i=0; i<myList.length; i++){
//     AllSchoolList1.add(myList[i].name);
//   }
// }
String username, pass;
class SchoolListAdvanced extends StatelessWidget {
  bool checklogin=false;
  final Login_info lg;
  SchoolListAdvanced({Key key,this.lg}) : super(key:key);
  // Future<List<Schools>> fetchSchools() async{
  //   Future<List<Schools>> allSchool = getSchool();
  //   return allSchool;
  // }
  @override
  Widget build(BuildContext context) {
    Advanced_info lg1=ModalRoute.of(context).settings.arguments;
    if(lg1!=null)
    {
      checklogin=true;
      username=lg1.username;
      pass=lg1.Password;

    }
    else
    {
      username=null;
      pass=null;
    }
    Future<List<Schools>> allSchools = fetchBasedOnCriteria(lg1.level, lg1.subject, lg1.ccaCategory, lg1.ccaName);
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Schools'),
        actions: <Widget>[
          Container(
              child: FutureBuilder<List<Schools>>(
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
      drawer: (lg1!=null)?DrawerNavigation():null,
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: fetchBasedOnCriteria(lg1.level, lg1.subject, lg1.ccaCategory, lg1.ccaName),
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
                            onTap: (){
                              Navigator.pushNamed(context, '/Moreinfo',
                                arguments: More_info(username,pass,snapshot.data[index].name),
                              );
                            },
                            title: Text(snapshot.data[index].name),
                            subtitle: Text(snapshot.data[index].zoneCode == null? " ":snapshot.data[index].zoneCode),
                          )
                        ],
                      ),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {

  List<Schools> allSchools;
  DataSearch(this.allSchools);

  List<String> convertList(List<Schools> allSchools){

    List<String> AllSchoolList = [];
    for (int i=0; i< allSchools.length; i++) {
      String school = allSchools[i].name;
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
          onPressed: (

              ) {
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
        : convertList(allSchools).where((p) => p.contains(query.toUpperCase())).toList();

    return ListView.builder(
      itemBuilder: (context, index) =>

          ListTile(
            onTap: (){
              Navigator.pushNamed(context, '/Moreinfo',
                  arguments: More_info(username,pass,suggestionList[index].substring(suggestionList[index].indexOf(query.toUpperCase()))));
            },
            leading: Icon(Icons.location_city),
            title: RichText(
              text: TextSpan(
                  text: suggestionList[index].substring(0, suggestionList[index].indexOf(query.toUpperCase())),
                  style: TextStyle(
                      color: Colors.grey),
                  children: [
                    TextSpan(
                        text: suggestionList[index].substring(suggestionList[index].indexOf(query.toUpperCase()), suggestionList[index].indexOf(query.toUpperCase()) + query.length),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                              text: suggestionList[index].substring(suggestionList[index].indexOf(query.toUpperCase()) + query.length ,suggestionList[index].length),
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