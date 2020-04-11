import 'package:flutter/material.dart';
import 'package:jitfaculty/screens/admin/users.dart';
import 'package:jitfaculty/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HrHome extends StatefulWidget {
  static const routeName = 'hr_home';
  @override
  _HrHomeState createState() => _HrHomeState();
}

class _HrHomeState extends State<HrHome> {
  String nameOfUser = '';

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
    if (this.mounted) {
      setState(() {
        nameOfUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.ideographic,
          children: <Widget>[
            Text(nameOfUser),
            SizedBox(width: 5),
            Text(
              'HR',
              style: TextStyle(fontSize: 12),
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
//                            Navigator.pushReplacementNamed(context, '/');
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
      ),
      body: Users(),
    );
  }
}
