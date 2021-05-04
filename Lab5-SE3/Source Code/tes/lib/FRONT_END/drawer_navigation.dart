//import 'dart:html';

import 'package:flutter/material.dart';

import 'Login_info.dart';
int count=0;
class DrawerNavigation extends StatefulWidget {
  final Login_info lg;
  DrawerNavigation({Key key,this.lg}) : super(key:key);

  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  @override
  Widget build(BuildContext context) {
    final Login_info lg1 = ModalRoute
        .of(context)
        .settings
        .arguments;
    final String username=lg1.username;

    return Container(
        child: FutureBuilder<String>(
            future: lg1.Get_Email(username),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Drawer(
                    child: ListView(
                        padding: new EdgeInsets.all(0.0),
                      children: <Widget>[
                        UserAccountsDrawerHeader(
                          margin: EdgeInsets.only(top: 0),
                          accountName: Text("Welcome ${lg1.username},",style: TextStyle(

                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),),
                          accountEmail: Text("Email: ${snapshot.data}",style: TextStyle(

                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),),
                          decoration: BoxDecoration(color: Colors.blue),
                        ),
                        ListTile(
                            leading: Icon(Icons.home),
                            title: Text('Home'),
                            onTap: () {
                              Navigator.pushNamed(context, '/searchLandingPage',
                              arguments : Login_info(lg1.username, lg1.Password),
                              );
                            }
                        ),
                        ListTile(
                          leading: Icon(Icons.favorite),
                          title: Text('Favourites'),
                          onTap: (){
                               Navigator.pushNamed(context, '/Favourites',
                              arguments : Login_info(lg1.username, lg1.Password),);
                              }
                        ),
                        ListTile(
                            leading: Icon(Icons.view_list),
                            title: Text('List of School'),
                            onTap: () {
                              Navigator.pushNamed(context, '/search');
                            }
                        ),
                        ListTile(
                          leading: Icon(Icons.settings),
                          title: Text('Setting'),
                            onTap: () {
                              Navigator.pushNamed(context, '/settings',
                              arguments : Login_info(lg1.username, lg1.Password),);
                            }
                        ),
                        ListTile(
                          leading: Icon(Icons.logout),
                          title: Text('Sign Out'),
                            onTap: () {
                              Navigator.pushNamed(context, '/');
                            }
                        ),
                      ],
                    )
                );
              }
              return CircularProgressIndicator();
            }
        )
    );
  }
}