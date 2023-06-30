import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoriquePage extends StatelessWidget {
  final String userId;

  const HistoriquePage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historique des parties'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('scores')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Erreur de chargement des données');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Chargement des données...');
          }

          List<QueryDocumentSnapshot> scoreDocuments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: scoreDocuments.length,
            itemBuilder: (BuildContext context, int index) {
              String scoreId = scoreDocuments[index].id;
              int scoreGlobal = scoreDocuments[index]['scoreglobal'];

              return ListTile(
                title: Text("Game"),
                subtitle: Text('Score global : $scoreGlobal'   'Score'   ),
              );
            },
          );
        },
      ),
    );
  }
}

class MonHistoriquePage extends StatelessWidget {
  final String userId;

  MonHistoriquePage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon historique de parties'),
        backgroundColor: Colors.red,
      ),
      body: HistoriquePage(userId: userId),
    );
  }
}

class HomePage extends StatelessWidget {
  final String _userId = 'votre_user_id'; // Remplacez par votre propre user id

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MonHistoriquePage(userId: _userId),
              ),
            );
          },
          child: Text('Mon historique de parties'),
        ),
      ),
    );
  }
}
