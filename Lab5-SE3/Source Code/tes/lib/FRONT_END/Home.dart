import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Image(
                image: AssetImage('images/firstPage.png'),
              ),
            ),
            Container(
              child: Text(
                'Welcome',
                style: TextStyle(
                  color: Color.fromARGB(255, 53, 83, 137),
                  fontWeight: FontWeight.bold,
                  fontSize: 40.0,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 50.0),
              child: Text(
                'We Help You Find The Most Suitable School.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            RaisedButton(
              child: Text("Login"),
              onPressed: () {
                Navigator.pushNamed(context, '/login');

              },
            ),
            ElevatedButton(
              child: Text("Sign Up"),
              onPressed: () => {
                Navigator.pushNamed(context, '/signUpPage'),
              },
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/searchLandingPage');
              },
              child: Text(
                'Guest User',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}