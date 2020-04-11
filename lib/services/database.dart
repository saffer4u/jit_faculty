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

  Future addNewUserByAdmin(
      {String docId, int el, int cl, int od, int eml, int lwp}) async {
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

//    FirebaseUser user = await Authenticate()
//        .signUpWithEmailAndPassword(email: email, password: password);
//
//    await _firestore.collection('user').document(user.uid).setData({
//      'name': name,
//      'email': email,
//      'auth': type,
//      'department': department,
//      'branch': branch,
//      'el': el,
//      'cl': cl,
//      'od': od,
//      'eml': eml,
//      'lwp': lwp,
//    });

    String id = DateTime.now().toString();
    await Firestore.instance
        .collection('users_registrations')
        .document(id)
        .setData({
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'auth': type,
      'branch': branch,
      'el': el,
      'cl': cl,
      'od': od,
      'eml': eml,
      'lwp': lwp,
    });

    await deleteDocumentById(docId: docId);
  }
}
