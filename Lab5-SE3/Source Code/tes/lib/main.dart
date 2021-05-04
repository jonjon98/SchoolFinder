import 'package:flutter/material.dart';
import 'package:tes/FRONT_END/Home.dart';
import 'package:tes/FRONT_END/Login.dart';
import 'FRONT_END/Comments.dart';
import 'FRONT_END/ForgotPassword.dart';
import 'FRONT_END/Sign_up.dart';
import 'FRONT_END/searchLandingPage.dart';
import 'FRONT_END/SeachPage.dart';
import 'TEST.dart';
import 'advanceSearch/advanceSearch.dart';
import 'package:tes/FRONT_END/More_info.dart';
import 'FRONT_END/FavouritesList.dart';
import 'FRONT_END/Settings.dart';
import 'FRONT_END/changePassword.dart';
import 'FRONT_END/changeEmail.dart';
import 'FRONT_END/ChangePostal.dart';
import 'FRONT_END/AdvancedSearchPage.dart';
void main() {
  runApp(new HomeApp());
}


class HomeApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/':(context) => FirstPage(),
        '/login': (context) => LoginScreen(),
        '/searchLandingPage' : (context) => SearchLandingScreen(),
        '/signUpPage' :(context) => Sign_UP(),
        '/search' : (context) => SchoolList2(),
        '/advancedSearchlist' : (context) => SchoolListAdvanced(),
        '/advancedSearch' : (context) => AdvancedSearchScreen(),
        '/Moreinfo' : (context) => More_INFO(),
        '/Favourites' : (context) => FavouritePage(),
        '/settings' : (context) => Settings(),
        '/ChangePass': (context) => ChangePass(),
        '/ChangeEmail': (context) => ChangeEmail(),
        '/ChangePostal': (context) => ChangePostal(),
        '/Comments' : (context) => Comments(),
        '/forgotpass' : (context) => forgotPass(),
      },
    );
  }
}