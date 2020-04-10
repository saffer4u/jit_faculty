import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jitfaculty/constents.dart';
import 'package:intl/intl.dart';
import 'package:jitfaculty/services/database.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:core';

class Request extends StatefulWidget {
  @override
  _RequestState createState() => _RequestState();
}

class _RequestState extends State<Request> {
  bool save = false;
  void indicator() {
    setState(() {
      save ? save = false : save = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: CircularProgressIndicator(
        backgroundColor: kpcol,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
      inAsyncCall: save,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  Firestore.instance.collection('signuprequest').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data.documents;
                  List<RequestBubble> messageWidgets = [];
                  for (var message in messages) {
                    final docId = message.reference.documentID;
                    final name = message.data['name'];
                    final email = message.data['email'];
                    final type = message.data['type'];
                    final department = message.data['department'];
                    final branch = message.data['branch'];
                    final messageWidget = RequestBubble(
                      name: name,
                      email: email,
                      type: type,
                      department: department,
                      branch: branch,
                      docId: docId,
                      indicator: indicator,
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
  final String docId;
  final String name;
  final String email;
  final String type;
  final String department;
  final String branch;
  Function indicator;
  RequestBubble({
    this.docId,
    this.name,
    this.email,
    this.type,
    this.department,
    this.branch,
    this.indicator,
  });
  @override
  Widget build(BuildContext context) {
    String el = '';
    String cl = '';
    String od = '';
    String eml = '';
    String lwp = '';

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: kpcol,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          new BoxShadow(
            color: Colors.black54,
            blurRadius: 15.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Name : $name',
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  'Email : $email',
                  style: kreqBubbleFontStyle,
                ),
                Text(
                  'User type : ${type.toUpperCase()}',
                  style: kreqBubbleFontStyle,
                ),
                Text(
                  'Department : ${department.toUpperCase()}',
                  style: kreqBubbleFontStyle,
                ),
                Text(
                  'Branch : ${branch.toUpperCase()}',
                  style: kreqBubbleFontStyle,
                ),
                Text(
                    'Time : ${DateFormat.yMMMd().add_jm().format(DateTime.parse(docId))}'),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100)),
                  child: IconButton(
                    onPressed: () async {
//                      indicator();
//                      await Database().addNewUserByAdmin(docId: docId);
//                      indicator();

                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          title: Text('Already taken leave detail of : $name'),
                          content: Row(
                            children: <Widget>[
                              AlertFormField(
                                label: 'CL',
                                onChanged: (val) {
                                  cl = val;
                                },
                              ),
                              AlertFormField(
                                label: 'EL',
                                onChanged: (val) {
                                  el = val;
                                },
                              ),
                              AlertFormField(
                                label: 'LWP',
                                onChanged: (val) {
                                  lwp = val;
                                },
                              ),
                              AlertFormField(
                                label: 'OD',
                                onChanged: (val) {
                                  od = val;
                                },
                              ),
                              AlertFormField(
                                label: 'EML',
                                onChanged: (val) {
                                  eml = val;
                                },
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Approve'),
                              onPressed: () async {
                                Navigator.pop(context);
                                indicator();
                                await Database().addNewUserByAdmin(
                                  docId: docId,
                                  el: el == '' ? 0 : int.parse(el),
                                  cl: cl == '' ? 0 : int.parse(cl),
                                  od: od == '' ? 0 : int.parse(od),
                                  lwp: lwp == '' ? 0 : int.parse(lwp),
                                  eml: eml == '' ? 0 : int.parse(eml),
                                );

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
                    icon: Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100)),
                  child: IconButton(
                    splashColor: Colors.brown,
                    onPressed: () {
                      Database().deleteDocumentById(docId: docId);
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.red,
                      size: 20,
                    ),
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

class AlertFormField extends StatelessWidget {
  final String label;
  final Function onChanged;

  AlertFormField({this.onChanged, this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
        ),
        keyboardType: TextInputType.number,
        onChanged: onChanged,
      ),
    );
  }
}
