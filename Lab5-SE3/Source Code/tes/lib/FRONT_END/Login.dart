import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../user.dart';
import 'dart:async';
import '../InterfaceUsrDB.dart';
import '../userDBMgr.dart';
import '../BACK_END_INTERFACE.dart';
import '../Favourites.dart';
import 'package:tes/FRONT_END/drawer_navigation.dart';
import 'dart:io';

import 'Login_info.dart';


class LoginScreen extends StatefulWidget {
  //
  LoginScreen() : super();

  final String title = 'School Finder';

  @override
  LoginScreenState createState() => LoginScreenState();
}

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

class LoginScreenState extends State<LoginScreen> {

  GlobalKey<ScaffoldState> _scaffoldKey;
  // controller for the First Name TextField we are going to create.
  TextEditingController _userNameController;
  bool updating_loginCheck;
  // controller for the Last Name TextField we are going to create.
  TextEditingController _PasswordController;
  //TextEditingController _emailController;
  bool _isUpdating;
  String _titleProgress;
  bool loginCheck;
  // This will wait for 500 milliseconds after the user has stopped typing.
  // This puts less pressure on the device while searching.
  // If the search is done on the server while typing, it keeps the
  // server hit down, thereby improving the performance and conserving
  // battery life...
  final _debouncer = Debouncer(milliseconds: 2000);
  // Lets increase the time to wait and search to 2 seconds.
  // So now its searching after 2 seconds when the user stops typing...
  // That's how we can do filtering in Flutter DataTables.

  @override
  void initState() {
    super.initState();
    _isUpdating = false;
    _titleProgress = widget.title;
    loginCheck = true;
    updating_loginCheck=false;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _userNameController = TextEditingController();
    _PasswordController = TextEditingController();
    //_emailController = TextEditingController();
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
  _LoginCheck()  async {

    if (_userNameController.text.isEmpty || _PasswordController.text.isEmpty) {
      print('Empty Fields');
      setState(() {
        loginCheck = false;
      });      return;
    }
    _showProgress('CHECKING User...');
    await BACK_END.LoginCheck(_userNameController.text, _PasswordController.text).then((check){
      setState(() {
        loginCheck = check;
        print(check.toString());
        if (loginCheck== null)
        {
          loginCheck=false;
        }
        print("YESSS\n");
        print(loginCheck.toString());
        updating_loginCheck = false;
      });
    });

  }


  // Method to clear TextField values
  _clearValues() {
    _userNameController.text = '';
    _PasswordController.text = '';
    //_emailController.text= '';
  }

  _showValues(USER U) {
    _userNameController.text = U.username;
    _PasswordController.text = U.password;
    //_emailController.text = user.email;
  }

// Since the server is running locally you may not
// see the progress in the titlebar, its so fast...
// :)

  // Let's create a DataTable and show the employee list in it.
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
              label: Text('Password'),
            ),
          ],
        ),
      ),
    );
  }

  // Let's add a searchfield to search in the DataTable.
  /*searchField() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(5.0),
          hintText: 'Filter by First name or Last name',
        ),
        onChanged: (string) {
          // We will start filtering when the user types in the textfield.
          // Run the debouncer and start searching
          _debouncer.run(() {
            // Filter the original List and update the Filter list
            setState(() {
              _filterUsers = _users
                  .where((u) => (u.username
                  .toLowerCase()
                  .contains(string.toLowerCase()) ||
                  u.password.toLowerCase().contains(string.toLowerCase())))
                  .toList();
            });
          });
        },
      ),
    );
  }
*/
  // id is coming as String
  // So let's update the model...

  // UI
  static int count =0;
  @override
  Widget build(BuildContext context) {
    bool ch;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress), // we show the progress in the title...
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                'Sign In',
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
            Container(
              margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 35.0),
              child:Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.all(0.0),
                  child:GestureDetector(
                    onTap:(){Navigator.pushNamed(context, '/forgotpass');},
                    child: Text("Forgot Password?"),
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
                        await _LoginCheck();

                        if(loginCheck == true && updating_loginCheck==false){
                          Navigator.pushNamed(
                            context,
                            '/searchLandingPage',
                            arguments : Login_info(_userNameController.text,_PasswordController.text),
                          );
                        }
                        else{
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                elevation: 16,
                                child: Container(
                                  height: 150.0,
                                  width: 360.0,
                                  child: ListView(
                                    children: <Widget>[
                                      SizedBox(height: 10),
                                      Center(
                                        child: Text(

                                          "\nINVALID LOGIN",
                                          style: TextStyle(fontSize: 24, color: Colors.blue, fontWeight: FontWeight.bold),
                                        ),

                                      ),
                                      SizedBox(height: 5,width: 10),
                                      ButtonTheme(
                                        padding: new EdgeInsets.all(100.0),
                                        minWidth: 0.0,
                                        height: 50.0,
                                        child:Container(
                                          padding: new EdgeInsets.only(left:50,right:50),
                                          height: 50.0,
                                          width: 25.0,
                                          child:
                                          RaisedButton(
                                            padding: new EdgeInsets.all(0.0),
                                            color:Colors.blueAccent,
                                            shape:RoundedRectangleBorder(

                                              borderRadius: BorderRadius.circular(16.0),
                                            ),
                                            child: Text(
                                              "BACK",
                                              style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: (){
                                              Navigator.pop(context
                                              );                                            },
                                          ),),
                                      ),                                          SizedBox(height: 5,width: 10),

                                    ],
                                  ),

                                ),

                              );
                            },
                          );
                        }

                        // Navigator.pushNamed(
                        //   context,
                        //   '/searchLandingPage',
                        //   arguments : Login_info('hello','password'),
                        // );
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
                  SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signUpPage');
                    },
                    child: Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(decoration: TextDecoration.underline),
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