import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as pa;

final String user_collection = "users";
final String post_collection = "posts";

class FirebaseService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  Map? currentUser;

  FirebaseService();

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential _userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password:
              password); //the sigin options returns user credential when signed in

      if (_userCredential != null) {
        currentUser = await getUserData(uid: _userCredential.user!.uid);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map> getUserData({required String uid}) async {
    DocumentSnapshot _doc =
        await _db.collection(user_collection).doc(uid).get();
    return _doc.data() as Map;
  }

  Future<bool> registerUser(
      {required String name,
      required String email,
      required String password,
      required File image}) async {
    try {
      UserCredential _userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      String _userId = _userCredential.user!.uid;
      String _fileName = Timestamp.now().millisecondsSinceEpoch.toString() +
          pa.extension(image.path).toString();
      UploadTask _task =
          _storage.ref('images/$_userId/$_fileName').putFile(image);
      return _task.then((_snapshot) async {
        String downloadURL = await _snapshot.ref.getDownloadURL();
        await _db.collection(user_collection).doc(_userId).set({
          "name": name,
          "email": email,
          "image": downloadURL,
        });
        return true;
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> postImage(File _image) async {
    try {
      String _userID = _auth.currentUser!.uid;
      String _fileName = Timestamp.now().millisecondsSinceEpoch.toString() +
          pa.extension(_image.path).toString();
      UploadTask _task =
          _storage.ref('images/$_userID/$_fileName').putFile(_image);
      return await _task.then((_snapshot) async {
        String _downloadURL = await _snapshot.ref.getDownloadURL();
        await _db.collection(post_collection).add({
          "userId": _userID,
          "timestamp": Timestamp.now(),
          "image": _downloadURL
        });
        return true;
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<QuerySnapshot> getLatestPosts() {
    //Snapshots return stream which represent a collection of fututre files
    // and this snapshots return the stream eveytime it encounters a change
    return _db
        .collection(post_collection)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
