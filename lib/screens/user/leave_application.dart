import 'package:flutter/material.dart';
import 'package:jitfaculty/constents.dart';
import 'package:jitfaculty/screens/user/user_leave_request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class LeaveApplication extends StatefulWidget {
  String uid;
  LeaveApplication({this.uid});
  @override
  _LeaveApplicationState createState() => _LeaveApplicationState();
}

class _LeaveApplicationState extends State<LeaveApplication> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          width: double.infinity,
          child: RaisedButton(
            color: kpcol,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                'New Application',
                style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, UserLeaveRequest.routeName);
            },
          ),
        ),
        Divider(
          color: kpcol,
          indent: 40,
          endIndent: 40,
        ),

        // User application collection stream.

        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('user/${widget.uid}/applications')
                .orderBy("date", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final messages = snapshot.data.documents;
                List<RequestBubble> messageWidgets = [];
                for (var message in messages) {
                  // final date = message.reference.documentID;
                  Map<String, dynamic> mapOfData = message.data;

                  final messageWidget = RequestBubble(
                    data: mapOfData,
                  );
                  messageWidgets.add(messageWidget);
                }
                return ListView(
                  children: messageWidgets,
                );
              }
              return Center(
                child: Text('Please Wait...'),
              );
            },
          ),
        ),
      ],
    );
  }
}

class RequestBubble extends StatelessWidget {
  final Map<String, dynamic> data;
  RequestBubble({this.data});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
          color: Color(0xFF4700B9), borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: <Widget>[
                Text(
                  '-: Approval :-',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('HOD : ${data['apdbyhod']}'),
                    Text('Pricipal : ${data['apdbyprincipal']}'),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: kpcol,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                new BoxShadow(
                  color: Colors.black54,
                  blurRadius: 15.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Time : ${DateFormat.yMMMMEEEEd().add_jm().format(DateTime.parse(data['date']))}',
                  style: TextStyle(color: Colors.brown, fontSize: 12),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Type : ${data['type'].toUpperCase()}'),
                    Text('Days : ${data['leavedays']}'),
                  ],
                ),
                Text(
                    'From : ${DateFormat.yMMMMEEEEd().format(DateTime.parse(data['fromdate']))}'),
                Text(
                    'To : ${DateFormat.yMMMMEEEEd().format(DateTime.parse(data['todate']))}'),
                Text('Reson : ${data['reason']}'),
                SizedBox(height: 20),
                Text(
                  'Alternate Arrangement : ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                AlternateField(data: data, n: 1),
                AlternateField(data: data, n: 2),
                AlternateField(data: data, n: 3),
                AlternateField(data: data, n: 4),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AlternateField extends StatelessWidget {
  AlternateField({this.data, this.n});
  final int n;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Color(0xFFC96416), borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Field $n : '),
              Text(
                  'Date : ${data['fdate$n'] == '-' ? '-' : DateFormat.yMMMd().format(DateTime.parse(data['fdate$n']))}')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                  'Class : ${data['cls$n'] == null ? '-' : data['cls$n'].toUpperCase()}'),
              Text('Sem : ${data['sem$n'] == null ? '-' : data['sem$n']}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Room : '),
              Text('${data['roomno$n']}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Timing : '),
              Text('${data['tfrom$n']}  -  ${data['tto$n']}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Current Subject : '),
              Text('${data['crsub$n']}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Alternate Subject : '),
              Text('${data['altsub$n']}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Arranged By : '),
              Text('${data['arrby$n']}')
            ],
          ),
        ],
      ),
    );
  }
}
