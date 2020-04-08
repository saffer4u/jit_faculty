import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jitfaculty/screens/user/leave_application.dart';
import 'package:jitfaculty/screens/user/user_dashboard.dart';
import 'package:jitfaculty/screens/user/user_leave_request.dart';
import 'package:jitfaculty/screens/user/user_notification.dart';
import 'package:jitfaculty/services/database.dart';

class UserHome extends StatefulWidget {
  static const routeName = 'userHome';

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  String nameOfUser = '';
  String userType = '';
  String uid;

  @override
  void initState() {
    super.initState();
    userName();
  }

  void userName() async {
    uid = await FirebaseAuth.instance.currentUser().then((user) {
      return user.uid.toString();
    });
    String user = await Database().getUserInfo(uid: uid, doc: 'name');
    String type = await Database().getUserInfo(uid: uid, doc: 'auth');
    setState(() {
      nameOfUser = user;
      userType = type.toUpperCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(nameOfUser),
              SizedBox(
                width: 5,
              ),
              Text(
                userType,
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              label: Text(
                'Log Out',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                child: Text('Dashboard'),
              ),
              Tab(
                child: Text(
                  'Leave Application',
                  textAlign: TextAlign.center,
                ),
              ),
              Tab(
                child: Text('Notification'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            UserDashBoard(),
            LeaveApplication(uid: uid),
            UserNotification(uid: uid),
          ],
        ),
      ),
    );
  }
}
