import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import '../BACK_END_INTERFACE.dart';
import 'Login_info.dart';
String username,pass;
class ChangePass extends StatefulWidget {
  //
  Login_info lg;
  ChangePass({Key key,this.lg}) : super(key:key);

  final String title = 'School Finder';

  @override
  ChangePassState createState() => ChangePassState();
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

class ChangePassState extends State<ChangePass> {

  GlobalKey<ScaffoldState> _scaffoldKey;
  // controller for the First Name TextField we are going to create.
  TextEditingController _PasswordController;
  TextEditingController _PasswordController2;
  //TextEditingController _emailController;
  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _PasswordController2 = TextEditingController();
    _PasswordController = TextEditingController();
    //_emailController = TextEditingController();
  }
  _ChangePassword() async {
    await BACK_END.UpdatePassword(username, _PasswordController.text).then((check) {
      print(check.toString());
    });
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
              label: Text('Password'),
            ),
            DataColumn(
              label: Text('Re-Enter Password'),
            ),
          ],
        ),
      ),
    );
  }

  static int count =0;
  @override
  Widget build(BuildContext context) {
    final Login_info lg1=ModalRoute.of(context).settings.arguments;
    if(lg1!=null)
    {
      username=lg1.username;
      pass=lg1.Password;

    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("School Finder"), // we show the progress in the title...
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                'Change Password',
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
                  child: Text('New Password'),
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
                    controller: _PasswordController,
                    decoration: InputDecoration.collapsed(hintText: 'New Password'),
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
                  child: Text('Re-type Password'),
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
                    controller: _PasswordController2,
                    decoration: InputDecoration.collapsed(hintText: 'Re-type Password'),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Column(
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
                        print(username);
                        await BACK_END.UpdatePassword(username, _PasswordController.text).then((check) {
                          print(check.toString());
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

                                          "\nSuccess!",
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
                                              Navigator.pushNamed(
                                                context,
                                                '/settings',
                                                arguments: Login_info(username, pass),
                                              );
                                            }
                                            ),),
                                      ),                                          SizedBox(height: 5,width: 10),

                                    ],
                                  ),

                                ),

                              );
                            },
                          );
                        });

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
                        "Go Back",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/settings',
                          arguments: Login_info(username, pass),
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