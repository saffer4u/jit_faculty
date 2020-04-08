import 'package:flutter/material.dart';
import 'package:jitfaculty/screens/admin/admin1/admin1_home.dart';
import 'package:jitfaculty/screens/admin/admin2/admin2_home.dart';
import 'package:jitfaculty/screens/user/user_home.dart';
import 'package:jitfaculty/screens/user/user_leave_request.dart';
import 'package:jitfaculty/signup/message.dart';
import 'package:jitfaculty/signup/signup_screen.dart';
import './screens/welcome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFFE9761E),
        scaffoldBackgroundColor: Color(0xFF6E41B7),
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.white, fontSize: 17),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => WelcomeScreen(),
        UserHome.routeName: (ctx) => UserHome(),
        Admin1Home.routeName: (ctx) => Admin1Home(),
        Admin2Home.routeName: (ctx) => Admin2Home(),
        SignUpScreen.routeName: (ctx) => SignUpScreen(),
        Message.routeName: (ctx) => Message(),
        UserLeaveRequest.routeName: (ctx) => UserLeaveRequest(),
      },
    );
  }
}
