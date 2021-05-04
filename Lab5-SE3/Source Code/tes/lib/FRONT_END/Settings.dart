import 'package:flutter/material.dart';
import 'dart:async';
import 'package:tes/FRONT_END/drawer_navigation.dart';
import 'Login_info.dart';
String username,pass;
class Settings extends StatefulWidget {
  //
  final Login_info lg;
  final String title = 'School Finder';
  Settings({Key key,this.lg}) : super(key:key);
  @override
  SettingsState createState() => SettingsState();
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

class SettingsState extends State<Settings> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _titleProgress;
  final _debouncer = Debouncer(milliseconds: 2000);
  @override
  void initState() {
    super.initState();
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
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
              label: Text('School Name'),
            ),
          ],
        ),
      ),
    );
  }
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
        title: Text(_titleProgress), // we show the progress in the title...
      ),
      drawer: DrawerNavigation(),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ButtonTheme(
              minWidth: 250.0,
              height: 100.0,
              child: RaisedButton(
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/ChangePass',
                  arguments: Login_info(username,pass),
                  );
                },
                child: Text("Change Password",
                    style: TextStyle(fontSize: 20)),
              ),
            ),
            SizedBox(height: 20),
            ButtonTheme(
              minWidth: 250.0,
              height: 100.0,
              shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/ChangeEmail',
                    arguments: Login_info(username,pass),
                  );},
                child: Text(
                    "Change Email",
                    style: TextStyle(fontSize: 20)),
              ),
            ),
            SizedBox(height: 20),
            ButtonTheme(
              minWidth: 250.0,
              height: 100.0,
              shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: RaisedButton(
                onPressed: () {Navigator.pushNamed(context, '/ChangePostal',
                  arguments: Login_info(username,pass),
                );
                },
                child: Text("Change Postal Code",
                    style: TextStyle(fontSize: 20)),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}