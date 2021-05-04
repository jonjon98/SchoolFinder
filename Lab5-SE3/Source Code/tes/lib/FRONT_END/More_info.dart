import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tes/FRONT_END/SeachPage.dart';
import 'package:geocoder/geocoder.dart';
import '../ccaAPI.dart';
import 'dart:async';
import '../BACK_END_INTERFACE.dart';
import '../Favourites.dart';
import '../moeProgAPI.dart';
import '../subjectAPI.dart';
import 'drawer_navigation.dart';
import 'Login_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:like_button/like_button.dart';
import '../moreInfoAPI.dart';
int count=0;
bool is_in_list=false;
List<FAVOURITES> favourites;
List<Marker> allMarkers = [];
class More_INFO extends StatefulWidget {
  More_info mg;
  More_INFO({Key key,this.mg}) : super(key:key);
  final String title = 'School Finder';

  @override
  More_INFOState createState() => More_INFOState();
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

class More_INFOState extends State<More_INFO> {
  Marker myMarker;
  var locations;
  LatLng center;
  GlobalKey<ScaffoldState> _scaffoldKey;
  final _debouncer = Debouncer(milliseconds: 2000);

  @override
  Future<void> initState()  {
    super.initState();
    center= LatLng(1.377397416176741, 103.8809134794574);
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar

  }

