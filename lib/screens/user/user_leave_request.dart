import 'package:flutter/material.dart';
import 'package:jitfaculty/constents.dart';
import 'package:jitfaculty/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserLeaveRequest extends StatefulWidget {
  @override
  _UserLeaveRequestState createState() => _UserLeaveRequestState();
}

class _UserLeaveRequestState extends State<UserLeaveRequest> {
  String name = '';
  String dept = '';
  String branch = '';
  String uid;
  int el = 0;
  int cl = 0;
  int od = 0;
  int eml = 0;
  int total = 0;

  void getUserInfo() async {
    uid = await FirebaseAuth.instance.currentUser().then((user) {
      return user.uid.toString();
    });

    Map<String, dynamic> result = await Firestore.instance
        .collection('user')
        .document(uid)
        .get()
        .then((documentSnapshot) {
      return documentSnapshot.data;
    });

    setState(() {
      name = result['name'];
      dept = result['department'];
      branch = result['branch'];
      el = result['el'];
      cl = result['cl'];
      od = result['od'];
      eml = result['eml'];
      total = el + cl + od + eml;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            decoration: BoxDecoration(
                color: Color(0xFF4700B9),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(child: Text('Name : $name')),
                    Expanded(child: Text('DepartMent : ${dept.toUpperCase()}')),
                  ],
                ),
                Text('Branch : ${branch.toUpperCase()}'),
                SizedBox(height: 20),
                Text('Taken leave details : '),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('EL : $el'),
                    Text('CL : $cl'),
                    Text('OD : $od'),
                    Text('EML : $eml'),
                    Text('Total : $total'),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
                color: kpcol,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10))),
            height: 800,
          ),
        ],
      ),
    );
  }
}
