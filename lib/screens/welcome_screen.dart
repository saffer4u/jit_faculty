import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jitfaculty/constents.dart';
import 'package:jitfaculty/screens/admin/admin1/admin1_home.dart';
import 'package:jitfaculty/screens/admin/admin2/admin2_home.dart';
import 'package:jitfaculty/screens/admin/hr_home.dart';
import 'package:jitfaculty/screens/reset_password.dart';
import 'package:jitfaculty/screens/user/user_home.dart';
import 'package:jitfaculty/services/auth.dart';
import 'package:jitfaculty/services/database.dart';
import 'package:jitfaculty/signup/signup_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final formKey = GlobalKey<FormState>();
  String email;
  String password;
  bool saving = false;
  String errorMsg = '';

  waitingFun() async {
    await Future.delayed(Duration(seconds: 15));
    if (this.mounted) {
      setState(() {
        saving = false;
        errorMsg = 'Something went wrong please try again';
      });
    }
    clearTextInput();
  }

  final nameHolder = TextEditingController();
  clearTextInput() {
    nameHolder.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('JIT Faculty')),
      ),
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          backgroundColor: kpcol,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
        inAsyncCall: saving,
        child: Center(
          child: SingleChildScrollView(
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
                              onChanged: (input) => email = input.trim(),
                            ),
                            TextFormField(
                              controller: nameHolder,
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
                              onChanged: (input) => password = input.trim(),
                            ),
                            SizedBox(height: 10),
                            Text(
                              errorMsg,
                              style: TextStyle(color: Colors.red),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              width: double.infinity,
                              child: RaisedButton(
                                  color: kpcol,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    child: Text(
                                      'LOG IN',
                                      style: TextStyle(
                                          fontSize: 20,
                                          letterSpacing: 3,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (formKey.currentState.validate()) {
                                      setState(() {
                                        saving = true;
                                      });
                                      waitingFun();

                                      FirebaseUser user = await Authenticate()
                                          .signIn(
                                              email: email, password: password);

//                                      String userType = await Database()
//                                          .getUserInfo(
//                                              uid: user.uid, doc: 'auth');
//
//                                      if (user != null) {
//                                        setState(() {
//                                          saving = false;
//                                        });
//
//                                        switch (userType) {
//                                          case 'principal':
//                                            {
//                                              Navigator.pushReplacementNamed(
//                                                  context,
//                                                  Admin1Home.routeName);
//                                              break;
//                                            }
//                                          case 'hod':
//                                            {
//                                              Navigator.pushReplacementNamed(
//                                                  context,
//                                                  Admin2Home.routeName);
//                                              break;
//                                            }
//                                          case 'faculty':
//                                            {
//                                              Navigator.of(context)
//                                                  .pushReplacementNamed(
//                                                      UserHome.routeName);
//                                              break;
//                                            }
//                                          case 'hr':
//                                            {
//                                              Navigator.of(context)
//                                                  .pushReplacementNamed(
//                                                      HrHome.routeName);
//                                            }
//                                        }
//                                      } else {
//                                        print('Error Occured');
//                                        setState(() {
//                                          saving = false;
//                                        });
//                                      }
                                    }
                                  }),
                            ),
                            Divider(
                              color: kpcol,
                              indent: 40,
                              endIndent: 40,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              width: double.infinity,
                              child: RaisedButton(
                                color: kpcol,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Text(
                                    'SIGN UP',
                                    style: TextStyle(
                                        fontSize: 20,
                                        letterSpacing: 3,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ),
                                onPressed: () => Navigator.pushNamed(
                                    context, SignUpScreen.routeName),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              width: double.infinity,
                              child: RaisedButton(
                                color: kpcol,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Text(
                                    'RESET PASSWORD',
                                    style: TextStyle(
                                        fontSize: 20,
                                        letterSpacing: 3,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ),
                                onPressed: () => Navigator.pushNamed(
                                    context, ResetPassword.routeName),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Developed by CSE Students in association with\nHead of Department (CSE)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
//                RaisedButton(
//                  child: Text('admin'),
//                  onPressed: () async {
//                    String id = DateTime.now().toString();
//                    await Firestore.instance
//                        .collection('users_registrations')
//                        .document(id)
//                        .setData({
//                      'email': 'a@4u.com',
//                      'password': '123456',
//                      'cl': 10,
//                      'id': id,
//                    });
//                  },
//                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
