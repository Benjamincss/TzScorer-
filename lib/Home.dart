import 'package:flutter/material.dart';
import 'game.dart';
import 'test.dart';
import 'scoreboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:throwing_zone/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<bool> _selection;
  String? _selectedProfile;
  FirebaseAuth _auth = FirebaseAuth.instance;
  late String _userId;

  List<String> _profiles = ['default'];

  List<Map<String, dynamic>> listeHistorique = [
    {
      'date': '01/01/2022',
      'mode': 'Classique',
      'score': 150
    },
    {
      'date': '05/02/2022',
      'mode': 'Rapide',
      'score': 80
    },
    {
      'date': '15/03/2022',
      'mode': 'Classique',
      'score': 200
    },
    {
      'date': '22/04/2022',
      'mode': 'Rapide',
      'score': 100
    },
  ];

  @override
  void initState() {
    super.initState();
    _selection = List<bool>.filled(8, false);
    _loadProfiles();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
    }

  }

  void _addNewProfile(String name) {
    setState(() {
      _profiles.add(name);
      _selectedProfile = name;
    });
    _saveProfiles();
  }


  void _loadProfiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? profiles = prefs.getStringList('profiles');
    if (profiles != null) {
      setState(() {
        _profiles = profiles;
        _selectedProfile = _profiles[0];
      });
    }
  }



  Future<void> _saveProfiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('profiles', _profiles);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D2929),
      appBar: AppBar(
        backgroundColor: Colors.transparent,

      ),
      drawer: Drawer(
        child: StreamBuilder<User?>(
          stream: _auth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              User user = snapshot.data!;
              return ListView(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(user.displayName ?? 'default'),
                    accountEmail: Text(user.email ?? ''),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(user.displayName?[0].toUpperCase() ?? 'D'),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFD0272B),
                    ),
                  ),

                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Paramètres'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Déconnexion'),
                    onTap: () async {
                      await _auth.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePageWidget()),
                      );

                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.language),
                    title: Text('Changer la langue'),
                    onTap: () {
                      // TODO : Ajouter la logique pour changer la langue
                    },
                  ),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),


      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              child: Image.network("https://zupimages.net/up/23/03/k5sh.png"),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 45),
              child: Container(
                width: 339,
                height: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color(0xFFF3F3F3),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                  child:DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2.0),),
                      labelText: 'Profile',
                      labelStyle: TextStyle(color: Colors.red),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    ),
                    value: _selectedProfile,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedProfile = newValue;
                        if (_selectedProfile == 'Créer un profil') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              String newProfileName = '';

                              return AlertDialog(




                                backgroundColor: Colors.black ,
                                title: Text('Créer un profil'),
                                titleTextStyle: TextStyle(color: Colors.white),
                                content: TextField(
                                  style: TextStyle(color: Colors.white),
                                  onChanged: (value) => newProfileName = value,
                                  decoration: InputDecoration(



                                    hintText: 'Entrez un nom de profil',
                                    hintStyle: TextStyle(color: Colors.white),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      if (newProfileName.isNotEmpty) {
                                        setState(() {
                                          _profiles.add(newProfileName);
                                          _selectedProfile = newProfileName;

                                        });
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: Text('Enregistrer')
                                    ,
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text('Annuler'),
                                  ),
                                ],
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              ));
                            },
                          );
                        }
                      });
                    },
                    items: [..._profiles.map((profile) => DropdownMenuItem(        value: profile,        child: Text(profile),      )),      DropdownMenuItem(        value: 'Créer un profil',        child: Row(          children: [            Icon(Icons.add),            SizedBox(width: 8.0),            Text('Créer un profil'),          ],
                    ),
                    ),
                    ],
                    isExpanded: true,
                  ),
                ),
              ),
            ),
            ElevatedButton(

              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const game()),

                );
              },
              child: Text(
                "Demmarer un scoring",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFD0272B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                minimumSize: Size(359, 59),
              ),
            ),
            Divider(

              height: 45,
              thickness: 2,
              indent: 10,
              endIndent: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoriquePage(userId: _userId),
                  ),
                );

              },
              child: Text(
                "Mes stats",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFD0272B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                minimumSize: Size(150, 59),
              ),
            ),


            Padding(
              padding: const EdgeInsets.fromLTRB(0, 90, 0, 0),
              child: SingleChildScrollView(
                child: Container(
                  width: 300,
                  height: 310,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(31)
                  ),
                  child: ListView(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance.collection('users').doc(_userId).get(),
                              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Erreur de chargement des données');
                                }
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Text('Chargement des données...');
                                }
                                int bestscore = snapshot.data!['bestscore'];
                                return Container(
                                  child: Text(
                                    "Meilleure score  : $bestscore",
                                    style: TextStyle(fontSize: 25),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance.collection('users').doc(_userId).get(),
                              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Erreur de chargement des données');
                                }
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Text('Chargement des données...');
                                }
                                int knifetrow = snapshot.data!['knifetrow'];
                                return Container(
                                  child: Text(
                                    "Couteaux lancés : $knifetrow",
                                    style: TextStyle(fontSize: 25),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                            ),
                          ),



                        ],
                      )
                    ],
                  ),



              ),
            )




            )],
        ),
      ),
    );
  }
}
