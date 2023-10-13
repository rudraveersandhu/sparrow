import 'package:flutter/material.dart';
import 'package:sparrow_v1/pages/chat_page.dart';

class Dialogs{
  static void showSnackBar(BuildContext context, String msg, int duration){
    ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(content: Text(msg),
          backgroundColor: Colors.blue.shade300,
        behavior: SnackBarBehavior.floating,
          duration: Duration(milliseconds: duration),
        ));
  }

  static void showProgressBar(BuildContext context){
    showDialog(context: context, builder: (_) => Center(child: CircularProgressIndicator()));
  }
}

//await FirebaseAuth.instance.signOut();
//await GoogleSignIn().signOut();