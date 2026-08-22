import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final FirebaseAuth? _customAuth;
  final FirebaseFirestore? _customFirestore;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _customAuth = firebaseAuth,
        _customFirestore = firestore;

  FirebaseAuth get _firebaseAuth => _customAuth ?? FirebaseAuth.instance;
  FirebaseFirestore get _firestore => _customFirestore ?? FirebaseFirestore.instance;

  User? get currentUser {
    try {
      return _firebaseAuth.currentUser;
    } catch (_) {
      return null;
    }
  }

  Stream<User?> get userStream {
    try {
      return _firebaseAuth.userChanges();
    } catch (_) {
      return Stream.value(null);
    }
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String fullName,
    String phoneNumber = '',
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user != null) {
      await credential.user!.updateDisplayName(fullName);
      try {
        await credential.user!.sendEmailVerification();
      } catch (_) {}

      await _firestore.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'email': email,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return credential;
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential;
  }

  Future<void> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? farmName,
  }) async {
    final uid = currentUser?.uid;
    if (uid == null) return;

    final updates = <String, dynamic>{};
    if (fullName != null) updates['fullName'] = fullName;
    if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
    if (farmName != null) updates['farmName'] = farmName;

    if (updates.isNotEmpty) {
      await _firestore.collection('users').doc(uid).update(updates);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
