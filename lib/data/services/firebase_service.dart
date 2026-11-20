import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../core/constants/app_constants.dart';
import '../models/sensor_data.dart';

class AppFirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // ---------------- AUTHENTICATION ---------------- //

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    if (credential.user != null) {
      await credential.user!.updateDisplayName(name);
    }
    return credential;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ---------------- REALTIME DATABASE ---------------- //

  /// Stream of real-time monitoring snapshot (FR-03)
  Stream<SensorData?> getMonitoringStream() {
    final ref = _database.ref(AppConstants.monitoringPath);
    return ref.onValue.map((event) {
      final value = event.snapshot.value;
      if (value == null || value is! Map) {
        return null;
      }
      return SensorData.fromMap(value);
    });
  }

  /// Fetch latest monitoring snapshot directly via get()
  Future<SensorData?> getLatestMonitoringData() async {
    try {
      final ref = _database.ref(AppConstants.monitoringPath);
      final snapshot = await ref.get();
      if (snapshot.exists && snapshot.value is Map) {
        return SensorData.fromMap(snapshot.value as Map);
      }
    } catch (_) {}

    // Fallback: get the most recent history record
    try {
      final history = await fetchHistory(limit: 1);
      if (history.isNotEmpty) {
        return history.first;
      }
    } catch (_) {}

    return null;
  }

  /// Fetch history records (FR-05, ordered by timestamp descending)
  Future<List<SensorData>> fetchHistory({int limit = 50}) async {
    final ref = _database.ref(AppConstants.historyPath);
    final snapshot = await ref.limitToLast(limit).get();

    if (!snapshot.exists || snapshot.value == null) {
      return [];
    }

    final List<SensorData> items = [];
    final dataMap = snapshot.value as Map<dynamic, dynamic>;

    dataMap.forEach((key, val) {
      if (val is Map) {
        items.add(SensorData.fromMap(val, key.toString()));
      }
    });

    // Sort descending by timestamp / pushId
    items.sort((a, b) => (b.waktu).compareTo(a.waktu));
    return items;
  }
}
