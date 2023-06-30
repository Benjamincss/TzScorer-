import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Home.dart';

class sign extends StatefulWidget {
  const sign({Key? key}) : super(key: key);

  @override
  State<sign> createState() => _signState();
}

class _signState extends State<sign> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _email;
  late String _password;

  void _signInWithEmailAndPassword() async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      final User user = userCredential.user!;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Aucun utilisateur correspond à cet e-mail.');
      } else if (e.code == 'wrong-password') {
        print('Mauvais mot de passe fourni pour cet utilisateur.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 130, 0, 0),
            child: Container(
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Bon retour parmi nous",
                  style: const TextStyle(fontSize: 34),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 45, 0, 0),
            child: Container(
              width: 339,
              height: 59,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFF3F3F3),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                child: TextField(
                  textAlign: TextAlign.start,
                  decoration: const InputDecoration(labelText: "Adresse mail"),
                  onChanged: (value) {
                    _email = value;
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Container(
              width: 339,
              height: 59,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFF3F3F3),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                child: TextField(
                  textAlign: TextAlign.start,
                  decoration: const InputDecoration(labelText: "Mot de passe "),
                  onChanged: (value) {
                    _password = value;
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 120, 0, 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFFD0272B),
              ),
              width: 359,
              height: 59,
              child: TextButton(
                onPressed: _signInWithEmailAndPassword,
                child: const Text(
                  'Se connecter',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}