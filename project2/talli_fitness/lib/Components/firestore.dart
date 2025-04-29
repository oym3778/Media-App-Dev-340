/*

  This database stores routines that the users can edit, 
    it is stored in the speifc Users collection

  Each Routine Contains:
   - day of the week
   - list of exercises

  Well need the basic CRUD Commands
   -Create, we already have a default routine set up 
            within firestore when we register a user with an
            empty list of exercises, so create wont be necessary
   -Read,
   -Update,
   -Delete,

 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talli_fitness/Components/exercise.dart';

class FireStoreDatabase {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to get the user's document reference
  DocumentReference<Map<String, dynamic>> getUserRoutineDocRef() {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user logged in.'); // Or handle the null case as needed
    }
    return _firestore.collection("Users").doc(user.email);
  }

  // add/update routine to specific day
  Future<void> addExercise(String day, Exercise exercise) async {
    try {
      print(exercise.name.toString());
      final userRoutineDocRef = getUserRoutineDocRef();

      // https://firebase.google.com/docs/firestore/manage-data/add-data#dart
      // Construct the update data to add the exercise to the correct day's list
      //    
      //    If your document contains nested objects, you can use the dot notation to 
      //    reference nested fields within the document when you call update()
      //    arrayUnion is used for adding a new exercise to the end of the array instead of reseting the whole arrary
      //    https://firebase.google.com/docs/firestore/manage-data/add-data#update_elements_in_an_array TODO come back when you want to remove specifc array elements
      Map<String, dynamic> updateData = {
        'routine.$day': FieldValue.arrayUnion([exercise.toJson()]),
      };

      // Update the document with the new exercise
      await userRoutineDocRef.update(updateData);
      print('Exercise added successfully!');

    } catch (e) {
      print('Error adding exercise: $e');
    }
  }

  // get/read routines for a day
  void getWorkoutFromDay(String day) {
    getUserRoutineDocRef().get().then((event) {
        print("This is what event gets from \"user\" user.email ${event}");
    });
  }

  // Delete exercises from routine

  // streams coninuosly listen for changes... note to self
}