  // Method to update title in the AppBar Title
  // Now lets add an Employee
  _addFAVOURITES(String SchoolName) {
    BACK_END.addFavourite(username, SchoolName).then((check){
      print(check.toString());
    });
  }
  _getFAV() async {
    await BACK_END.getallforuser(username).then((users) {
      favourites = users;
    });
  }
  _checkfavourite(String SchoolName)
  async {
    await _getFAV();
    bool check=false;
    for (var i in favourites){
      if(i.username==username && i.SchoolName==SchoolName)
        check=true;
    }
    is_in_list=check;
  }
  _callNumber(String phoneNumber) async {
    String number = phoneNumber;
    await FlutterPhoneDirectCaller.callNumber(number);
  }
  Future<bool> deleteFAV(bool isLiked, String SchoolName) async {
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
  var first;
  Future _handleTap(String address) async {

    await Geocoder.google("AIzaSyBRQJW12EEdZrSo4VqoLa7z7qFVs59ymk8").findAddressesFromQuery(address).then((locations) {
      first = locations.first;
      setState(() {
        center=LatLng(first.coordinates.latitude,first.coordinates.longitude);
      });
      allMarkers=[];
      allMarkers.add(Marker(
          markerId: MarkerId('myMarker'),
          draggable: true,
          position: LatLng(first.coordinates.latitude,first.coordinates.longitude)
      ));
    });
  }
  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    final More_info mg1=ModalRoute.of(context).settings.arguments;
    //_checkfavourite(mg1.SchoolName);
    Login_info lg = Login_info(mg1.username,mg1.Password);
    _onMapCreated(GoogleMapController controller)  {

      mapController = controller;
    }

    _launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
    //_checkfavourite();
    _checkfavourite(mg1.SchoolName);
    Future<List<String>> cca = getCCAInfo(mg1.SchoolName.toUpperCase(),"cca_generic_name");
    Future<String> url=getInfo(mg1.SchoolName.toUpperCase(),"url_address");
    Future<String> mission = getInfo(mg1.SchoolName.toUpperCase(), "missionstatement_desc");
    Future<String> address = getInfo(mg1.SchoolName.toUpperCase(), "address");
    Future<String> vision = getInfo(mg1.SchoolName.toUpperCase(), "visionstatement_desc");
    Future<String> philosophy = getInfo(mg1.SchoolName.toUpperCase(), "philosophy_culture_ethos");
    Future<String> email = getInfo(mg1.SchoolName.toUpperCase(), "email_address");
    Future<String> telephone = getInfo(mg1.SchoolName.toUpperCase(), "telephone_no");
    Future<String> principal = getInfo(mg1.SchoolName.toUpperCase(), "principal_name");
    Future<String> bus = getInfo(mg1.SchoolName.toUpperCase(), "bus_desc");
    Future<String> mrt = getInfo(mg1.SchoolName.toUpperCase(), "mrt_desc");
    Future<List<String>> Subjects = getSubject(mg1.SchoolName.toUpperCase());





    final List<int> colorCodes = <int>[600, 500, 100];
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFFa1e0e7),
        title: Text(
          "SchoolFinder",
          style: TextStyle(
            color: Colors.black,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ), // we show the progress in the title..
        actions: <Widget>[
          (mg1.username==null)?Text(""):LikeButton(

            isLiked:  is_in_list, //need to check is school is in user fav list. if yes => true
            onTap: (bool isLiked) {
              return deleteFAV(isLiked,mg1.SchoolName);
            },

          ),
        ],
      ),
      drawer: (mg1.username!=null)?DrawerNavigation(lg: lg,):null,
      body: SingleChildScrollView(
        child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 450,
                    color: Color(0xFFa1e0e7),
                  ),
                  SizedBox(height:200),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: Text("Principal Name",style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical:0.0, horizontal: 25.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      //padding: const EdgeInsets.all(5),
                      child: FutureBuilder<String>(
                          future: principal,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                '${snapshot.data}',style: TextStyle(fontSize: 17),);
                            }
                            else{
                              return Center(child: CircularProgressIndicator());
                            }
                          }
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: Text("Buses Nearby",style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical:0.0, horizontal: 25.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FutureBuilder<String>(
                          future: bus,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                '${snapshot.data}',style: TextStyle(fontSize: 17, fontStyle: FontStyle.italic),);
                            }
                            else{
                              return Center(child: CircularProgressIndicator());
                            }
                          }
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: Text("MRTs Nearby",style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0, left: 25.0, right:25.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FutureBuilder<String>(
                          future: mrt,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                '${snapshot.data}',style: TextStyle(fontSize: 17, fontStyle: FontStyle.italic),);
                            }
                            else{
                              return Center(child: CircularProgressIndicator());
                            }
                          }
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 25.0),
                    child: Column(
                      children: <Widget>[
                        //SizedBox(height: 20.0),
                        ExpansionTile(
                            title: Text(
                              "CCA",
                              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                            ),
                            children: <Widget>[
                              FutureBuilder<List<String>>(
                                  future: cca,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return ListView.builder(
                                          padding: const EdgeInsets.all(8),
                                          shrinkWrap: true,
                                          itemCount: snapshot.data.length,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                                height: 50,
                                                child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      '${snapshot.data[index]}',
                                                      style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
                                                    )
                                                )
                                            );
                                          }
                                      );
                                    }
                                    else{
                                      return Center(child: CircularProgressIndicator());
                                    }
                                  }
                              )
                            ]
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 25.0),
                    child: Column(
                      children: <Widget>[
                        //SizedBox(height: 20.0),
                        ExpansionTile(
                            title: Text(
                              "Subjects",
                              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            children: <Widget>[
                              FutureBuilder<List<String>>(
                                  future: Subjects,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return ListView.builder(
                                          padding: const EdgeInsets.all(8),
                                          shrinkWrap: true,
                                          itemCount: snapshot.data.length,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                                height: 50,
                                                child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      '${snapshot.data[index]}',
                                                      style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
                                                    )
                                                )
                                            );
                                          }
                                      );
                                    }
                                    else{
                                      return Center(child: CircularProgressIndicator());
                                    }
                                  }
                              )
                            ]
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(bottom: 10.0, left: 25.0, right:25.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: FlatButton(
                          padding: EdgeInsets.all(5),
                          onPressed: () { },//go to rating and comment page
                          child: Align(alignment: Alignment.centerLeft,
                            child: Text('Rating and comments',style: TextStyle(fontSize: 18,
                                fontWeight: FontWeight.bold),),

                          ),
                        ),


                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios_rounded),
                          onPressed: (){
                            Navigator.pushNamed(context, '/Comments',
                                arguments: More_info(mg1.username,mg1.Password,mg1.SchoolName));

                          },
                        ),

                      ],
                    ),
                  ),

                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 30.0, left: 25.0, right:25.0),
                      child: Row(
                        children: <Widget>[
                          FutureBuilder<String>(
                              future: url,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Expanded(child: FlatButton(
                                    padding: EdgeInsets.all(5),
                                    onPressed: () {
                                      _launchURL(snapshot.data); },//go to rating and comment page
                                    child: Align(alignment: Alignment.centerLeft,
                                      child: Text('Go to school website: ${snapshot.data}',style:TextStyle(fontSize: 15, fontStyle: FontStyle.italic) , ),
                                    ),
                                  ),
                                  );
                                }
                                else
                                {
                                  return Center(child: CircularProgressIndicator());
                                }
                              }
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward_ios_rounded),
                            onPressed: (){},
                          ),

                        ],
                      ),
                    ),
                  ),


                ],
              ),

              Card(
                margin: EdgeInsets.only(left:15.0, right:15.0, top:30.0, bottom: 300.0),
                elevation: 10.0,
                child:Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          mg1.SchoolName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                        width: 300.0,
                        child: Divider(
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: FutureBuilder<String>(
                                future:telephone,
                                builder: (context, snapshot){
                                  if(snapshot.hasData){
                                    return RaisedButton(
                                      onPressed: () => {
                                        _callNumber("+65"+snapshot.data)
                                      },
                                      color: Colors.green,
                                      padding: EdgeInsets.all(10.0),
                                      child:Row(
                                        children: <Widget>[
                                          Icon(Icons.local_phone_rounded, color: Colors.white,),
                                          SizedBox(width:5.0),
                                          Text('+65 ${snapshot.data}',style: TextStyle(fontSize: 15,color:Colors.white),),
                                        ],
                                      ),
                                    );
                                  }
                                  else{
                                    return Text("Loading...",style: TextStyle(fontSize: 17,color:Colors.white),);
                                  }
                                }
                              )
                            ),
                            Container(
                              child:RaisedButton(
                                onPressed: () => {},
                                color: Colors.green,
                                padding: EdgeInsets.all(10.0),
                                child: FutureBuilder<String>(
                                    future: email,
                                    builder: (context, snapshot){
                                      if(snapshot.hasData){
                                        return (Row(
                                          children: <Widget>[
                                            Icon(Icons.email_rounded, color: Colors.white,),
                                            SizedBox(width:5.0),
                                            Text('${snapshot.data}',style: TextStyle(fontSize: 10,color:Colors.white),),
                                          ],
                                        ));
                                      }
                                      else{
                                        return Text("Loading...",style: TextStyle(fontSize: 17,color:Colors.white),);
                                      }
                                    }
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Card(
                        child: Container(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5), //space offset from the left edge of the screen
                                child:
                                FutureBuilder<String>(
                                    future: address,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return SizedBox(
                                            width: 500,
                                            height: 300,
                                            child: GoogleMap(
                                              onMapCreated: (GoogleMapController controller) async {
                                                await _handleTap(snapshot.data);
                                                _onMapCreated(controller);
                                                setState(() {
                                                });

                                              },
                                              initialCameraPosition: CameraPosition(
                                                target: center,
                                                zoom: 10.0,
                                              ),
                                              markers: Set.from(allMarkers),
                                              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                                                new Factory<OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),),
                                              ].toSet(),
                                            )
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
                      SizedBox(
                        height: 15.0,
                        width: 300.0,
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(5), //space offset from the left edge of the screen
                              child: Row(
                                children: [
                                  Text(
                                    'Address',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.my_location_rounded,
                                    color: Colors.blue,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                //padding: const EdgeInsets.all(5),
                                child: FutureBuilder<String>(
                                    future: address,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                          '${snapshot.data}\n',style: TextStyle(fontSize: 17),);
                                      }
                                      else{
                                        return Center(child: CircularProgressIndicator());
                                      }
                                    }
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]
        ),


        //         Card(
        //           child: Padding(
        //             padding: EdgeInsets.all(5), //space offset from the left edge of the screen
        //             child: Row(
        //               children: <Widget>[
        //                 FutureBuilder<String>(
        //                     future: url,
        //                     builder: (context, snapshot) {
        //                       if (snapshot.hasData) {
        //                         return Expanded(child: FlatButton(
        //                           padding: EdgeInsets.all(5),
        //                           onPressed: () {
        //                             _launchURL(snapshot.data); },//go to rating and comment page
        //                           child: Align(alignment: Alignment.centerLeft,
        //                             child: Text('Go to school website: ${snapshot.data}',style:TextStyle(fontSize: 15, fontStyle: FontStyle.italic) , ),
        //                           ),
        //                         ),
        //                         );
        //                       }
        //                       else
        //                       {
        //                         return Center(child: CircularProgressIndicator());
        //                       }
        //                     }
        //                 ),
        //                 IconButton(
        //                   icon: Icon(Icons.arrow_forward_ios_rounded),
        //                   onPressed: (){},
        //                 ),
        //
        //               ],
        //             ),
        //           ),
        //         ),


        //         Card(
        //           //padding: EdgeInsets.all(10), //space offset from the left edge of the screen
        //           child: Row(
        //             children: <Widget>[
        //               Expanded(child: FlatButton(
        //                 padding: EdgeInsets.all(5),
        //                 onPressed: () { },//go to rating and comment page
        //                 child: Align(alignment: Alignment.centerLeft,
        //                   child: Text('Rating and comments',style: TextStyle(fontSize: 18,
        //                       fontWeight: FontWeight.bold),),
        //
        //                 ),
        //               ),
        //
        //
        //               ),
        //               IconButton(
        //                 icon: Icon(Icons.arrow_forward_ios_rounded),
        //                 onPressed: (){
        //                   Navigator.pushNamed(context, '/Comments',
        //                       arguments: More_info(mg1.username,mg1.Password,mg1.SchoolName));
        //
        //                 },
        //               ),
        //
        //             ],
        //           ),
        //         ),
        //       ],
        //
        //     ),
        //   ),
        // ),
      ),
    );

  }
}