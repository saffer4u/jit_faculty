import 'package:flutter/material.dart';
import 'package:jitfaculty/constents.dart';
import 'package:jitfaculty/screens/user/user_home.dart';
import 'package:jitfaculty/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class UserLeaveRequest extends StatefulWidget {
  static const routeName = 'user_leave_Request';
  @override
  _UserLeaveRequestState createState() => _UserLeaveRequestState();
}

class _UserLeaveRequestState extends State<UserLeaveRequest> {
  String name = '';
  String dept = '';
  String branch = '';
  String leaveType = 'cl';
  String designation;
  String leaveReason;
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
  String errorMsg = '';

  // For Date Calculation.
  DateTime inDate;

  // Alternate field variables.

  // Field 1.
  DateTime fDate1;
  String cls1;
  String sem1;
  String tFrom1 = '-';
  String tTo1 = '-';
  String roomNo1 = '-';
  String crSub1 = '-';
  String altSub1 = '-';
  String arrBy1 = '-';

  // Field 2.
  DateTime fDate2;
  String cls2;
  String sem2;
  String tFrom2 = '-';
  String tTo2 = '-';
  String roomNo2 = '-';
  String crSub2 = '-';
  String altSub2 = '-';
  String arrBy2 = '-';

  // Field 3.
  DateTime fDate3;
  String cls3;
  String sem3;
  String tFrom3 = '-';
  String tTo3 = '-';
  String roomNo3 = '-';
  String crSub3 = '-';
  String altSub3 = '-';
  String arrBy3 = '-';

  // Field 4.
  DateTime fDate4;
  String cls4;
  String sem4;
  String tFrom4 = '-';
  String tTo4 = '-';
  String roomNo4 = '-';
  String crSub4 = '-';
  String altSub4 = '-';
  String arrBy4 = '-';

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

  bool save = false;
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    // Date picker

