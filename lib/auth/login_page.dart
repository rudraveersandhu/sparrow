import 'dart:io';
import '../api/apis.dart';
import '../helper/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';
import '../pages/chat_page.dart';
import '../pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // handles google login
  _handleGoogleButtonClick(){
    //shows progress indicator till a successful login
    Dialogs.showProgressBar(context);

    _signInWithGoogle().then((user) async {
      // removes progress bar
      Navigator.pop(context);

      if(user != null){
        print('\nUser: ${user.user}');
        print('\nUserAdditionalInfo: ${user.additionalUserInfo}');
        if((await APIs.userExists())){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
        }else{
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomePage()));
          });
        }

      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try{
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    }catch(e){
      print("\n _signInWithGoogle: $e");
      Dialogs.showSnackBar(context, "Something went wrong, check your internet connection",1500);
      return null;
    }
  }



  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black54, // Change the color of the hamburger icon here
          ),
          flexibleSpace: Center(
            child: Padding(
              padding: const EdgeInsets.only(top:30),
              child: SizedBox(
                width: 80, // Adjust the width of the logo container as needed
                height: 80, // Adjust the height of the logo container as needed
                child: Image.asset('assets/logo.png'), // Replace with your logo asset
              ),
            ),
          ),

          elevation: 0,
          centerTitle: true,
          //backgroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
        ),
      ),
      body: Stack(
        children: [
          Positioned(
              top: mq.height * .05,
              width: mq.width * 1,
              left: mq.width * .01,
              child: Image.asset("assets/image6.jpg")
          ),
          Positioned(
            bottom: mq.height * .25,
            width: mq.width * .7,
            left: mq.width * .15,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.lightGreenAccent.shade700, // Set the text color to white
              ),
              onPressed: () {  },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone),
                  SizedBox(width: 10),
                  Text('Sign in with phone'),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: mq.height * .18,
            width: mq.width * .7,
            left: mq.width * .15,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.lightBlueAccent.shade400, // Set the text color to white
              ),
              onPressed: () {
                _handleGoogleButtonClick();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/google_logo.png', // Replace this with the path to your Google logo image
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(width: 10),
                  const Text('Sign in with Google'),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
