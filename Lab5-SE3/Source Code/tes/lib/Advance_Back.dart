import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'Schools.dart';

//first we should make a function to fetch the length of the data
Future<int> fetchLength(String url) async{
  int totalRecords;
  var response = await http.get(url);

  if (response.statusCode == 200) {
    String data = response.body;
    totalRecords = jsonDecode(data)['result']['total'];
  } else {
    print('Response statusCode: ${response.statusCode}');
    throw Exception('Failed to fetch data');
  }

  return totalRecords;
}

String convert(String filter){
  String filStrUpper = filter.toUpperCase();
  List<String> filStr = filStrUpper.split(' ');

  String filteredStr = filStr.join("%20");

  return filteredStr;
}

List<Schools> mergeTwoList(List<Schools> list1, List<Schools> list2){
  Set<Schools> output = new Set();
  list1.forEach((element) => output.add(element));
  list2.forEach((element) => output.add(element));
  return output.toList();
}

//do one more function call fetch api and store in a future list based on url
Future<List<Schools>> fetchSchoolName(String url) async{
  var response = await http.get(url);
  int length = await fetchLength(url);

  if (response.statusCode == 200) {
    var schools = jsonDecode(response.body)['result']['records'];
    // print(schools);
    Set<Schools> schoolNameSet = new Set();
    for (var i in schools){
      Schools school = Schools(i['school_name'], i['zone_code']);
      schoolNameSet.add(school);
    }
    schoolNameSet.forEach((element) => print(element));

    List<Schools> schoolName = schoolNameSet.toList();
    return schoolName;
  } else {
    print('Response statusCode: ${response.statusCode}');
    throw Exception('Failed to fetch data');
  }
}

