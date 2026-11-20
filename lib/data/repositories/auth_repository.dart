import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';

abstract class AuthRepository {
  Stream<User?> get authState;
  User? get currentUser;
  Future<void> login(String email, String password);
  Future<void> register(String name, String email, String password);
  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final AppFirebaseService _firebaseService;

  AuthRepositoryImpl(this._firebaseService);

  @override
  Stream<User?> get authState => _firebaseService.authStateChanges;

  @override
  User? get currentUser => _firebaseService.currentUser;

  @override
  Future<void> login(String email, String password) {
    return _firebaseService.signIn(email: email, password: password);
  }

  @override
  Future<void> register(String name, String email, String password) {
    return _firebaseService.signUp(name: name, email: email, password: password);
  }

  @override
  Future<void> logout() {
    return _firebaseService.signOut();
  }
}
