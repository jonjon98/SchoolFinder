import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tes/FRONT_END/Home.dart';
import 'package:tes/user.dart';
import 'drawer_navigation.dart';
import '../user.dart';
import 'dart:async';
import '../InterfaceUsrDB.dart';
import '../userDBMgr.dart';
import '../BACK_END_INTERFACE.dart';
import '../Favourites.dart';
import 'package:tes/FRONT_END/drawer_navigation.dart';

class Sign_UP extends StatefulWidget {
  //
  Sign_UP() : super();

  final String title = 'School Finder';

  @override
  Sign_UPState createState() => Sign_UPState();
}

// Now we will write a class that will help in searching.
// This is called a Debouncer class.
// I have made other videos explaining about the debouncer classes
// The link is provided in the description or tap the 'i' button on the right corner of the video.
// The Debouncer class helps to add a delay to the search
// that means when the class will wait for the user to stop for a defined time
// and then start searching
// So if the user is continuosly typing without any delay, it wont search
// This helps to keep the app more performant and if the search is directly hitting the server
// it keeps less hit on the server as well.
// Lets write the Debouncer class

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer
          .cancel(); // when the user is continuosly typing, this cancels the timer
    }
    // then we will start a new timer looking for the user to stop
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class Sign_UPState extends State<Sign_UP> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _userNameController;
  TextEditingController _PasswordController;
  TextEditingController _emailController;
  String _titleProgress;
  bool signUpValid;
  final _debouncer = Debouncer(milliseconds: 2000);

  @override
  void initState() {
    super.initState();
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _userNameController = TextEditingController();
    _PasswordController = TextEditingController();
    _emailController = TextEditingController();
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
  // Now lets add an Employee
  _addUSR() async{
    if (_userNameController.text.isEmpty || _PasswordController.text.isEmpty || _emailController.text.isEmpty) {
      print('Empty Fields');
      return;
    }
    _showProgress('Adding User...');
    await BACK_END.adduser(_userNameController.text,_PasswordController.text,_emailController.text) .then((check){
      print(check.toString());
      setState(() {
        signUpValid = true;
      });
    });
  }

  // Method to clear TextField values
  _clearValues() {
    _userNameController.text = '';
    _PasswordController.text = '';
    _emailController.text= '';
  }

  _showValues(USER U) {
    _userNameController.text = U.username;
    _PasswordController.text = U.password;
    _emailController.text = U.email;
  }
  SingleChildScrollView _dataBody() {
    // Both Vertical and Horozontal Scrollview for the DataTable to
    // scroll both Vertical and Horizontal...
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('USERNAME'),
            ),
            DataColumn(
              label: Text('PASSWORD'),
            ),
            DataColumn(
              label: Text('EMAIL'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress), // we show the progress in the title...
      ),
      drawer: null,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: Color.fromARGB(255, 53, 83, 137),
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
            ),
            SizedBox(
              height: 60.0,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 35.0),
              child:Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Text('Username'),
                ),
              ),
            ),
            Container(
              height: 80.0,
              child:Card(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _userNameController,
                    decoration: InputDecoration.collapsed(hintText: 'Enter Your Username'),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 35.0),
              child:Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Text('Password'),
                ),
              ),
            ),
            Container(
              height: 80.0,
              child:Card(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    obscureText: true,
                    controller: _PasswordController,
                    decoration: InputDecoration.collapsed(hintText: 'Enter Your Password'),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 35.0),
              child:Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Text('Email'),
                ),
              ),
            ),
            Container(
              height: 80.0,
              child:Card(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration.collapsed(hintText: 'Enter Your Email'),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ButtonTheme(
                    minWidth: 200.0,
                    height: 50.0,
                    child:RaisedButton(
                      color:Colors.blueAccent,
                      shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                      onPressed: ()  async {
                        await _addUSR();
                        if( signUpValid)
                        {
                          Navigator.pushNamed(
                            context,
                            '/',
                          );
                        }
                        else
                        {
                          //add invalid pop up
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  ButtonTheme(
                    minWidth: 200.0,
                    height: 50.0,
                    child:RaisedButton(
                      color:CupertinoColors.systemGrey3,
                      shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/',
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}