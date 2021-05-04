import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'dart:async';
import '../BACK_END_INTERFACE.dart';
import '../Favourites.dart';
import 'package:tes/FRONT_END/drawer_navigation.dart';
import 'Login_info.dart';
String username, pass;
int count=0;
class FavouritePage extends StatefulWidget {
  //
  final String title = 'School Finder';
  final Login_info lg;
  FavouritePage({Key key,this.lg}) : super(key:key);
  @override
  FavouritePageState createState() => FavouritePageState();
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

class FavouritePageState extends State<FavouritePage> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  List<FAVOURITES> favourites;

  String _titleProgress;
  bool is_liked;
  final _debouncer = Debouncer(milliseconds: 2000);

  @override
  void initState() {
    super.initState();
    favourites=[];
    _titleProgress = widget.title;
    is_liked=false;
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
  // Now lets add an Employee
  _addFAVOURITES(String SchoolName) {
    BACK_END.addFavourite(username, SchoolName).then((check){
      print(check.toString());
    });
  }

  Future<List<FAVOURITES>> _getFAV() async {
    await BACK_END.getallforuser(username).then((users) {
      setState(() {
        favourites = users;
      });
    });
    return favourites;
  }
  Future<bool> deleteFAV(bool isLiked,String SchoolName) async {
    if(isLiked) {
      await BACK_END.DELFAV(username,SchoolName).then((check) {
        print("####" + check.toString());
      });
    }
    else
    {
      _addFAVOURITES(SchoolName);
    }
    return !isLiked;
  }


  @override
  Widget build(BuildContext context) {
    _getFAV();

    final Login_info lg1=ModalRoute.of(context).settings.arguments;
    if(lg1!=null)
    {
      username=lg1.username;
      pass=lg1.Password;

    }
    //final List<String> school = <String>['A', 'B', 'C', 'C', 'C', 'C', 'C', 'C', 'C', 'C', 'C', 'C', 'C', 'C', 'A'];
    final Map<int, String> school = new Map();
    if(favourites==null)
    {
      school[0]="";
    }
    else
    {
      for(int i=0;i<favourites.length;i++)
      {
        school[i] = favourites[i].SchoolName;
      }
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress), // we show the progress in the title...
      ),
      drawer: DrawerNavigation(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, //if dont include this, default appear at the top of screen
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5), //space offset from the left edge of the screen
                child: FutureBuilder<List<FAVOURITES>>(
                    future: _getFAV(),
                    builder: (context, snapshot){
                      if (snapshot.hasData) {
                        return ListView.builder(
                            padding: const EdgeInsets.all(8),
                            shrinkWrap: true,
                            itemCount: school.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              int key = school.keys.elementAt(index);
                              return Card(
                                child: Container(

                                    margin: const EdgeInsets.only(left: 10.0, right: 10),
                                    child: Row(
                                        children: <Widget>[

                                          Text('${key+1})', //change to $variable to set dist
                                            style: TextStyle(

                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          Expanded(
                                            child: FlatButton(
                                              padding: EdgeInsets.all(5),
                                              onPressed: () { },//go to school page
                                              child: Align(alignment: Alignment.centerLeft,
                                                child: Text('${school[key]} ', //change to $variable to set dist
                                                  style: TextStyle(

                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          LikeButton(
                                            isLiked: true,
                                            onTap: (bool isLiked) {
                                              return deleteFAV(isLiked,school[key]);
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.arrow_forward_ios_rounded),
                                            onPressed: (){ Navigator.pushNamed(context, '/Moreinfo',
                                              arguments: More_info(username,pass,school[key]),
                                            );},

                                          ),

                                        ]
                                    )
                                ),
                              );

                            }
                        );
                      }

                      else
                      {
                        return Center(child: CircularProgressIndicator());
                      }
                    }

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}