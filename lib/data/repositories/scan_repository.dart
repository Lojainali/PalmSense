import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/scan_model.dart';

class ScanRepository {
  final FirebaseFirestore? _customFirestore;
  final FirebaseStorage? _customStorage;
  final FirebaseAuth? _customAuth;

  ScanRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    FirebaseAuth? auth,
  })  : _customFirestore = firestore,
        _customStorage = storage,
        _customAuth = auth;

  FirebaseFirestore get _firestore => _customFirestore ?? FirebaseFirestore.instance;
  FirebaseStorage get _storage => _customStorage ?? FirebaseStorage.instance;
  FirebaseAuth get _auth => _customAuth ?? FirebaseAuth.instance;

  String? get currentUserId {
    try {
      return _auth.currentUser?.uid;
    } catch (_) {
      return null;
    }
  }

  /// Uploads palm leaf photo to Firebase Storage and returns public download URL
  Future<String> uploadLeafImage(File imageFile) async {
    final uid = currentUserId ?? 'guest';
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = _storage.ref().child('scans/$uid/$fileName');
    final uploadTask = await ref.putFile(imageFile);
    return await uploadTask.ref.getDownloadURL();
  }

  /// Saves a scan result into Firestore under users/{uid}/scans
  Future<void> saveScanRecord(ScanModel scan) async {
    final uid = currentUserId;
    if (uid == null) return;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('scans')
        .doc(scan.id)
        .set(scan.toJson());
  }

  /// Listens to real-time scan history stream for the current logged-in user
  Stream<List<ScanModel>> getScanHistoryStream() {
    final uid = currentUserId;
    if (uid == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('scans')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ScanModel.fromJson(doc.data()))
            .toList());
  }
}
