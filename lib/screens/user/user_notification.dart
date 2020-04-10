import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jitfaculty/constents.dart';
import 'package:intl/intl.dart';

class UserNotification extends StatefulWidget {
  String uid;
  UserNotification({this.uid});
  @override
  _UserNotificationState createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('user/${widget.uid}/notification')
                .orderBy("time", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final messages = snapshot.data.documents;
                List<RequestBubble> messageWidgets = [];
                for (var message in messages) {
                  final msg = message.data;
                  final messageWidget = RequestBubble(
                    data: msg,
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
  Map<String, dynamic> data;

  RequestBubble({this.data});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
            'Your leave application for ${data['type']} \nFrom : ${DateFormat.yMMMd().format(DateTime.parse(data['fromdate']))} \nTo : ${DateFormat.yMMMd().format(DateTime.parse(data['todate']))} \nis ${data['approval']} by ${data['apdby']}',
            style: TextStyle(fontSize: 15),
          ),
          Row(
            children: <Widget>[
              Text(
                'Message : ',
                style: TextStyle(fontSize: 20),
              ),
              Flexible(
                child: Text(
                  data['message'],
                  style: TextStyle(
                      fontSize: 18, color: kscol, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Time : ${DateFormat.yMMMMEEEEd().add_jm().format(DateTime.parse(data['time']))}',
            style: TextStyle(color: Colors.brown, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
