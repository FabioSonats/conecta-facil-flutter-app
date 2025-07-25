import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserModel?> signIn(String email, String senha) async {
    final cred =
        await _auth.signInWithEmailAndPassword(email: email, password: senha);
    final userDoc =
        await _firestore.collection('users').doc(cred.user!.uid).get();
    if (userDoc.exists) {
      return UserModel.fromMap(userDoc.data()!);
    }
    return null;
  }

  @override
  Future<UserModel?> signUp(UserModel user, String senha) async {
    final cred = await _auth.createUserWithEmailAndPassword(
        email: user.email, password: senha);
    final userWithUid = user.copyWith(uid: cred.user!.uid);
    await _firestore
        .collection('users')
        .doc(cred.user!.uid)
        .set(userWithUid.toMap());
    return userWithUid;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    // Aguarda o carregamento do usuário atual
    await _auth.authStateChanges().first;
    final user = _auth.currentUser;
    if (user == null) return null;
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (userDoc.exists) {
      return UserModel.fromMap(userDoc.data()!);
    }
    return null;
  }
}
