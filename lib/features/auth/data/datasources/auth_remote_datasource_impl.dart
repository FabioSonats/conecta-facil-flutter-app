import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserModel?> signIn(String email, String senha) async {
    try {
      final cred =
          await _auth.signInWithEmailAndPassword(email: email, password: senha);
      final userDoc =
          await _firestore.collection('users').doc(cred.user!.uid).get();
      if (userDoc.exists) {
        return UserModel.fromMap(userDoc.data()!);
      }
    } catch (e) {
      print('Erro no signIn: $e');
      rethrow;
    }
    return null;
  }

  @override
  Future<UserModel?> signUp(UserModel user, String senha) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: senha);
      final userWithUid = user.copyWith(uid: cred.user!.uid);
      await _firestore
          .collection('users')
          .doc(cred.user!.uid)
          .set(userWithUid.toMap());
      return userWithUid;
    } catch (e) {
      print('Erro no signUp: $e');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Erro no signOut: $e');
      rethrow;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('Nenhum usuário autenticado');
        return null;
      }

      print('Verificando usuário: ${user.uid}');
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        print('Usuário encontrado no Firestore');
        return UserModel.fromMap(userDoc.data()!);
      } else {
        print('Usuário não encontrado no Firestore');
        return null;
      }
    } catch (e) {
      print('Erro ao buscar usuário atual: $e');
      return null;
    }
  }
}
