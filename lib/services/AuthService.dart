import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sari_sales/models/Users.dart';
import 'package:uuid/uuid.dart';

class AuthService extends ChangeNotifier {
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  bool _isSuccess;

  bool get isSuccess => _isSuccess;

  Future<bool> registration (_user, email, password) async {
    String shortId = Uuid().v4();
    List<String> splitId = shortId.split('-');
      try {
        final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        await Users.saveUserInformation(_user.toJson());
        await Users.userSaveStatusPersistent('trial');
        if(newUser != null) {
          final uid = await FirebaseAuth.instance.currentUser();
          _user.uuid = uid.uid;
          //saving information to database
          _firestore.collection('users').document(uid.uid).setData({
            'name': _user.name,
            'address': _user.address,
            'contact': _user.contact,
            'status': 'trial',
            'email': _user.email,
            'shortId': splitId[0]
          });

          _firestore.collection('shared').document(splitId[0]).setData({
            'owner': _user.name,
            'primary_id': uid.uid,
            'inventory': [],
            'sales': [],
            'loans': [],
          });

        }
        return true;
      } catch(e) {
        return false;
      }
  }

  Future<bool> login (userProvider, email, password) async {
    try {
      final signUser = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if(signUser != null) {
        final userId = await _auth.currentUser();
        DocumentSnapshot querySnapshot = await Firestore.instance
            .collection('users')
            .document(userId.uid)
            .get();

        if (querySnapshot.exists) {
          print('success');
          userProvider.name = querySnapshot.data['name'];
          userProvider.address = querySnapshot.data['address'];
          userProvider.contact = querySnapshot.data['contact'];
          userProvider.email = querySnapshot.data['email'];
          userProvider.shortId = querySnapshot.data['shortId'];

          await Users.saveUserInformation(userProvider.toJson());
          await Users.userSaveStatusPersistent(querySnapshot.data['status']);
          userProvider.loginUser(userProvider.toJson());
        }
        return true;
      }
    } catch (e) {
      return false;
    }
  }

}
