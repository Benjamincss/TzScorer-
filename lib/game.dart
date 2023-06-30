import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class game extends StatefulWidget {
  const game({Key? key}) : super(key: key);

  @override
  State<game> createState() => _gameState();
}

class _gameState extends State<game> {
  late SharedPreferences _prefs;
  late CollectionReference<Map<String, dynamic>> _scoresCollection;
  late int _knifeThrows;
  List<int> scoreRound = [];
  int scoreGlobal = 0;

  // stats  variables


  int numberOfFives = 0;
  int worstSeries = 0;
  int currentSeries = 0;
  int bestRoundScore = 0;
  int totalZeros = 0;
//





  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
    _initFirebase();
  }

  void _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _initFirebase() async {
    await Firebase.initializeApp();
    _scoresCollection = FirebaseFirestore.instance.collection('scores');
  }

  @override
  int _scoresEntered = 0;
  int _round = 1;
  int _distance = 3;
  late int lastScoreEntered;
  bool _highlight = false;
  late int iscolor;
  Map<int, Map<int, List<dynamic>>> _scores = {
    3: {1: ['-', '-', '-'], 2: ['-', '-', '-'], 3: ['-', '-', '-']},
    4: {1: ['-', '-', '-'], 2: ['-', '-', '-'], 3: ['-', '-', '-']},
    5: {1: ['-', '-', '-'], 2: ['-', '-', '-'], 3: ['-', '-', '-']},
    6: {1: ['-', '-', '-'], 2: ['-', '-', '-'], 3: ['-', '-', '-']},
    7: {1: ['-', '-', '-'], 2: ['-', '-', '-'], 3: ['-', '-', '-']},
  };



  String _prefsKey = 'myPrefsKey';

  void _saveScores() async {
    await _prefs.setString(_prefsKey, json.encode(_scores));
  }

  Future<void> _sendScoreToFirebase() async {
    try {
      // Récupérer l'utilisateur actuellement authentifié
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Un utilisateur est connecté
        String userId = user.uid;

        // Créer une nouvelle collection pour l'utilisateur
        CollectionReference userCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('scores');

        // Créer un nouveau document pour stocker le score
        await userCollection.add({'scoreglobal': scoreGlobal  , 'five':numberOfFives });
       
      } else {
        // Aucun utilisateur n'est connecté
        print("Aucun utilisateur n'est connecté.");
      }
    } catch (e) {
      print("Erreur lors de l'envoi du score à Firebase : $e");
    }
  }




  void _removeScore() {
    setState(() {
      _scoresEntered--;
      if (_scoresEntered < 0) {
        _distance--;
        if (_distance < 3) {
          _distance = 7;
          _round--;

          if (_round < 1) {
            // Code pour gérer le début des lanceaux
          }
        }
        _scoresEntered = 2;
      }
      _scores[_distance]![_round]![_scoresEntered] = '-';
    });
  }


  void _addScore(int score) {
    setState(() {
      _scores[_distance]?[_round]?[_scoresEntered] = score;
      // Calcul des statistiques
      if (score == 5) {
        numberOfFives++;
      }
      if (score == 0) {
        currentSeries = 0;
        totalZeros++;
      } else {
        currentSeries++;
        if (currentSeries > worstSeries) {
          worstSeries = currentSeries;
        }
      }
      if (score > bestRoundScore) {
        bestRoundScore = score;
      }
      // Fin du calcul des statistiques

      scoreRound.add(score);
      _scoresEntered++;
      if (_scoresEntered >= 3) {
        _scoresEntered = 0;
        _distance++;
        if (_distance > 7) {
          _distance = 3;
          _round++;
          if (_round > 3) {
            scoreGlobal = scoreRound.reduce((a, b) => a + b);
            _sendScoreToFirebase();
          }
        }
      }
    });

    _saveScoreLocally();
  }


    void _saveScoreLocally() {
    _prefs.setInt('score', _scores[_distance]![_round]!.reduce((a, b) => a + b));
  }








  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        backgroundColor: Color(0xFF2D2929),
        body: Column(
            children: [

              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Container(
                  child: Table(
                    columnWidths: {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        children: [
// Colonne 1
                          Text('', style: TextStyle(
                              color: Colors.white, fontSize: 20)),
                          Text('Round 1', style: TextStyle(
                              color: _round == 1 ? Colors.red : Colors.white, fontSize: 20)),
                          Text('Round 2', style: TextStyle(
                              color: _round == 2 ? Colors.red : Colors.white, fontSize: 20)),
                          Text('Round 3', style: TextStyle(
                              color: _round == 3 ? Colors.red : Colors.white, fontSize: 20)),
                        ],
                      ),
// Colonne 2
                      for (int i = 3; i <= 7; i++)
                        TableRow(
                          children: [
                            Text(i.toString() + 'M', style: TextStyle(
                                color: _distance == i ? Colors.red : Colors.white, fontSize: 18)),
                            for (int j = 1; j <= 3; j++)
                              Text(
                                _scores[i]![j].toString()
                                    .replaceAll('[', '')
                                    .replaceAll(']', '')
                                    .replaceAll(',', ''),
                                style: _distance == i && _round == j
                                    ? TextStyle(color: Colors.red, fontSize: 18)
                                    : TextStyle(color: Colors.white, fontSize: 18),


                              ),
                          ],
                        ),
                    ],
                  ),
                  
                  
                  
                ),
                
              )
              
              ,Text(scoreGlobal.toString())
              , Text(totalZeros.toString() )

              , Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildScoreButton(0, Colors.red),
                        SizedBox(width: 10),
                        _buildScoreButton(1, Colors.orange),
                        SizedBox(width: 10),
                        _buildScoreButton(2, Colors.yellow),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildScoreButton(3, Colors.greenAccent),
                        SizedBox(width: 10),
                        _buildScoreButton(4, Colors.lightGreen),
                        SizedBox(width: 10),
                        _buildScoreButton(5, Colors.green),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: TextButton(
                              onPressed: () {
                                // handle button press
                              },
                              child: Text(
                                'Color',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red,
                            ),
                            child: TextButton(
                              onPressed: () {
                                _removeScore();
                              },
                              child: Text(
                                'Supprimer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),


// ...


            ])

    );
  }


  Widget _buildScoreButton(int score, Color color) {
    return Container(
      width: 100,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: FloatingActionButton(
        onPressed: () => _addScore(score),
        child: Text(
          score.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  Widget _buildActionButton(String label) {
    return Container(
      width: 160,
      height: 80,
      child: FloatingActionButton(
        onPressed: () {
          if (label == "Supprimer") {
            _removeScore();
          } else if (label == "Color") {

          }
        },
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }

}