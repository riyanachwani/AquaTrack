import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetching user ID
  Future<String> getUserId() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        return user.uid; // Return the user's ID
      } else {
        throw Exception('No user is logged in');
      }
    } catch (e) {
      throw Exception('Failed to get user ID: $e');
    }
  }

  // Fetching all fields for the user by their ID
  Future<DocumentSnapshot> getUserSettings(String userId) async {
    try {
      // Fetch the user document from Firestore using the user ID
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        return userSnapshot; // Return the DocumentSnapshot
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Failed to load user settings: $e');
    }
  }

  // Function to extract user data from snapshot
  Map<String, dynamic> getUserDataFromSnapshot(DocumentSnapshot snapshot) {
    var userData = snapshot.data() as Map<String, dynamic>;

    return {
      'Name': userData['Name'] ?? 'No Name',
      'Email': userData['Email'] ?? 'No Email',
      'Age': userData['Age'] ?? 0,
      'Wake-up Time': userData['Wake-up Time'] ?? 'Not Set',
      'Bedtime': userData['Bedtime'] ?? 'No Time',
      'Gender': userData['Gender'] ?? 'Not Specified',
      'Height': userData['Height'] ?? 0.0,
      'Weight': userData['Weight'] ?? 0.0,
      'targetIntake': userData['targetIntake']?.toDouble() ?? 0.0,
      'currentIntake': userData['currentIntake']?.toDouble() ?? 0.0,
      'currentIntakePercentage': userData['currentIntakePercentage'] ?? 0,
    };
  }

  // Updating Gender
  Future<void> updateGender(String userId, String newGender) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'Gender': newGender});
    } catch (e) {
      throw Exception('Failed to update Gender: $e');
    }
  }

// Updating Daily Goal
  Future<void> updateDailyGoal(String userId, double newGoal) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'targetIntake': newGoal});
    } catch (e) {
      throw Exception('Failed to update Daily Goal: $e');
    }
  }

// Updating Wakeup Time
  Future<void> updateWakeupTime(String userId, String wakeupTime) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'WakeupTime': wakeupTime});
    } catch (e) {
      throw Exception('Failed to update Wakeup Time: $e');
    }
  }

// Updating Bedtime
  Future<void> updateBedtime(String userId, String bedtime) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'Bedtime': bedtime});
    } catch (e) {
      throw Exception('Failed to update Bedtime: $e');
    }
  }

// Updating theme in Firebase
  Future<void> updateTheme(String userId, String theme) async {
    try {
      await _firestore.collection('users').doc(userId).update({'theme': theme});
    } catch (e) {
      throw Exception('Failed to update theme: $e');
    }
  }

  Future<String> getUserTheme(String userId) async {
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(userId).get();
      if (userSnapshot.exists) {
        return userSnapshot['theme'] ?? 'light'; // Default to 'light'
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Failed to fetch theme: $e');
    }
  }
}
