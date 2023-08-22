import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'page1.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () => _login(), child: Text('Login')),
            ElevatedButton(
                onPressed: () => register(), child: Text('Register')),
          ],
        ),
      )),
    );
  }

  _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: 'marwa@gmail.com', password: '123456789');
      // print(userCredential.user!.uid);
      // Navigator.push(context, MaterialPageRoute(builder: (context) => Page1(),));
      Navigator.pushNamed(context, '/page1');
    } on FirebaseException catch (e) {
      print(e.code);
      print(e.message);
    }
  }

  register() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: 'eng_marwa@gmail.com', password: '123456789');
      print(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      print(e.message);
    }
  }
}
