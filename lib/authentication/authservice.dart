
import 'package:firebase_auth/firebase_auth.dart';

class authservice {

final FirebaseAuth fireauth=FirebaseAuth.instance;

User? get currentuserstate{
  return fireauth.currentUser;
}

Stream<User?> get notifycurrentuserstatechange{
  return fireauth.authStateChanges();
}

Future<void> createuser({required String email,required String password}) async{
  await fireauth.createUserWithEmailAndPassword(
    email: email, 
    password: password);
}

Future<void> signinuser({required String email,required String password}) async{
  await fireauth.signInWithEmailAndPassword(
    email: email, 
    password: password);
}

Future<void> signout()async{
  await fireauth.signOut();
}
}