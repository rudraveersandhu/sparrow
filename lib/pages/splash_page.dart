import 'package:flutter/material.dart';

import 'package:sparrow_v1/auth/login_page.dart';
import '../api/apis.dart';
import '../main.dart';
import 'chat_page.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState(){
    super.initState();
    APIs.getSelfInfo();
    Future.delayed(const Duration(seconds: 2), (){
      if(APIs.auth.currentUser != null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
      }

    });
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
            child: const Align(
                alignment: Alignment.center,
                child: Text("Made in Bharat"))
          ),


        ],
      ),
    );
  }
}
