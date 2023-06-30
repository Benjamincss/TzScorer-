import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:throwing_zone/Home.dart';

import 'Login.dart';


class SingUpPage extends StatefulWidget {
  const SingUpPage({Key? key}) : super(key: key);

  @override
  _SingUpPageState createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  bool isActive = false;

  final userNameInputController = TextEditingController();
  final emailInputController = TextEditingController();
  final passwordInputController = TextEditingController();


  Future<void> signUp() async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailInputController.text,
          password: passwordInputController.text);
      print('User created: ${userCredential.user!.uid}');

      // Enregistrer les données utilisateur dans Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': userNameInputController.text,
        'email': emailInputController.text,
        'knifetrow': 0,
        'bestscore': 0,
      });


      // Naviguer vers la page de connexion après l'inscription réussie
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Le mot de passe est trop faible.');
      } else if (e.code == 'email-already-in-use') {
        print('Un compte avec cette adresse e-mail existe déjà.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF202020),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * .06,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Inscription',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Color(0xFFFFFFFF)),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: 'Nom',
                            hintStyle: TextStyle(
                                color: Colors.grey, fontSize: 14),
                            prefixIcon: Icon(
                              Icons.person_outline_sharp,
                              size: 22,
                              color: Color(0xFFD0272B),
                            )),
                        controller: userNameInputController,
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(
                                color: Colors.grey, fontSize: 14),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Color(0xFFD0272B),
                            )),
                        controller: emailInputController,
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: 'Mot de passe',
                            hintStyle: TextStyle(
                                color: Colors.grey, fontSize: 14),
                            prefixIcon: Icon(
                              Icons.edit,
                              color: Color(0xFFD0272B),
                            )),
                        controller: passwordInputController,)

                      ,Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: isActive,
                            onChanged: (value) =>
                                setState(() {
                                  isActive = value!;
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Text(
                              'I agree with the terms and conditions\nand privacy policy',
                              style: TextStyle(color: Colors.grey[400], fontSize: 10),
                            ),
                          ),
                        ],
                      ),



                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        child: MaterialButton(
                          color: const Color(0xFFD0272B),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: const Text(
                            'Valider mon compte ',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () async {
                            try {
                              UserCredential userCredential =
                              await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                  email: emailInputController.text,
                                  password: passwordInputController.text);
                              User? user = userCredential.user;
                              if (user != null) {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .set({
                                  'name': userNameInputController.text,
                                  'email': emailInputController.text,
                                  'knifetrow': 0,
                                  'bestscore': 0,
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const HomePageWidget()),
                                );
                              }
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                print('The password provided is too weak.');
                              } else if (e.code == 'email-already-in-use') {
                                print('The account already exists for that email.');
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),
                      ),



                    ]




                )



            )



        )
    );
  }}