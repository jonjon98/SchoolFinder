import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:tes/FRONT_END/More_info.dart';
import 'package:tes/Rating.dart';
import 'dart:async';
import 'package:tes/front_end/drawer_navigation.dart';
import '../BACK_END_INTERFACE.dart';
import 'package:tes/FRONT_END/Login_info.dart';
import '../Comment.dart';



String username,Schoolname;
class Comments extends StatefulWidget {
  More_info mg;
  Comments({Key key,this.mg}) : super(key : key);  @override
  CommentsState createState() => CommentsState();
}

class CommentsState extends State<Comments> {

  GlobalKey<ScaffoldState> _scaffoldKey;
  String _titleProgress = 'progress'; //show progress
  List<COMMENT> comments;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static String schName; //from database (if not static will have error) need help

  double userRating; //user rating (pass this to db)
  String userComment; //user comment (pass this to db)

  String userReport; //user report (pass this to db)

  //from database
  void initState() {
    super.initState();
    comments=[];
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
  }
  Future<void> writeReview(BuildContext context) async {
    return await showDialog(context: context,
        builder: (context){
          final TextEditingController _textEditingController = TextEditingController();

          return StatefulBuilder(builder: (context,setState){
            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _textEditingController,
                        validator: (value){
                          return value.isNotEmpty ? null : "Invalid Field";
                        },
                        decoration: InputDecoration(hintText: "Enter comment"),
                        onSaved: (String value){
                          userComment = value; //save the comment
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Rating:"),
                          SmoothStarRating(
                            //rating: , //pass in sch ave rating variable to display
                              starCount: 5,
                              allowHalfRating: true,
                              //isReadOnly:true,
                              color: Colors.yellow,
                              borderColor: Colors.yellow,
                              spacing:0.0,
                              size: 35,
                              onRated: (value){
                                userRating = value; //save the rating

                              }
                          )
                        ],
                      )
                    ],
                  )),
              actions: <Widget>[
                TextButton(
                  child: Text('Submit'),
                  onPressed: (){
                    BACK_END.addComment(username, _textEditingController.text, Schoolname,userRating.toString());
                    if(_formKey.currentState.validate()){
                      // Do something like updating SharedPreferences or User Settings etc.
                      Navigator.of(context).pop();
                    }
                    _formKey.currentState.save(); //save the form
                    print(userComment);  //check if data is saved
                    print(userRating);

                  },
                ),
              ],
            );
          });
        });

  }

  Future<void> report(BuildContext context) async {
    return await showDialog(context: context,
        builder: (context){
          final TextEditingController _textEditingController = TextEditingController();

          return StatefulBuilder(builder: (context,setState){
            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _textEditingController,
                        validator: (value){
                          return value.isNotEmpty ? null : "Invalid Field";
                        },
                        decoration: InputDecoration(hintText: "Report description"),
                        onSaved: (String value){
                          userReport = value; //save the comment
                        },
                      ),
                    ],
                  )),
              actions: <Widget>[
                TextButton(
                  child: Text('Submit'),
                  onPressed: (){
                    BACK_END.addReport(username, _textEditingController.text);
                    if(_formKey.currentState.validate()){
                      // Do something like updating SharedPreferences or User Settings etc.
                      Navigator.of(context).pop();
                    }
                    _formKey.currentState.save(); //save the form
                    print(userReport);  //check if data is saved


                  },
                ),
              ],
            );
          });
        });

  }

  int count =0;
  // UI
  Future<List<COMMENT>> _getcomments() async {
    await BACK_END.getAllForOneSchool(Schoolname).then((users) {
      setState(() {
        comments = users;
      });
    });
    return comments;
  }

  @override
  Widget build(BuildContext context) {
    final More_info mg1=ModalRoute.of(context).settings.arguments;
    Future<String> aveRating=BACK_END.Get_avg(mg1.SchoolName);

    if(count==0) {
      _getcomments();
      count++;
    }
    final Map<String, List<String>> comms = new Map();
    if(comments==null)
    {
      comms[""]=[""];
      print("######NOOOO");
    }
    else
    {
      for(int i=0;i<comments.length;i++)
      {
        comms["${comments[i].username}"] = [comments[i].rating,comments[i].SchoolName,comments[i].Message];
      }
    }


    Schoolname=mg1.SchoolName;
    username=mg1.username;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("RATING AND COMMENTS"), // we show the progress in the title...
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Container(
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      mg1.SchoolName, //pass in sch name
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      'Ave rating:',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              )
                          ),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FutureBuilder<String>(
                                      future: aveRating,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return
                                            Container(
                                              padding: const EdgeInsets.only(bottom: 8),
                                              child: Text(
                                                "Rating: ${snapshot.data}",
                                                //pass in sch ave rating variable to display
                                                style: TextStyle(
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),

                                            );
                                        }
                                        else
                                        {
                                          return Text("");
                                        }
                                      }
                                  ),
                                  FutureBuilder<String>(
                                    future: aveRating,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return SmoothStarRating(
                                            rating: double.parse(snapshot.data),
                                            //pass in sch ave rating variable to display
                                            starCount: 5,
                                            isReadOnly: true,
                                            color: Colors.yellow,
                                            borderColor: Colors.yellow,
                                            spacing: 0.0
                                        );
                                      }
                                      else
                                      {
                                        return Text("");
                                      }
                                    },

                                  )
                                ],
                              )
                          )
                        ],
                      )
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: (mg1.username==null)?Text("     PLEASE LOGIN TO WRITE A REVIEW",
                  style: TextStyle(
                    fontSize: 20,
                  ),):
                RaisedButton(
                    onPressed: () async {
                      await writeReview(context);
                    }, //pop-up rating and comment form
                    child: Text(
                      'Write a review',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )

                ),
              ),
              Padding(
                  padding: EdgeInsets.all(5), //space offset from the left edge of the screen
                  child:
                  FutureBuilder<List<COMMENT>>(
                      future: _getcomments(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              padding: const EdgeInsets.all(8),
                              shrinkWrap: true,
                              itemCount: comms.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                String key = comms.keys.elementAt(index);
                                return Card(
                                  margin: const EdgeInsets.only(
                                      left: 10.0, right: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        /*1*/
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            /*2*/
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8),

                                              child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        '$key',
                                                        //change to username of commenter
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight
                                                              .bold,
                                                        ),
                                                      ),
                                                    ),

                                                    Align(
                                                      alignment: Alignment
                                                          .centerRight,
                                                      child:(mg1.username==null)?Text(" "):IconButton(
                                                        icon: Icon(
                                                            Icons.emoji_flags),
                                                        color: Colors.red[500],
                                                        onPressed: () async {
                                                          await report(context);
                                                        }, //bring up report menu
                                                      ),
                                                    ),
                                                  ]
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8),

                                              child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        comms[key][2],
                                                        //change to username of commenter
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),

                                                  ]
                                              ),
                                            ),
                                            SmoothStarRating(
                                              //double x = ${school[index]}
                                                rating: double.parse(
                                                    comms[key].elementAt(0)),
                                                //pass in sch ave rating variable to display
                                                starCount: 5,
                                                isReadOnly: true,
                                                color: Colors.yellow,
                                                borderColor: Colors.yellow,
                                                spacing: 0.0,
                                                size: 20
                                            ),
                                            Text(
                                                comms[key].elementAt(
                                                    1) //comment
                                            )
                                          ],
                                        ),
                                      ),
                                      /*3*/
                                    ],

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
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}