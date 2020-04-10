import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:jitfaculty/constents.dart';

class History extends StatefulWidget {
  static const routeName = 'history';

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String name = 'Leave';

  getUserData(String uid) async {
    name = await Firestore.instance
        .collection('user')
        .document(uid)
        .get()
        .then((documentSnapshot) {
      return documentSnapshot.data['name'].toString();
    });
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final String uid = ModalRoute.of(context).settings.arguments as String;
    getUserData(uid);

    return Scaffold(
      appBar: AppBar(
          title: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.ideographic,
        children: <Widget>[
          Text(name),
          SizedBox(width: 5),
          Text(
            'History',
            style: TextStyle(fontSize: 12),
          ),
        ],
      )),
      body: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('user/$uid/history')
                  .orderBy("date", descending: true)
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
      ),
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
            'Approval Date : ${DateFormat.yMMMd().add_jm().format(DateTime.parse(data['appdate']))}',
            style: TextStyle(fontSize: 15),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Leave Type : ${data['type'].toUpperCase()}',
              ),
              Text(
                'Days : ${data['leavedays']}',
              ),
            ],
          ),
          Text(
              'From : ${DateFormat.yMMMd().format(DateTime.parse(data['fromdate']))}'),
          Text(
              'To : ${DateFormat.yMMMd().format(DateTime.parse(data['todate']))}'),
          SizedBox(height: 10),
          Text('Form Submisson Date : '),
          Text(
            '${DateFormat.yMMMMEEEEd().add_jm().format(DateTime.parse(data['date']))}',
            style: TextStyle(color: Colors.brown, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
