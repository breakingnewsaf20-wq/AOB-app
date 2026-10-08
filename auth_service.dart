import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<void> register({required String email, required String password, required String name, required String role}) async {
    if (name.trim().isEmpty) throw FirebaseAuthException(code: 'invalid-name', message: 'نوم باید ولیکل شي.');
    final cred = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
    await _db.collection('users').doc(cred.user!.uid).set({'name': name.trim(), 'email': email.trim(), 'role': role, 'createdAt': FieldValue.serverTimestamp()});
  }

  Future<void> login({required String email, required String password}) => _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
  Future<void> logout() => _auth.signOut();
  Future<void> resetPassword(String email) => _auth.sendPasswordResetEmail(email: email.trim());

  Future<String> getRole() async {
    final uid = currentUser?.uid;
    if (uid == null) return 'customer';
    final doc = await _db.collection('users').doc(uid).get();
    return (doc.data()?['role'] as String?) ?? 'customer';
  }
}
