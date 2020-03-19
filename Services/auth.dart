import 'dart:async';
import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth{
  Future<String> signIn(String email, String password);
  Future <String> signinwithgoogle();
  Future<void> logout();
  Future<bool> isEmailVerified();
  Future<FirebaseUser> getCurrentUser();

}

class Auth implements BaseAuth{
  FirebaseAuth mAuth = FirebaseAuth.instance;
  @override
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await mAuth.currentUser();
    return user;

  }

  @override
  Future<bool> isEmailVerified() async {
    FirebaseUser user = await mAuth.currentUser();
    return user.isEmailVerified;


  }

  @override
  Future<void> logout() async {
    final GoogleSignIn _gSignIn = new GoogleSignIn();
    if( await _gSignIn.isSignedIn() ){
    await  _gSignIn.signOut();
     return _gSignIn.disconnect();
    }else {
      return mAuth.signOut();
    }
  }

  @override
  Future<String> signIn(String email, String password)  async{
AuthResult result = await mAuth.signInWithEmailAndPassword(email: email, password: password) ;
FirebaseUser user = result.user;
return user.uid;
  }

  @override
  Future<String> signinwithgoogle() async {
    final GoogleSignIn _gSignIn = new GoogleSignIn();
    GoogleSignInAccount googleSignInAccount =await  _gSignIn.signIn();
    GoogleSignInAuthentication authentication =
    await googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(idToken: authentication.idToken, accessToken: authentication.accessToken);
   AuthResult result = await mAuth.signInWithCredential(credential);
   return result.user.uid;

  }

}