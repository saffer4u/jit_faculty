import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jitfaculty/screens/history.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8),
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('user').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data.documents;
            List<RequestBubble> messageWidgets = [];
            for (var message in messages) {
              final docId = message.reference.documentID;
              Map<String, dynamic> mapOfData = message.data;

              final messageWidget = RequestBubble(
                data: mapOfData,
                uid: docId,
              );
              if (mapOfData['auth'] == 'faculty') {
                messageWidgets.add(messageWidget);
              }
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
    );
  }
}

class RequestBubble extends StatelessWidget {
  Map<String, dynamic> data;
  String uid;
  RequestBubble({this.data, this.uid});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Color(0xFFE9761E), borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Name : ${data['name']}'),
            Text('Email : ${data['email']}'),
            Text('Department : ${data['department'].toUpperCase()}'),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('CL : ${data['cl']}'),
                Text('EL : ${data['el']}'),
                Text('EML : ${data['eml']}'),
                Text('LWP : ${data['lwp']}'),
                Text(
                    'Total : ${data['cl'] + data['el'] + data['eml'] + data['lwp']}'),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, History.routeName, arguments: uid);
      },
    );
  }
}

// ${data['cl'] + data['el'] + data['eml'] + data['lwp']}
