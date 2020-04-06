import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jitfaculty/services/auth.dart';

class Database {
  Firestore _firestore = Firestore.instance;

  String newUserUID;

  // For User leave request.

//  Future getUserInfoByUId({String uid}) async {
//    DocumentSnapshot result = await _firestore
//        .collection('user')
//        .document(uid)
//        .get()
//        .then((documentSnapshot) {
//      return documentSnapshot;
//    });
//  }

  // For Home page
  Future getUserInfo({String uid, String doc}) async {
    var result = await _firestore
        .collection('user')
        .document(uid)
        .get()
        .then((documentSnapshot) {
      return documentSnapshot.data[doc].toString();
    });
    return result;
  }

  Future signuprequest({
    String name,
    String email,
    String password,
    String type,
    String department,
    String branch,
  }) async {
    try {
      await _firestore
          .collection('signuprequest')
          .document('${DateTime.now()}')
          .setData({
        'name': name,
        'email': email,
        'password': password,
        'type': type,
        'department': department,
        'branch': branch,
      });
    } catch (e) {
      print(e);
    }
  }

  Future deleteDocumentById({String docId}) async {
    await _firestore.document('signuprequest/$docId').delete();
  }

  Future addNewUserByAdmin({String docId}) async {
    DocumentSnapshot newUser = await _firestore
        .collection('signuprequest')
        .document(docId)
        .get()
        .then((documentSnapshot) {
      return documentSnapshot;
    });

    String name = newUser.data['name'];
    String email = newUser.data['email'].toString();
    String password = newUser.data['password'].toString();
    String type = newUser.data['type'].toString();
    String department = newUser.data['department'].toString();
    String branch = newUser.data['branch'].toString();

    FirebaseUser user = await Authenticate()
        .signUpWithEmailAndPassword(email: email, password: password);

    await _firestore.collection('user').document(user.uid).setData({
      'name': name,
      'email': email,
      'auth': type,
      'department': department,
      'branch': branch,
      'el': 0,
      'cl': 0,
      'od': 0,
      'eml': 0,
      'lwp': 0,
    });
    await pushNotificationUser(
        uid: user.uid,
        notification: 'Your account is created successfuly',
        message: 'Welcome $name');

    deleteDocumentById(docId: docId);
  }

  Future pushNotificationUser(
      {String uid, String notification, String message = ''}) async {
    await _firestore
        .collection('user/$uid/notification')
        .document('${DateTime.now()}')
        .setData({
      'notification': notification,
      'message': message,
      'time': '${DateTime.now()}',
    }).catchError((e) {
      print(e);
    });
  }
}
