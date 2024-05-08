import 'package:cloud_firestore/cloud_firestore.dart';

class MovieService {
  static Future<QuerySnapshot> getMovies() async {
    try {
      return await FirebaseFirestore.instance.collection('series').get();
    } catch (error) {
      print('Error fetching movies: $error');
      throw error; // Throw the error if there's an error
    }
  }
}
