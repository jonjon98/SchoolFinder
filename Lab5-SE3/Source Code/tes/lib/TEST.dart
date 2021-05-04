import 'package:flutter/material.dart';
import 'package:tes/Comment.dart';
import 'package:tes/CommentDBMgr.dart';
import 'package:tes/Report.dart';
import 'user.dart';
import 'dart:async';
import 'InterfaceUsrDB.dart';
import 'userDBMgr.dart';
import 'BACK_END_INTERFACE.dart';
import 'Favourites.dart';
class TEST extends StatefulWidget {
  //
  TEST() : super();

  final String title = 'Flutter Data Table';

  @override
  TESTState createState() => TESTState();
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

class TESTState extends State<TEST> {
  List<COMMENT> _users;
  // this list will hold the filtered employees
  List<COMMENT> _filterUsers;
  GlobalKey<ScaffoldState> _scaffoldKey;
  // controller for the First Name TextField we are going to create.
  TextEditingController _userNameController;
  // controller for the Last Name TextField we are going to create.
  TextEditingController _MessageController;
  TextEditingController _SchoolNameController;
  TextEditingController _RatingController;
  COMMENT _selectedUser;
  bool _isUpdating;
  String _titleProgress;
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
    _users = [];
    _filterUsers = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _userNameController = TextEditingController();
    _MessageController = TextEditingController();
    _SchoolNameController = TextEditingController();
    _RatingController = TextEditingController();

    //_emailController = TextEditingController();
    //_getUsers();
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
  _addComment() {
    if (_userNameController.text.isEmpty || _MessageController.text.isEmpty || _SchoolNameController.text.isEmpty || _RatingController.text.isEmpty) {
      print('Empty Fields');
      return;
    }
    _showProgress('Adding FAVOURITE...');
    BACK_END.addComment(_userNameController.text, _MessageController.text,_SchoolNameController.text,_RatingController.text).then((check){
      print(check.toString());
      // _getREPORT();
    });
  }
  _geALL() {
    _showProgress('Loading Employees...');
    BACK_END.getAllComments().then((users) {
      setState(() {
        _users = users;
        _filterUsers = users;
      });
      _showProgress(widget.title); // Reset the title...
      print("Length ${_users.length}");
      print(_users[0].username);
    });
  }
  _getCOMMENTS() {
    _showProgress('Loading Comments...');
    BACK_END.getAllForOneSchool(_SchoolNameController.text).then((users) {
      setState(() {
        _users = users;
        _filterUsers = users;
      });
      _showProgress(widget.title); // Reset the title...
      print("Length ${users.length}");
    });
  }
  _getavg()
  {
    if (_SchoolNameController.text.isEmpty) {
      print('Empty Fields');
      return;
    }
    _showProgress('AVG ...');
    BACK_END.Get_avg(_SchoolNameController.text).then((check){
      print(check.toString());
      // _getREPORT();
      print(check.toString());
    });
  }

  // Method to clear TextField values
  _clearValues() {
    _userNameController.text = '';
    _MessageController.text = '';
    //_emailController.text= '';
  }

  _showValues(COMMENT FAV) {
    _userNameController.text = FAV.username;
    _MessageController.text = FAV.Message;
    _SchoolNameController.text = FAV.SchoolName;
    _RatingController.text=FAV.rating;
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
              label: Text('Message'),
            ),
            DataColumn(
              label: Text('School Name'),
            ),
            // Lets add one more column to show a delete button
            DataColumn(
              label: Text('Rating'),
            )
          ],
          // the list should show the filtered list now
          rows: _users.map(
                (user) => DataRow(cells: [
              DataCell(
                Text(user.username?? 'default value'),
                // Add tap in the row and populate the
                // textfields with the corresponding values to update
                onTap: () {
                  _showValues(user);
                  // Set the Selected employee to Update
                  _selectedUser = user;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                Text(
                    user.Message ?? 'default value')
                ,
                onTap: () {
                  _showValues(user);
                  // Set the Selected employee to Update
                  _selectedUser = user;
                  // Set flag updating to true to indicate in Update Mode
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                Text(
                    user.SchoolName?? 'default value'
                ),
                onTap: () {
                  _showValues(user);
                  // Set the Selected employee to Update
                  _selectedUser = user;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                Text(
                    user.rating ?? 'default value'
                ),
                onTap: () {
                  _showValues(user);
                  // Set the Selected employee to Update
                  _selectedUser = user;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              //   DataCell(IconButton(
              // icon: Icon(Icons.delete),
              // onPressed: () {
              //_deleteUser(user);
              // },
              //))
            ]),
          )
              .toList(),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress), // we show the progress in the title...
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              //_createTable();
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _geALL();
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _userNameController,
                decoration: InputDecoration.collapsed(
                  hintText: 'UserName',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _MessageController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Password',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _SchoolNameController,
                decoration: InputDecoration.collapsed(
                  hintText: 'School Name',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _RatingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Rating (1-5)',
                ),
              ),
            ),
            // Add an update button and a Cancel Button
            // show these buttons only when updating an employee
            _isUpdating
                ? Row(
              children: <Widget>[
                OutlineButton(
                  child: Text('UPDATE'),
                  onPressed: () {
                    // _updatePassword(_selectedUser);
                  },
                ),
                OutlineButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    setState(() {
                      _isUpdating = false;
                    });
                    _clearValues();
                  },
                ),
              ],
            )
                : Container(),
            //searchField(),
            Expanded(
              child: _dataBody(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getavg();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}