import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jitfaculty/constents.dart';
import 'package:jitfaculty/screens/admin/admin1/admin1_home.dart';
import 'package:jitfaculty/screens/admin/admin2/admin2_home.dart';
import 'package:jitfaculty/screens/user/user_home.dart';
import 'package:jitfaculty/services/auth.dart';
import 'package:jitfaculty/services/database.dart';
import 'package:jitfaculty/signup/signup_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final formKey = GlobalKey<FormState>();
  String email;
  String password;
  bool saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('JIT faculty')),
      ),
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          backgroundColor: kpcol,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
        inAsyncCall: saving,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Email'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            validator: (input) =>
                                !input.contains('@') && input.length < 6
                                    ? 'Not a valid email'
                                    : null,
                            onChanged: (input) => email = input,
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              focusColor: Colors.red,
                            ),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            validator: (input) => input.length < 6
                                ? 'Not a valid password'
                                : null,
                            onChanged: (input) => password = input,
                          ),
                          FlatButton(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 20),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Log In',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: kscol,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onPressed: () async {
                              if (formKey.currentState.validate()) {
                                setState(() {
                                  saving = true;
                                });
                                FirebaseUser user = await Authenticate()
                                    .signIn(email: email, password: password);

                                String userType = await Database()
                                    .getUserInfo(uid: user.uid, doc: 'auth');

                                if (user != null) {
                                  setState(() {
                                    saving = false;
                                  });

                                  if (userType == 'principal') {
                                    Navigator.pushReplacementNamed(
                                        context, Admin1Home.routeName);
                                  } else if (userType == 'hod') {
                                    Navigator.pushReplacementNamed(
                                        context, Admin2Home.routeName);
                                  } else {
                                    Navigator.of(context).pushReplacementNamed(
                                        UserHome.routeName);
                                  }
                                } else {
                                  print('Error Occured');
                                  setState(() {
                                    saving = false;
                                  });
                                }
                              }
                            },
                          ),
                          FlatButton(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 20),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: kscol,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onPressed: () => Navigator.pushNamed(
                                context, SignUpScreen.routeName),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
