import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p8/AppUser.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  late FirebaseAuth _auth;
  late DatabaseReference _ref;
  late User _currentUser;
  late FirebaseFirestore _fireStore;
  late Reference _storage;
  String url = '';

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _ref = FirebaseDatabase.instance.ref();
    _currentUser = _auth.currentUser!;
    _fireStore = FirebaseFirestore.instance;
    _storage = FirebaseStorage.instance.ref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              },
              child: Text('SignOut'))
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          Text('Save User Data in Firebase Database'),
          ElevatedButton(onPressed: () => _saveUserData(), child: Text('Save')),
          ElevatedButton(onPressed: () => _viewUserdata(), child: Text('View')),
          Divider(
            thickness: 2,
          ),
          Text('Save User Data in Firestore'),
          ElevatedButton(
              onPressed: () => _saveInFireStore(), child: Text('Save')),
          ElevatedButton(
              onPressed: () => _viewFromFireStore(), child: Text('View')),
          Divider(
            thickness: 2,
          ),
          Text('Upload User Picture'),
          ElevatedButton(
              onPressed: () => _uploadUserImage(), child: Text('Upload')),
          Visibility(
            child: Image.network(
              url,
              width: 200,
            ),
            visible: url.isNotEmpty,
          ),
          Divider(
            thickness: 2,
          ),
        ],
      )),
    );
  }

  _saveUserData() {
    AppUser _appUser = AppUser(
        displayName: 'Marwa',
        phoneNumber: '123598887956',
        email: _currentUser.email!,
        uid: _currentUser.uid);
    try {
      _ref
          .child('Users')
          .child(_currentUser.uid)
          .set(_appUser.toMap())
          .whenComplete(() => print('User data saved'));
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  _viewUserdata() {
    try {
      _ref.child('Users').child(_currentUser.uid).onValue.listen((event) {
        // print(event.snapshot.value);
        // print(event.snapshot.value.runtimeType);
        Map<String, dynamic> userMap =
            Map.from(event.snapshot.value as Map<Object?, Object?>);
        print(AppUser.fromMap(userMap).displayName);
      });
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  _saveInFireStore() {
    try {
      AppUser _appUser = AppUser(
          displayName: 'Marwa',
          phoneNumber: '123598887956',
          email: _currentUser.email!,
          uid: _currentUser.uid);
      _fireStore
          .collection('Users')
          .doc(_currentUser.uid)
          .set(_appUser.toMap())
          .whenComplete(() => print('User Data Saved'));
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  _viewFromFireStore() {
    _fireStore
        .collection('Users')
        .doc(_currentUser.uid)
        .snapshots()
        .listen((event) {
      // print(event.data());
      // print(event.data().runtimeType);
      print(AppUser.fromMap(event.data()!).displayName);
    });

    // _fireStore.collection('Users').doc(_currentUser.uid).get().then((event) {
    //   // print(event.data());
    //   // print(event.data().runtimeType);
    // });
  }

  _uploadUserImage() {
    _openImagePicker();
  }

  Future<void> _openImagePicker() async {
    ImagePicker picker = ImagePicker();
    XFile? xFile = await picker.pickImage(source: ImageSource.camera);
    if (xFile != null) {
      _saveProfilePicture(xFile.path);
    }
  }

  void _saveProfilePicture(String path) {
    try {
      File file = File(path);
      var microsecond = DateTime.now().microsecond;
      UploadTask uploadTask = _storage
          .child('images')
          .child(_currentUser.uid)
          .child('pic_$microsecond')
          .putFile(file);
      uploadTask.then((task) async {
        url = await task.ref.getDownloadURL();
        setState(() {});
      });
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }
}
