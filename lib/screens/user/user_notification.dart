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
                  final docId = message.reference.documentID;
                  final notification = message.data['notification'];
                  final msg = message.data['message'];
                  final messageWidget = RequestBubble(
                    message: msg,
                    notification: notification,
                    docId: docId,
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
  final String message;
  final String docId;
  final String notification;

  RequestBubble({this.message, this.notification, this.docId});
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
            message,
            style: TextStyle(fontSize: 25),
          ),
          Text(
            notification,
            style: TextStyle(fontSize: 18),
          ),
          Text(
            'Time : ${DateFormat.yMMMMEEEEd().add_jm().format(DateTime.parse(docId))}',
            style: TextStyle(color: Colors.brown),
          ),
        ],
      ),
    );
  }
}
