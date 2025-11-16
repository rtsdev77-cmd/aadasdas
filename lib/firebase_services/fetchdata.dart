import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

double movingLat = 0;
double movingLong = 0;

class FetchingServices with ChangeNotifier {

  final FirebaseFirestore _firebaseStorage = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> getLocation(
      {required String lorryId}) {
    return _firebaseStorage.collection("Lorryownersubdriver").doc(lorryId).snapshots();
  }
}