    return Scaffold(
      appBar: (AppBar(
        title: Text('Application'),
      )),
      body: ModalProgressHUD(
        inAsyncCall: save,
        progressIndicator: CircularProgressIndicator(
          backgroundColor: kpcol,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
        child: SingleChildScrollView(
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
                        Expanded(
                            child: Text('DepartMent : ${dept.toUpperCase()}')),
                      ],
                    ),
                    Text('Branch : ${branch.toUpperCase()}'),
                    SizedBox(height: 20),
                    Text('Taken leave details : ',
                        style: TextStyle(fontSize: 20)),
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
              Column(
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
                          children: <Widget>[
                            Text('Required : '),
                            Text('*',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 20)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text('Type of leave : '),
                                Text('*', style: krequiredStyle),
                              ],
                            ),
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

                        SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            Text('Period of leave : '),
                            Text('*', style: krequiredStyle),
                          ],
                        ),
                        SizedBox(height: 10),
                        // Date picker
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              onPressed: () async {
                                DateTime now = DateTime.now();
                                if (leaveType == 'el') {
                                  inDate =
                                      DateTime(now.year, now.month, now.day)
                                          .add(Duration(days: 15));
                                } else if (leaveType == 'cl') {
                                  inDate = inDate =
                                      DateTime(now.year, now.month, now.day)
                                          .add(Duration(days: 3));
                                } else if (leaveType == 'eml') {
                                  inDate =
                                      DateTime(now.year, now.month, now.day)
                                          .subtract(Duration(days: 5));
                                } else {
                                  inDate = DateTime.now();
                                }

                                fromDate = await showDatePicker(
                                    context: context,

                                    //
                                    initialDate: inDate,
                                    firstDate:
                                        inDate.subtract(Duration(days: 1)),
                                    lastDate: inDate.add(Duration(days: 90)),
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
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'From',
                                    style: TextStyle(color: kpcol),
                                  ),
                                  Text('*', style: krequiredStyle),
                                ],
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
                                    initialDate: inDate,
                                    firstDate:
                                        inDate.subtract(Duration(days: 1)),
                                    lastDate:
                                        DateTime.now().add(Duration(days: 90)),
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
                                leaveDays = (toDate
                                        .difference(fromDate)
                                        .inDays
                                        .toInt() +
                                    1);
                                setState(() {});
                              },
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'To',
                                    style: TextStyle(color: kpcol),
                                  ),
                                  Text('*', style: krequiredStyle),
                                ],
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

                        //......
                        TextFormField(
                          autofocus: false,
                          decoration: kinputDecoration,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          onChanged: (input) => designation = input,
                        ),
                        TextFormField(
                          autofocus: false,
                          decoration: kinputDecoration.copyWith(
                              labelText: 'Reason for leave : *'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          onChanged: (input) => leaveReason = input,
                        ),
                        SizedBox(height: 10),
                        Text(errorMsg, style: TextStyle(color: Colors.red)),
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
                          padding: EdgeInsets.only(top: 25),
                          child: Center(
                              child: Text(
                            'Details of Alternate Arrangement\n( Optional )',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )),
                        ),

                        // Alternate fields.
                        // Field 1.
                        Container(
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.only(top: 25),
                          decoration: BoxDecoration(
                              color: kpcol,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Field : 1',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              Text('Timing : '),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    onPressed: () async {
                                      fDate1 = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime(2025),
                                          builder: (BuildContext context,
                                              Widget child) {
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
                                      'Date',
                                      style: TextStyle(color: kpcol),
                                    ),
                                  ),
                                  Text(
                                      '- ${fDate1 == null ? "Pick Date" : DateFormat.yMMMMEEEEd().format(fDate1)}'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                              CustomFormField(
                                labelText: 'Room No. :',
                                onTap: (input) => roomNo1 = input.toString(),
                              ),
                              CustomFormField(
                                labelText: 'Current Subject :',
                                onTap: (input) => crSub1 = input.toString(),
                              ),
                              CustomFormField(
                                labelText: 'Alternate Subject :',
                                onTap: (input) => altSub1 = input.toString(),
                              ),
                              CustomFormField(
                                labelText: 'Arranged By : ',
                                onTap: (input) => arrBy1 = input.toString(),
                              )
                            ],
                          ),
                        ),

                        // Field 2.
                        Container(
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.only(top: 25),
                          decoration: BoxDecoration(
                              color: kpcol,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Field : 2',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Class : '),
                                  DropdownButton<String>(
                                    value: cls2,
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
                                        cls2 = newValue;
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
                                    value: sem2,
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
                                        sem2 = newValue;
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
                              Text('Timing : '),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    onPressed: () async {
                                      fDate2 = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime(2025),
                                          builder: (BuildContext context,
                                              Widget child) {
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
                                      'Date',
                                      style: TextStyle(color: kpcol),
                                    ),
                                  ),
                                  Text(
                                      '- ${fDate2 == null ? "Pick Date" : DateFormat.yMMMMEEEEd().format(fDate2)}'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                        tFrom2 = formattedTime;
                                      });
                                    },
                                  ),
                                  Text(
                                      '- ${tFrom2 == null ? 'Pick Time' : tFrom2}')
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                        tTo2 = formattedTime;
                                      });
                                    },
                                  ),
                                  Text('- ${tTo2 == null ? 'Pick Time' : tTo2}')
                                ],
                              ),
                              CustomFormField(
                                labelText: 'Room No. :',
                                onTap: (input) => roomNo2 = input.toString(),
                              ),
                              CustomFormField(
                                labelText: 'Current Subject :',
                                onTap: (input) => crSub2 = input.toString(),
                              ),
                              CustomFormField(
                                labelText: 'Alternate Subject :',
                                onTap: (input) => altSub2 = input.toString(),
                              ),
                              CustomFormField(
                                labelText: 'Arranged By : ',
                                onTap: (input) => arrBy2 = input.toString(),
                              )
                            ],
                          ),
                        ),

                        // Field 3.
                        Container(
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.only(top: 25),
                          decoration: BoxDecoration(
                              color: kpcol,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Field : 3',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Class : '),
                                  DropdownButton<String>(
                                    value: cls3,
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
                                        cls3 = newValue;
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
                                    value: sem3,
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
                                        sem3 = newValue;
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
                              Text('Timing : '),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    onPressed: () async {
                                      fDate3 = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime(2025),
                                          builder: (BuildContext context,
                                              Widget child) {
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
                                      'Date',
                                      style: TextStyle(color: kpcol),
                                    ),
                                  ),
                                  Text(
                                      '- ${fDate3 == null ? "Pick Date" : DateFormat.yMMMMEEEEd().format(fDate3)}'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                        tFrom3 = formattedTime;
                                      });
                                    },
                                  ),
                                  Text(
                                      '- ${tFrom3 == null ? 'Pick Time' : tFrom3}')
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                        tTo3 = formattedTime;
                                      });
                                    },
                                  ),
                                  Text('- ${tTo3 == null ? 'Pick Time' : tTo3}')
                                ],
                              ),
                              CustomFormField(
                                labelText: 'Room No. :',
                                onTap: (input) => roomNo3 = input.toString(),
                              ),
                              CustomFormField(
                                labelText: 'Current Subject :',
                                onTap: (input) => crSub3 = input.toString(),
                              ),
                              CustomFormField(
                                labelText: 'Alternate Subject :',
                                onTap: (input) => altSub3 = input.toString(),
                              ),
                              CustomFormField(
                                labelText: 'Arranged By : ',
                                onTap: (input) => arrBy3 = input.toString(),
                              )
                            ],
                          ),
                        ),

                        // Field 4.
                        Container(
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.only(top: 25),
                          decoration: BoxDecoration(
                              color: kpcol,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Field : 4',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Class : '),
                                  DropdownButton<String>(
                                    value: cls4,
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
                                        cls4 = newValue;
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
                                    value: sem4,
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
                                        sem4 = newValue;
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
                              Text('Timing : '),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    onPressed: () async {
                                      fDate4 = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime(2025),
                                          builder: (BuildContext context,
                                              Widget child) {
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
                                      'Date',
                                      style: TextStyle(color: kpcol),
                                    ),
                                  ),
                                  Text(
                                      '- ${fDate4 == null ? "Pick Date" : DateFormat.yMMMMEEEEd().format(fDate4)}'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                        tFrom4 = formattedTime;
                                      });
                                    },
                                  ),
                                  Text(
                                      '- ${tFrom4 == null ? 'Pick Time' : tFrom4}')
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                        tTo4 = formattedTime;
                                      });
                                    },
                                  ),
                                  Text('- ${tTo4 == null ? 'Pick Time' : tTo4}')
                                ],
                              ),
                              CustomFormField(
                                labelText: 'Room No. :',
                                onTap: (input) => roomNo4 = input.toString(),
                              ),
                              CustomFormField(
                                labelText: 'Current Subject :',
                                onTap: (input) => crSub4 = input.toString(),
                              ),
                              CustomFormField(
                                labelText: 'Alternate Subject :',
                                onTap: (input) => altSub4 = input.toString(),
                              ),
                              CustomFormField(
                                labelText: 'Arranged By : ',
                                onTap: (input) => arrBy4 = input.toString(),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    width: double.infinity,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'SUBMIT',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: kpcol,
                              letterSpacing: 4),
                        ),
                      ),
                      onPressed: () {
                        if (leaveDays < 1 ||
                            designation == null ||
                            leaveReason == null) {
                          setState(() {
                            errorMsg = 'Please fill *required fields';
                          });

                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              title: Text('Please fill *required fields'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Ok'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        } else {
                          setState(() {
                            errorMsg = '';
                          });
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              title: Text('Submit Application'),
                              content: Text(
                                'Warning : Once application is submitted can not be chaged again',
                                style: TextStyle(color: Colors.red),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Submit'),
                                  onPressed: () async {
                                    String nowDate = DateTime.now().toString();
                                    // Next page logic.

                                    Navigator.pop(context);
                                    setState(() {
                                      save = true;
                                    });

                                    // Passing Data to hod.
                                    await Firestore.instance
                                        .collection('hodreq')
                                        .document(nowDate)
                                        .setData({
                                      'date': nowDate,
                                      'uid': uid,
                                      'name': name,
                                      'department': dept,
                                      'branch': branch,
                                      'el': el,
                                      'cl': cl,
                                      'od': od,
                                      'eml': eml,
                                      'lwp': lwp,
                                      'total': total,
                                      'type': leaveType,
                                      'fromdate': fromDate.toString(),
                                      'todate': toDate.toString(),
                                      'leavedays': leaveDays,
                                      'designation': designation,
                                      'reason': leaveReason,

                                      // Form fields.
                                      'cls1': cls1,
                                      'cls2': cls2,
                                      'cls3': cls3,
                                      'cls4': cls4,
                                      'sem1': sem1,
                                      'sem2': sem2,
                                      'sem3': sem3,
                                      'sem4': sem4,
                                      'fdate1': fDate1 == null
                                          ? '-'
                                          : fDate1.toString(),
                                      'fdate2': fDate2 == null
                                          ? '-'
                                          : fDate2.toString(),
                                      'fdate3': fDate3 == null
                                          ? '-'
                                          : fDate3.toString(),
                                      'fdate4': fDate4 == null
                                          ? '-'
                                          : fDate4.toString(),
                                      'tfrom1': tFrom1,
                                      'tfrom2': tFrom2,
                                      'tfrom3': tFrom3,
                                      'tfrom4': tFrom4,
                                      'tto1': tTo1,
                                      'tto2': tTo2,
                                      'tto3': tTo3,
                                      'tto4': tTo4,
                                      'roomno1': roomNo1,
                                      'roomno2': roomNo2,
                                      'roomno3': roomNo3,
                                      'roomno4': roomNo4,
                                      'crsub1': crSub1,
                                      'crsub2': crSub2,
                                      'crsub3': crSub3,
                                      'crsub4': crSub4,
                                      'altsub1': altSub1,
                                      'altsub2': altSub2,
                                      'altsub3': altSub3,
                                      'altsub4': altSub4,
                                      'arrby1': arrBy1,
                                      'arrby2': arrBy2,
                                      'arrby3': arrBy3,
                                      'arrby4': arrBy4,
                                    });

                                    // Passing data to user application.
                                    await Firestore.instance
                                        .collection('user/$uid/applications')
                                        .document(nowDate)
                                        .setData({
                                      'date': nowDate,
                                      'type': leaveType,
                                      'fromdate': fromDate.toString(),
                                      'todate': toDate.toString(),
                                      'leavedays': leaveDays,
                                      'reason': leaveReason,
                                      'apdbyhod': 'Not yet',
                                      'apdbyprincipal': 'Not yet',
                                      // Form fields.
                                      'cls1': cls1,
                                      'cls2': cls2,
                                      'cls3': cls3,
                                      'cls4': cls4,
                                      'sem1': sem1,
                                      'sem2': sem2,
                                      'sem3': sem3,
                                      'sem4': sem4,
                                      'fdate1': fDate1 == null
                                          ? '-'
                                          : fDate1.toString(),
                                      'fdate2': fDate2 == null
                                          ? '-'
                                          : fDate2.toString(),
                                      'fdate3': fDate3 == null
                                          ? '-'
                                          : fDate3.toString(),
                                      'fdate4': fDate4 == null
                                          ? '-'
                                          : fDate4.toString(),
                                      'tfrom1': tFrom1,
                                      'tfrom2': tFrom2,
                                      'tfrom3': tFrom3,
                                      'tfrom4': tFrom4,
                                      'tto1': tTo1,
                                      'tto2': tTo2,
                                      'tto3': tTo3,
                                      'tto4': tTo4,
                                      'roomno1': roomNo1,
                                      'roomno2': roomNo2,
                                      'roomno3': roomNo3,
                                      'roomno4': roomNo4,
                                      'crsub1': crSub1,
                                      'crsub2': crSub2,
                                      'crsub3': crSub3,
                                      'crsub4': crSub4,
                                      'altsub1': altSub1,
                                      'altsub2': altSub2,
                                      'altsub3': altSub3,
                                      'altsub4': altSub4,
                                      'arrby1': arrBy1,
                                      'arrby2': arrBy2,
                                      'arrby3': arrBy3,
                                      'arrby4': arrBy4,
                                    });
                                    setState(() {
                                      save = false;
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomFormField extends StatelessWidget {
  final Function onTap;
  final String labelText;
  CustomFormField({this.onTap, this.labelText});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      decoration: kinputDecoration.copyWith(labelText: labelText),
      style: TextStyle(
        color: Colors.white,
        fontSize: 15,
      ),
      onChanged: onTap,
    );
  }
}
