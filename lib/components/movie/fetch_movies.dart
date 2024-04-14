import 'package:cloud_firestore/cloud_firestore.dart';

class MovieService {
  static Stream<QuerySnapshot> getMovies() {
    try {
      return FirebaseFirestore.instance.collection('series').snapshots();
    } catch (error) {
      print('Error fetching movies: $error');
      throw error; // Throw the error if there's an error
    }
  }
}
