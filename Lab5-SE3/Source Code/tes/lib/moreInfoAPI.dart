import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



Future<List<School1>> _getSchools() async{
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

  List<School1> AllSchoolList = [];

  for(var s in generalInfo_Data){
    School1 school = School1(s['school_name'],
        s['address'], s['bus_desc'], s['dgp_code'],
        s['email_address'],
        s['fax_no'], s['fax_no_2'], s['fifth_vp_name'],
        s['first_vp_name'],
        s['fourth_vp_name'],
        s['mainlevel_code'], s['missionstatement_desc'],
        s['mothertongue1_code'],
        s['mothertongue2_code'],
        s['mothertongue3_code'], s['mrt_desc'],
        s['philosophy_culture_ethos'],
        s['postal_code'],
        s['principal_name'], s['second_vp_name'], s['sixth_vp_name'],
        s['special_sdp_offered'],
        s['telephone_no'], s['telephone_no_2'], s['third_vp_name'],
        s['type_code'], s['url_address'],
        s['visionstatement_desc'], s['zone_code']);
    AllSchoolList.add(school);
  }
  int schoolNo = AllSchoolList.length;
  //print(AllSchoolList[0].school_name);
  //print(AllSchoolList[0].postal_code);

  //Function(s) to retrieve info/filter schools-----------------------------------------------------------------------------------------------------------------------------------------
  //Retrieve information of a particular school
  //To fetch a few information of the school, modify the if statement in for loop
  // -> "if school name is valid, return a paragraph of the retrieved info"
  // e.g.    for (int i = 0; i < AllSchoolList.length; i++){
  //           if (AllSchoolList[i].school_name == school_name)
  //           {
  //             print(AllSchoolList[i].school_name + AllSchoolList[i].fax_no + AllSchoolList[i].postal_code + ...);
  //           }
  //         }
  return AllSchoolList;

}
  Future<String> getInfo(school_name, String x) async {
    List<School1> AllSchoolList = await _getSchools();
    switch (x){
      case "school_name":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].school_name);
          }
        }
        break;
      case "fax_no":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].fax_no);
          }
        } break;
      case "fax_no_2":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].fax_no_2);
          }
        } break;
      case "postal_code":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].postal_code);
          }
        } break;
      case "type_code":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].type_code);
          }
        } break;
      case "principal_name":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].principal_name);
          }
        } break;
      case "first_vp_name":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].first_vp_name);
          }
        } break;
      case "second_vp_name":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].second_vp_name);
          }
        } break;
      case "third_vp_name":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].third_vp_name);
          }
        } break;
      case "fourth_vp_name":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].fourth_vp_name);
          }
        } break;
      case "fifth_vp_name":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].fifth_vp_name);
          }
        } break;
      case "sixth_vp_name":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].sixth_vp_name);
          }
        } break;
      case "mainlevel_code":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].mainlevel_code);
          }
        } break;
      case "telephone_no":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].telephone_no);
          }
        } break;
      case "telephone_no_2":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].telephone_no_2);
          }
        } break;
      case "email_address":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].email_address);
          }
        } break;
      case "visionstatement_desc":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].visionstatement_desc);
          }
        } break;
      case "missionstatement_desc":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].missionstatement_desc);
          }
        } break;
      case "philosophy_culture_ethos":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].philosophy_culture_ethos);
          }
        } break;
      case "mrt_desc":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].mrt_desc);
          }
        } break;
      case "bus_desc":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].bus_desc);
          }
        } break;
      case "special_sdp_offered":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].special_sdp_offered);
          }
        } break;
      case "mothertongue1_code":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].mothertongue1_code);
          }
        } break;
      case "mothertongue2_code":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].mothertongue2_code);
          }
        } break;
      case "mothertongue3_code":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].mothertongue3_code);
          }
        } break;
      case "dgp_code":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].dgp_code);
          }
        } break;
      case "address":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].address);
          }
        } break;
      case "zone_code":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].zone_code);
          }
        } break;
      case "url_address":
        for (int i = 0; i < AllSchoolList.length; i++){
          if (AllSchoolList[i].school_name == school_name)
          {
            return(AllSchoolList[i].url_address);
          }
        } break;
      default: print("Second variable that is passed in is not valid");
    }
    return(AllSchoolList[0].url_address);
  }


//Classes
class School1 {
  String school_name;
  String fax_no;
  String fax_no_2;
  String postal_code;
  String type_code;
  String principal_name;
  String first_vp_name;
  String second_vp_name;
  String third_vp_name;
  String fourth_vp_name;
  String fifth_vp_name;
  String sixth_vp_name;
  String mainlevel_code;
  String telephone_no;
  String telephone_no_2;
  String email_address;
  String visionstatement_desc;
  String missionstatement_desc;
  String philosophy_culture_ethos;
  String mrt_desc;
  String bus_desc;
  String special_sdp_offered;
  String mothertongue1_code;
  String mothertongue2_code;
  String mothertongue3_code;
  String dgp_code;
  String address;
  String zone_code;
  String url_address;

  School1(this.school_name, this.address, this.bus_desc, this.dgp_code,
      this.email_address,
      this.fax_no, this.fax_no_2, this.fifth_vp_name, this.first_vp_name,
      this.fourth_vp_name,
      this.mainlevel_code, this.missionstatement_desc, this.mothertongue1_code,
      this.mothertongue2_code,
      this.mothertongue3_code, this.mrt_desc, this.philosophy_culture_ethos,
      this.postal_code,
      this.principal_name, this.second_vp_name, this.sixth_vp_name,
      this.special_sdp_offered,
      this.telephone_no, this.telephone_no_2, this.third_vp_name,
      this.type_code, this.url_address,
      this.visionstatement_desc, this.zone_code);
}

class MoreInfo extends StatelessWidget {
  Future<List<School1>> fetchSchools() async{
    Future<List<School1>> allSchool = _getSchools();
    return allSchool;
  }

  @override
  Widget build(BuildContext context) {
    Future<List<School1>> allSchools = fetchSchools();
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Schools'),
        actions: <Widget>[
          Container(
              child: FutureBuilder<List<School1>>(
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
                            title: Text('test'),
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

  List<School1> allSchools;

  DataSearch(this.allSchools);

  List<String> convertList(List<School1> allSchools) {
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
            title: Text('test'),

          ),
      itemCount: suggestionList.length,
    );
  }
}



