import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jitfaculty/screens/admin/admin1/admin1_home.dart';
import 'package:jitfaculty/screens/admin/hr_home.dart';
import 'package:jitfaculty/screens/admin/admin2/admin2_home.dart';
import 'package:jitfaculty/screens/history.dart';
import 'package:jitfaculty/screens/reset_password.dart';
import 'package:jitfaculty/screens/user/user_home.dart';
import 'package:jitfaculty/screens/user/user_leave_request.dart';
import 'package:jitfaculty/services/auth.dart';
import 'package:jitfaculty/signup/message.dart';
import 'package:jitfaculty/signup/signup_screen.dart';
import './screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jitfaculty/screens/wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value: Authenticate().userAuthState,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFFE9761E),
          scaffoldBackgroundColor: Color(0xFF6E41B7),
          textTheme: TextTheme(
            body1: TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => Wrapper(),
//          '/': (ctx) => WelcomeScreen(),
          UserHome.routeName: (ctx) => UserHome(),
          Admin1Home.routeName: (ctx) => Admin1Home(),
          Admin2Home.routeName: (ctx) => Admin2Home(),
          SignUpScreen.routeName: (ctx) => SignUpScreen(),
          Message.routeName: (ctx) => Message(),
          UserLeaveRequest.routeName: (ctx) => UserLeaveRequest(),
          History.routeName: (ctx) => History(),
          ResetPassword.routeName: (ctx) => ResetPassword(),
          HrHome.routeName: (ctx) => HrHome(),
        },
      ),
    );
  }
}
