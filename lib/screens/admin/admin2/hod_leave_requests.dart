import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jitfaculty/constents.dart';
import 'package:intl/intl.dart';
import 'package:jitfaculty/screens/history.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class HodLeaveRequests extends StatefulWidget {
  final String hodBranch;
  HodLeaveRequests({this.hodBranch});
  @override
  _HodLeaveRequestsState createState() => _HodLeaveRequestsState();
}

class _HodLeaveRequestsState extends State<HodLeaveRequests> {
  bool save = false;
  void indicator() {
    setState(() {
      save = !save;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: save,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: kpcol,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('hodreq')
              .orderBy("date", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final messages = snapshot.data.documents;
              List<RequestBubble> messageWidgets = [];
              for (var message in messages) {
                final docId = message.reference.documentID;
                Map<String, dynamic> mapOfData = message.data;

                final messageWidget = RequestBubble(
                  data: mapOfData,
                  indicator: indicator,
                  docId: docId,
                );
                if (widget.hodBranch.toLowerCase() == mapOfData['branch']) {
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
      ),
    );
  }
}

class RequestBubble extends StatelessWidget {
  final Map<String, dynamic> data;
  Function indicator;
  String msg = '';
  String docId;
  RequestBubble({this.data, this.indicator, this.docId});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
          color: Color(0xFF4700B9), borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(child: Text('Name : ${data['name']}')),
//                    Expanded(
//                        child: Text(
//                            'Department : ${data['department'].toUpperCase()}')),
                  ],
                ),
                Text('Department : ${data['branch'].toUpperCase()}'),
                SizedBox(height: 2),
                Text('Taken leave details : ', style: TextStyle(fontSize: 20)),
                SizedBox(height: 1),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text('EL : ${data['el']}'),
                        Text('CL : ${data['cl']}'),
                        Text('OD : ${data['od']}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text('EML : ${data['eml']}'),
                        Text('LWP : ${data['lwp']}'),
                        Text('Total : ${data['total']}'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              title: Text('Approve Leave Application'),
                              content: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Message'),
                                onChanged: (val) {
                                  msg = val;
                                },
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Approve'),
                                  onPressed: () async {
                                    DateTime nowTime = DateTime.now();
                                    Navigator.pop(context);
                                    indicator();

                                    // 1.Pushing to principal.
                                    await Firestore.instance
                                        .collection('principalreq')
                                        .document('$nowTime')
                                        .setData(data);

                                    // 2.Sending notification to user.
                                    await Firestore.instance
                                        .collection(
                                            'user/${data['uid']}/notification')
                                        .document('$nowTime')
                                        .setData({
                                      'time': nowTime.toString(),
                                      'type': data['type'].toUpperCase(),
                                      'fromdate': data['fromdate'],
                                      'todate': data['todate'],
                                      'apdby': 'HOD',
                                      'approval': 'approved',
                                      'message': msg,
                                    });

                                    // 3.Writing Approved by HOD in application.
                                    await Firestore.instance
                                        .collection(
                                            'user/${data['uid']}/applications')
                                        .document('${data['date']}')
                                        .updateData({
                                      'apdbyhod': 'Approved',
                                    });

                                    // 4. Delete document from hodReq.
                                    await Firestore.instance
                                        .collection('hodreq')
                                        .document(docId)
                                        .delete();

                                    indicator();
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
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              title: Text('Reject Leave Application'),
                              content: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Message',
                                ),
                                onChanged: (val) {
                                  msg = val;
                                },
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                    'Reject',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () async {
                                    DateTime nowTime = DateTime.now();
                                    Navigator.pop(context);
                                    indicator();

                                    //1. Sending notification to user.
                                    await Firestore.instance
                                        .collection(
                                            'user/${data['uid']}/notification')
                                        .document('$nowTime')
                                        .setData({
                                      'time': nowTime.toString(),
                                      'type': data['type'].toUpperCase(),
                                      'fromdate': data['fromdate'],
                                      'todate': data['todate'],
                                      'apdby': 'HOD',
                                      'approval': 'rejected',
                                      'message': msg,
                                    });

                                    //2. Writing Rejected by HOD in application.
                                    await Firestore.instance
                                        .collection(
                                            'user/${data['uid']}/applications')
                                        .document('${data['date']}')
                                        .updateData({
                                      'apdbyhod': 'Rejected',
                                    });

                                    // 3. Delete document from hod req.
                                    await Firestore.instance
                                        .collection('hodreq')
                                        .document(docId)
                                        .delete();

                                    indicator();
                                  },
                                ),
                                FlatButton(
                                  child: Text('Cancel'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: FlatButton(
                        child: Text(
                          'History',
                          style: TextStyle(
                              color: kpcol,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, History.routeName,
                              arguments: data['uid']);
                        },
                      ),
                    ),
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