//implement one function to compare two list and remove duplicate on two list
Future<List<Schools>> fetchBasedOnCriteria(String level, String subjectCombination, String CCA_Category, String CCA_Name) async {
  var url;
  var subjectUrl;
  var levelUrl;

  if (level == null && subjectCombination == null && CCA_Category == null &&
      CCA_Name == null) {
    //fetch all school name
    url =
    'https://data.gov.sg/api/action/datastore_search?resource_id=ede26d32-01af-4228-b1ed-f05c45a1d8ee&fields=school_name';
    Future<List<Schools>> allSchool = fetchSchoolName(url);
    //print(allSchool);
    return allSchool;
  }

  if (level == null) {
    if (subjectCombination == null) {
      if (CCA_Category == null) {
        if (CCA_Name != null) {
          //this if only return for those enter CCA_Name field only
          String convertedCcaName = convert(CCA_Name);
          url =
          'https://data.gov.sg/api/action/datastore_search?resource_id=dd7a056a-49fa-4854-bd9a-c4e1a88f1181&filters=%7B%22cca_generic_name%22%3A%20%22${convertedCcaName}%22%7D';
          Future<List<Schools>> allSchool = fetchSchoolName(url);
          //0001
          return allSchool;
        }
        else {
          //this else return those who never enter anything for all fields
          url =
          'https://data.gov.sg/api/action/datastore_search?resource_id=ede26d32-01af-4228-b1ed-f05c45a1d8ee&fields=school_name';
          Future<List<Schools>> allSchool = fetchSchoolName(url);
          //print(allSchool);
          //0000
          return allSchool;
        }
      }
      else {
        //this else return for those CCA_Category not leave empty
        if (CCA_Name != null) {
          String convertedCcaCategory = convert(CCA_Category);
          String convertedCcaName = convert(CCA_Name);

          url =
          'https://data.gov.sg/api/action/datastore_search?resource_id=dd7a056a-49fa-4854-bd9a-c4e1a88f1181&filters=%7B%22cca_generic_name%22%3A%20%22${convertedCcaName}%22%2C%20%22cca_grouping_desc%22%3A%20%22${convertedCcaCategory}%22%7D';

          Future<List<Schools>> allSchool = fetchSchoolName(url);
          //0011
          return allSchool;
        }
        else {
          //if CCA_Name is null while CCA_Category is not Null
          String convertedCcaCategory = convert(CCA_Category);
          url =
          'https://data.gov.sg/api/action/datastore_search?resource_id=dd7a056a-49fa-4854-bd9a-c4e1a88f1181&filters=%7B%2cca_grouping_desc%22%3A%20%22${convertedCcaCategory}%22%7D';

          Future<List<Schools>> allSchool = fetchSchoolName(url);
          //0010
          return allSchool;
        }
      }
    }
    //if subject Combination is not null
    else {
      //fetched based on subjectCombination
      String convertedSubject = convert(subjectCombination);
      subjectUrl =
      'https://data.gov.sg/api/action/datastore_search?resource_id=3bb9e6b0-6865-4a55-87ba-cc380bc4df39&filters=%7B%22subject_desc%22%3A%20%22${convertedSubject}%22%7D';
      List<Schools> allSchoolBasedOnSubject = await fetchSchoolName(subjectUrl);
      if (CCA_Category == null) {
        if (CCA_Name != null) {
          //this if only return for those enter CCA_Name field only
          String convertedCcaName = convert(CCA_Name);
          url =
          'https://data.gov.sg/api/action/datastore_search?resource_id=dd7a056a-49fa-4854-bd9a-c4e1a88f1181&filters=%7B%22cca_generic_name%22%3A%20%22${convertedCcaName}%22%7D';
          List<Schools> allSchool = await fetchSchoolName(url);
          //here we have 2 list of school name list, we need to perform merging on two list
          List<Schools> mergedSchoolName = mergeTwoList(
              allSchoolBasedOnSubject, allSchool);

          //0101
          return mergedSchoolName;
        }
        else {
          //this else return those who never enter anything for all fields
          //0100
          return allSchoolBasedOnSubject;
        }
      }
      else {
        //this else return for those CCA_Category not leave empty
        if (CCA_Name != null) {
          String convertedCcaCategory = convert(CCA_Category);
          String convertedCcaName = convert(CCA_Name);
          url =
          'https://data.gov.sg/api/action/datastore_search?resource_id=dd7a056a-49fa-4854-bd9a-c4e1a88f1181&filters=%7B%22cca_generic_name%22%3A%20%22${convertedCcaName}%22%2C%20%22cca_grouping_desc%22%3A%20%22${convertedCcaCategory}%22%7D';

          List<Schools> allSchool = await fetchSchoolName(url);
          List<Schools> mergedSchoolName = mergeTwoList(
              allSchoolBasedOnSubject, allSchool);
          //0111
          return mergedSchoolName;
        }
        else {
          //if CCA_Name is null while CCA_Category is not Null
          String convertedCcaCategory = convert(CCA_Category);
          url =
          'https://data.gov.sg/api/action/datastore_search?resource_id=dd7a056a-49fa-4854-bd9a-c4e1a88f1181&filters=%7B%2cca_grouping_desc%22%3A%20%22${convertedCcaCategory}%22%7D';

          List<Schools> allSchool = await fetchSchoolName(url);
          List<Schools> mergedSchoolName = mergeTwoList(
              allSchoolBasedOnSubject, allSchool);
          //0110
          return mergedSchoolName;
        }
      }
    }
  }
  else {
    //if level is not null, we need to pass in the level to the filter
    String convertedLevel = convert(level);
    levelUrl =
    'https://data.gov.sg/api/action/datastore_search?resource_id=ede26d32-01af-4228-b1ed-f05c45a1d8ee&filters=%7B%22mainlevel_code%22%3A%20%22${convertedLevel}%22%7D';
    List<Schools> allSchoolBasedOnLevel = await fetchSchoolName(levelUrl);

    if (subjectCombination == null) {
      if (CCA_Category == null) {
        if (CCA_Name != null) {
          //this if only return for those enter CCA_Name field only
          String convertedCcaName = convert(CCA_Name);
          url =
          'https://data.gov.sg/api/action/datastore_search?resource_id=dd7a056a-49fa-4854-bd9a-c4e1a88f1181&filters=%7B%22cca_generic_name%22%3A%20%22${convertedCcaName}%22%7D';
          List<Schools> allSchool = await fetchSchoolName(url);
          List<Schools> mergedSchool = mergeTwoList(
              allSchool, allSchoolBasedOnLevel);
          //1001
          return mergedSchool;
        }
        else {
          //this else return those who never enter anything for all fields
          //1000
          return allSchoolBasedOnLevel;
        }
      }
      else {
        //this else return for those CCA_Category not leave empty
        if (CCA_Name != null) {
          String convertedCcaCategory = convert(CCA_Category);
          String convertedCcaName = convert(CCA_Name);

          url =
          'https://data.gov.sg/api/action/datastore_search?resource_id=dd7a056a-49fa-4854-bd9a-c4e1a88f1181&filters=%7B%22cca_generic_name%22%3A%20%22${convertedCcaName}%22%2C%20%22cca_grouping_desc%22%3A%20%22${convertedCcaCategory}%22%7D';

          List<Schools> allSchool = await fetchSchoolName(url);
          List<Schools> mergedSchool = mergeTwoList(
              allSchool, allSchoolBasedOnLevel);
          //1011
          return mergedSchool;
        }
        else {
          //if CCA_Name is null while CCA_Category is not Null
          String convertedCcaCategory = convert(CCA_Category);
          url =
          'https://data.gov.sg/api/action/datastore_search?resource_id=dd7a056a-49fa-4854-bd9a-c4e1a88f1181&filters=%7B%2cca_grouping_desc%22%3A%20%22${convertedCcaCategory}%22%7D';

          List<Schools> allSchool = await fetchSchoolName(url);
          List<Schools> mergedSchool = mergeTwoList(
              allSchool, allSchoolBasedOnLevel);
          //1010
          return mergedSchool;
        }
      }
    }
    //if subject Combination is not null
    else {
      //fetched based on subjectCombination
      String convertedSubject = convert(subjectCombination);
      subjectUrl =
      'https://data.gov.sg/api/action/datastore_search?resource_id=3bb9e6b0-6865-4a55-87ba-cc380bc4df39&filters=%7B%22subject_desc%22%3A%20%22${convertedSubject}%22%7D';
      List<Schools> allSchoolBasedOnSubject = await fetchSchoolName(subjectUrl);
      List<Schools> mergedSubjectAndLevel = mergeTwoList(
          allSchoolBasedOnSubject, allSchoolBasedOnLevel);
      if (CCA_Category == null) {
        if (CCA_Name != null) {
          //this if only return for those enter CCA_Name field only
          String convertedCcaName = convert(CCA_Name);
          url =
          'https://data.gov.sg/api/action/datastore_search?resource_id=dd7a056a-49fa-4854-bd9a-c4e1a88f1181&filters=%7B%22cca_generic_name%22%3A%20%22${convertedCcaName}%22%7D';
          List<Schools> allSchool = await fetchSchoolName(url);
          //here we have 2 list of school name list, we need to perform merging on two list
          List<Schools> mergedSchoolName = mergeTwoList(
              mergedSubjectAndLevel, allSchool);
          //1101
          return mergedSchoolName;
        }
        else {
          //this else return those who never enter anything for all fields
          //1100
          return mergedSubjectAndLevel;
        }
      }
      else {
        //this else return for those CCA_Category not leave empty
        if (CCA_Name != null) {
          String convertedCcaCategory = convert(CCA_Category);
          String convertedCcaName = convert(CCA_Name);
          url =
          'https://data.gov.sg/api/action/datastore_search?resource_id=dd7a056a-49fa-4854-bd9a-c4e1a88f1181&filters=%7B%22cca_generic_name%22%3A%20%22${convertedCcaName}%22%2C%20%22cca_grouping_desc%22%3A%20%22${convertedCcaCategory}%22%7D';

          List<Schools> allSchool = await fetchSchoolName(url);
          List<Schools> mergedSchoolName = mergeTwoList(
              mergedSubjectAndLevel, allSchool);
          //1111
          return mergedSchoolName;
        }
        else {
          //if CCA_Name is null while CCA_Category is not Null
          String convertedCcaCategory = convert(CCA_Category);
          url =
          'https://data.gov.sg/api/action/datastore_search?resource_id=dd7a056a-49fa-4854-bd9a-c4e1a88f1181&filters=%7B%2cca_grouping_desc%22%3A%20%22${convertedCcaCategory}%22%7D';

          List<Schools> allSchool = await fetchSchoolName(url);
          List<Schools> mergedSchoolName = mergeTwoList(
              mergedSubjectAndLevel, allSchool);
          //1110
          return mergedSchoolName;
        }
      }
    }
  }
}
