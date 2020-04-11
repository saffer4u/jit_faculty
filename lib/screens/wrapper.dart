import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jitfaculty/constents.dart';
import 'package:jitfaculty/screens/admin/admin1/admin1_home.dart';
import 'package:jitfaculty/screens/admin/admin2/admin2_home.dart';
import 'package:jitfaculty/screens/admin/hr_home.dart';
import 'package:jitfaculty/screens/user/user_home.dart';
import 'package:jitfaculty/screens/welcome_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:jitfaculty/services/database.dart';

class Wrapper extends StatelessWidget {
  String userType;
  Future<void> getUserType({String uid}) async {
    userType = await Database().getUserInfo(uid: uid, doc: 'auth');
  }

  @override
  Widget build(BuildContext context) {
    final loggedUser = Provider.of<FirebaseUser>(context);

    loggedUser != null ? print(loggedUser.email) : print('User Log Out');

    if (loggedUser == null) {
      userType = null;
      return WelcomeScreen();
    } else {
      return FutureBuilder(
        future: getUserType(uid: loggedUser.uid),
        builder: (context, widget) {
          switch (userType) {
            case 'principal':
              {
                return Admin1Home();
              }
            case 'hod':
              {
                return Admin2Home();
              }
            case 'faculty':
              {
                return UserHome();
              }
            case 'hr':
              {
                return HrHome();
              }
          }
          return Scaffold(
            appBar: AppBar(),
            body: ModalProgressHUD(
              progressIndicator: CircularProgressIndicator(
                backgroundColor: kpcol,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              inAsyncCall: true,
              child: Container(),
            ),
          );
        },
      );
    }
  }
}

//switch (userType) {
//case 'principal':
//{
//return Admin1Home();
//}
//case 'hod':
//{
//return Admin2Home();
//}
//case 'faculty':
//{
//return UserHome();
//}
//case 'hr':
//{
//return HrHome();
//}
//}
