import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jitfaculty/screens/admin/admin1/request.dart';
import 'package:jitfaculty/screens/admin/admin2/hod_leave_requests.dart';
import 'package:jitfaculty/screens/admin/users.dart';
import 'package:jitfaculty/services/database.dart';

class Admin2Home extends StatefulWidget {
  static const routeName = 'admin2Home';

  @override
  _Admin2HomeState createState() => _Admin2HomeState();
}

class _Admin2HomeState extends State<Admin2Home> {
  String nameOfUser = '';
  String userType = '';
  String branch = '';

  @override
  void initState() {
    super.initState();
    userName();
  }

  void userName() async {
    String uid = await FirebaseAuth.instance.currentUser().then((user) {
      return user.uid.toString();
    });
    String user = await Database().getUserInfo(uid: uid, doc: 'name');
    String type = await Database().getUserInfo(uid: uid, doc: 'auth');
    String dpt = await Database().getUserInfo(uid: uid, doc: 'branch');

    setState(() {
      nameOfUser = user;
      userType = type.toUpperCase();
      branch = dpt.toUpperCase();
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
              Flexible(
                child: Text(nameOfUser),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '$userType ( $branch )',
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton.icon(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        title: Text('Are you sure you want to log out ?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Ok'),
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(context, '/');
                            },
                          ),
                          FlatButton(
                            child: Text('Cancel'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      );
                    });
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
                child: Text('Leave Requests'),
              ),
              Tab(
                child: Text('ID Requests'),
              ),
              Tab(
                child: Text('Users'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            HodLeaveRequests(hodBranch: branch),
            Request(),
            Users(),
          ],
        ),
      ),
    );
  }
}
