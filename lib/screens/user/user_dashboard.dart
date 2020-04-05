import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jitfaculty/constents.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jitfaculty/services/database.dart';

class UserDashBoard extends StatefulWidget {
  @override
  _UserDashBoardState createState() => _UserDashBoardState();
}

class _UserDashBoardState extends State<UserDashBoard> {
  int el = 0;
  int cl = 0;
  int od = 0;
  int eml = 0;
  int total = 0;

  void getleaveDetails() async {
    String uid = await FirebaseAuth.instance.currentUser().then((user) {
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
    getleaveDetails();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          SizedBox(height: 10),
          DashboardCard(
            title: 'Earn Leave :',
            value: el,
          ),
          DashboardCard(
            title: 'Casual Leave :',
            value: cl,
          ),
          DashboardCard(
            title: 'Outdoor Duty :',
            value: od,
          ),
          DashboardCard(
            title: 'Emergency Leave :',
            value: eml,
          ),
          DashboardCard(
            title: 'Total :',
            value: total,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: FloatingActionButton(
              child: Icon(Icons.refresh),
              backgroundColor: kpcol,
              onPressed: () {
                setState(() {
                  getleaveDetails();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final int value;

  DashboardCard({this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Text(
                title,
                style: TextStyle(
                    color: kscol, fontSize: 30, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SizedBox(width: 10),
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Text(value.toString(),
                style: TextStyle(
                  color: kscol,
                  fontSize: 30,
                )),
          )
        ],
      ),
    );
  }
}
