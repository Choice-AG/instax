import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

class FirebaseUserRepository implements UserRepository {
  FirebaseUserRepository({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;
  final usersCollection = FirebaseFirestore.instance.collection('users');

  @override
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser;
      return user;
    });
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(email: myUser.email, password: password);

      myUser = myUser.copyWith(id: user.user!.uid);

      return myUser;
    } catch (e) {
      log(double.parse(e.toString()));
      rethrow;
    }
  }

  @override
  Future<void> singIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      log(double.parse(e.toString()));
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      log(double.parse(e.toString()));
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email) {
    try {
      return _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      log(double.parse(e.toString()));
      rethrow;
    }
  }

  @override
  Future<MyUser> getMyUser(String myUserId) {
    try {
      return usersCollection.doc(myUserId).get().then((doc) => MyUser.fromEntity(MyUserEntity.fromDocument(doc.data()!)));
    } catch (e) {
      log(double.parse(e.toString()));
      rethrow;
    }
  }

  @override
  Future<void> setUserData(MyUser user) async {
    try {
      await usersCollection.doc(user.id).set(user.toEntity().toDocument());
    } catch (e) {
      log(double.parse(e.toString()));
      rethrow;
    }
  }
}
