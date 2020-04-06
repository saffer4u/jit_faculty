import 'package:flutter/material.dart';
import 'package:jitfaculty/constents.dart';
import 'package:jitfaculty/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserLeaveRequest extends StatefulWidget {
  @override
  _UserLeaveRequestState createState() => _UserLeaveRequestState();
}

class _UserLeaveRequestState extends State<UserLeaveRequest> {
  String name = '';
  String dept = '';
  String branch = '';
  String leaveType = 'cl';
  String designation = '';
  String leaveReason = '';
  String uid;
  int el = 0;
  int cl = 0;
  int od = 0;
  int eml = 0;
  int lwp = 0;
  int total = 0;
  DateTime fromDate;
  DateTime toDate;
  int leaveDays = 0;

  // Alternate field variables.

  String cls1 = 'b.tech';
  String sem1 = '1';
  String tFrom1;
  String tTo1;

//  List<Map<String, Object>> alternateArr = [
//    {
//      'id': '2020-04-05 15:57:33.783735',
//      'course': 'b.tech',
//      'sem': 4,
//      'time': '12:00',
//      'room': 'ab101',
//      'csub': 'ed-ii',
//      'asub': 'cad',
//      'arrby': 'balram',
//    },
//    {
//      'id': '2020-04-05 15:58:34.659155',
//      'course': 'b.pharma',
//      'sem': 2,
//      'time': '10:00',
//      'room': 'lt101',
//      'csub': 'ed-i',
//      'asub': 'test',
//      'arrby': 'Abhimanyu',
//    },
//  ];

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
      lwp = result['lwp'];
      total = el + cl + od + eml + lwp;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    // Date picker

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                Text('Taken leave details : ', style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text('EL : $el'),
                        Text('CL : $cl'),
                        Text('OD : $od'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text('EML : $eml'),
                        Text('LWP : $lwp'),
                        Text('Total : $total'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  decoration: BoxDecoration(
                      color: kpcol,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Type of leave : '),
                          DropdownButton<String>(
                            value: leaveType,
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
                                leaveType = newValue;
                              });
                            },
                            items: <String>[
                              'el',
                              'cl',
                              'od',
                              'lwp',
                              'eml',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value.toUpperCase(),
                                    style: TextStyle(color: kscol)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      TextFormField(
                        autofocus: false,
                        decoration: kinputDecoration,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        validator: (input) =>
                            input.length == 0 ? 'Required' : null,
                        onChanged: (input) => designation = input,
                      ),
                      TextFormField(
                        autofocus: false,
                        decoration: kinputDecoration.copyWith(
                            labelText: 'Reason for leave :'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        validator: (input) =>
                            input.length == 0 ? 'Required' : null,
                        onChanged: (input) => leaveReason = input,
                      ),

                      SizedBox(height: 20),
                      Text('Period of leave :'),
                      SizedBox(height: 10),
                      // Date picker
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () async {
                              fromDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2025),
                                  builder:
                                      (BuildContext context, Widget child) {
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        primaryColor: kpcol,
                                        accentColor: kpcol,
                                      ),
                                      child: child,
                                    );
                                  });
                              setState(() {});
                            },
                            child: Text(
                              'From',
                              style: TextStyle(color: kpcol),
                            ),
                          ),
                          Text(
                              '- ${fromDate == null ? "Pick Date" : DateFormat.yMMMMEEEEd().format(fromDate)}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () async {
                              toDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2016),
                                  lastDate: DateTime(2025),
                                  builder:
                                      (BuildContext context, Widget child) {
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        primaryColor: kpcol,
                                        accentColor: kpcol,
                                      ),
                                      child: child,
                                    );
                                  });
                              leaveDays =
                                  (toDate.difference(fromDate).inDays.toInt() +
                                      1);
                              print(leaveDays);
                              setState(() {});
                            },
                            child: Text(
                              'To',
                              style: TextStyle(color: kpcol),
                            ),
                          ),
                          Text(
                              '- ${toDate == null ? "Pick Date" : DateFormat.yMMMMEEEEd().format(toDate)}'),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '- No. of day(s) :  $leaveDays',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                //

                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  decoration: BoxDecoration(
                      color: Color(0xFF4700B9),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        height: 50,
                        child: Center(
                            child: Text(
                          'Details of Alternate Arrangement',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                      ),

                      // Alternate fields.
                      // Field 1.
                      Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            color: kpcol,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Field : 1'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Class : '),
                                DropdownButton<String>(
                                  value: cls1,
                                  icon: Icon(
                                    Icons.arrow_downward,
                                    color: Colors.white,
                                  ),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(
                                      color: kpcol,
                                      fontWeight: FontWeight.w700),
                                  underline: Container(
                                    height: 2,
                                    color: kscol,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      cls1 = newValue;
                                    });
                                  },
                                  items: <String>[
                                    'diploma',
                                    'b.tech',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value.toUpperCase(),
                                          style: TextStyle(color: kscol)),
                                    );
                                  }).toList(),
                                ),
                                Text('Sem : '),
                                DropdownButton<String>(
                                  value: sem1,
                                  icon: Icon(
                                    Icons.arrow_downward,
                                    color: Colors.white,
                                  ),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(
                                      color: kpcol,
                                      fontWeight: FontWeight.w700),
                                  underline: Container(
                                    height: 2,
                                    color: kscol,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      sem1 = newValue;
                                    });
                                  },
                                  items: <String>[
                                    '1',
                                    '2',
                                    '3',
                                    '4',
                                    '5',
                                    '6',
                                    '7',
                                    '8',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value.toUpperCase(),
                                          style: TextStyle(color: kscol)),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            Text('Time : '),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    'From',
                                    style: TextStyle(color: kpcol),
                                  ),
                                  onPressed: () async {
                                    var time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    MaterialLocalizations localization =
                                        MaterialLocalizations.of(context);
                                    String formattedTime =
                                        localization.formatTimeOfDay(time,
                                            alwaysUse24HourFormat: false);
                                    setState(() {
                                      tFrom1 = formattedTime;
                                    });
                                  },
                                ),
                                Text(
                                    '- ${tFrom1 == null ? 'Pick Time' : tFrom1}')
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    'To',
                                    style: TextStyle(color: kpcol),
                                  ),
                                  onPressed: () async {
                                    var time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    MaterialLocalizations localization =
                                        MaterialLocalizations.of(context);
                                    String formattedTime =
                                        localization.formatTimeOfDay(time,
                                            alwaysUse24HourFormat: false);
                                    setState(() {
                                      tTo1 = formattedTime;
                                    });
                                  },
                                ),
                                Text('- ${tTo1 == null ? 'Pick Time' : tTo1}')
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
