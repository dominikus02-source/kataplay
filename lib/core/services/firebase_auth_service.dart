import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signInAnonymously() => _auth.signInAnonymously();

  Future<UserCredential> signInWithEmailPassword(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> createUserWithEmailPassword(String email, String password) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  Future<void> signOut() => _auth.signOut();

  Future<void> saveProgressToFirestore({
    required String userId,
    required int xp,
    required int streak,
    required Set<String> completedLessonIds,
    required Set<String> collectedBadges,
    required int currentLevelIndex,
    required String selectedAvatarId,
  }) async {
    await _firestore.collection('users').doc(userId).set({
      'xp': xp,
      'streak': streak,
      'completedLessonIds': completedLessonIds.toList(),
      'collectedBadges': collectedBadges.toList(),
      'currentLevelIndex': currentLevelIndex,
      'selectedAvatarId': selectedAvatarId,
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> loadProgressFromFirestore(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data();
  }
}
