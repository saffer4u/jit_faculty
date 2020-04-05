import 'package:flutter/material.dart';
import 'package:jitfaculty/constents.dart';
import 'package:jitfaculty/services/auth.dart';
import 'package:jitfaculty/services/database.dart';
import 'package:jitfaculty/signup/message.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = 'sign_up_screen';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  String name;

  String email;

  String password;

  String type;

  String department;

  String branch;

  bool save = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: save,
        progressIndicator: CircularProgressIndicator(
          backgroundColor: kpcol,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Name'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        validator: (input) => input.length < 6
                            ? 'Name must be greater then 5 character'
                            : null,
                        onChanged: (input) => name = input,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
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
                        validator: (input) =>
                            input.length < 6 ? 'Not a valid password' : null,
                        onChanged: (input) => password = input,
                      ),

                      // User type
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('User type : '),
                          DropdownButton<String>(
                            value: type,
                            icon: Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(
                                color: kpcol, fontWeight: FontWeight.w700),
                            underline: Container(
                              height: 2,
                              color: kscol,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                type = newValue;
                              });
                            },
                            items: <String>[
                              'Faculty',
                              'HOD',
                              'Principal',
                              'Manager'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),

                      // Department
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Department : '),
                          DropdownButton<String>(
                            value: department,
                            icon: Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(
                                color: kpcol, fontWeight: FontWeight.w700),
                            underline: Container(
                              height: 2,
                              color: kscol,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                department = newValue;
                              });
                            },
                            items: <String>[
                              'B.Tech',
                              'Diploma',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),

                      // Branch
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Branch : '),
                          DropdownButton<String>(
                            value: branch,
                            icon: Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(
                                color: kpcol, fontWeight: FontWeight.w700),
                            underline: Container(
                              height: 2,
                              color: kscol,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                branch = newValue;
                              });
                            },
                            items: <String>[
                              'CSE',
                              'ME',
                              'CE',
                              'EE',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
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
                        onPressed: () async {
                          setState(() {
                            save = true;
                          });
                          try {
                            await Database().signuprequest(
                              name: name,
                              email: email,
                              password: password,
                              type: type.toLowerCase(),
                              department: department.toLowerCase(),
                              branch: branch.toLowerCase(),
                            );
                            setState(() {
                              save = false;
                            });
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(
                                context, Message.routeName);
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
