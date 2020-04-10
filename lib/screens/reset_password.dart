import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jitfaculty/constents.dart';
import 'package:jitfaculty/screens/welcome_screen.dart';
import 'package:jitfaculty/services/auth.dart';

class ResetPassword extends StatelessWidget {
  static const routeName = 'reset_password';
  @override
  Widget build(BuildContext context) {
    String email = '';
    String msg = '';
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  validator: (input) => !input.contains('@') && input.length < 6
                      ? 'Not a valid email'
                      : null,
                  onChanged: (input) => email = input.trim(),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                width: double.infinity,
                child: RaisedButton(
                    color: kpcol,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'RESET',
                        style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 3,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: email);
                      showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text(
                                  'Password reset link has been sent to your email address'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Ok'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
