import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sparrow_v1/pages/profile_page.dart';

import '../api/apis.dart';
import '../custom_icon.dart';
import '../helper/dialogs.dart';
import '../main.dart';
import '../models/chat_user.dart';
import 'chat_page.dart';
import 'home_page.dart';

class AboutUser extends StatefulWidget {
  final ChatUser user;
  const AboutUser({super.key, required this.user});

  @override
  State<AboutUser> createState() => _AboutUserState();
}

class _AboutUserState extends State<AboutUser> {
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: AppBar(
            leading: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
                child: const Icon(Icons.arrow_back)
            ),
            iconTheme: const IconThemeData(
              color:
                  Colors.black54, // Change the color of the hamburger icon here
            ),
            flexibleSpace: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: SizedBox(
                  width: 80, // Adjust the width of the logo container as needed
                  height:
                      80, // Adjust the height of the logo container as needed
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
        drawer: Drawer(
            backgroundColor: Colors.white.withOpacity(0.9),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  bottomRight: Radius.circular(40)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      width: mq.height * 0.12,
                      height: mq.height * 0.12,
                      imageUrl: widget.user.image,
                      fit: BoxFit.fill,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    widget.user.name, textAlign: TextAlign.center,
                    //style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView(
                    //padding: const EdgeInsets.symmetric(vertical: 50),
                    children: <Widget>[
                      const Divider(
                        height: 3,
                      ),
                      ListTile(
                        onTap: () {},
                        selectedColor: Theme.of(context).primaryColor,
                        selected: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        leading: const Icon(Icons.person, color: Colors.purple),
                        title: const Text(
                          "Profile",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        selectedColor: Theme.of(context).primaryColor,
                        selected: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        leading: const Icon(Icons.chat, color: Colors.purple),
                        title: const Text(
                          "Chats",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        selectedColor: Theme.of(context).primaryColor,
                        selected: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        leading: const Icon(Icons.accessibility_new_rounded,
                            color: Colors.purple),
                        title: const Text(
                          "Explore",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        selectedColor: Theme.of(context).primaryColor,
                        selected: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        leading: const Icon(Icons.people, color: Colors.purple),
                        title: const Text(
                          "Communities",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        selectedColor: Theme.of(context).primaryColor,
                        selected: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        leading:
                            const Icon(Icons.settings, color: Colors.purple),
                        title: const Text(
                          "Settings",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      ListTile(
                        onTap: () async {
                          showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(32.0))),
                                  contentPadding:
                                      const EdgeInsets.only(top: 10.0),
                                  content: SizedBox(
                                    width: 300.0,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            InkWell(
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0, bottom: 10.0),
                                                decoration: const BoxDecoration(
                                                    //color: Theme.of(context).primaryColor,
                                                    ),
                                                child: const Column(
                                                  children: <Widget>[
                                                    Text(
                                                      "Logout",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        const Divider(
                                          color: Colors.grey,
                                          height: 4.0,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 20.0,
                                              right: 20.0,
                                              top: 30,
                                              bottom: 30),
                                          child: Text(
                                            "Are you sure you want to logout?",
                                            style: TextStyle(
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.w200),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {},
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                top: 10.0, bottom: 10.0),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            child: const Column(
                                              children: <Widget>[
                                                Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                          height: 0,
                                          color: Colors.black45,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                top: 10.0, bottom: 10.0),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(32.0),
                                                      bottomRight:
                                                          Radius.circular(
                                                              32.0)),
                                            ),
                                            child: const Column(
                                              children: <Widget>[
                                                Text(
                                                  "No",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        selectedColor: Theme.of(context).primaryColor,
                        selected: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        leading: const Icon(Icons.logout, color: Colors.purple),
                        title: const Text(
                          "Logout",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                        width: mq.width,
                        height: mq.height *
                            .03), // for adding space from the left and top margin
                    // profile pic of the user
                    Stack(
                      children: [
                        _image != null
                            ?
                            // local image
                            ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(
                                  File(_image!),
                                  width: mq.height * .2,
                                  height: mq.height * .2,
                                  fit: BoxFit.fill,
                                ),
                              )
                            :
                            //image frm the server
                            ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  width: mq.height * .2,
                                  height: mq.height * .2,
                                  imageUrl: widget.user.image,
                                  fit: BoxFit.fill,
                                  //placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                      ],
                    ),

                    SizedBox(width: mq.width, height: mq.height * .03),
                    Text(widget.user.name,
                        style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 17)),
                    SizedBox(width: mq.width, height: mq.height * .05),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.account_balance_outlined,
                                color: Colors.blue,
                              ),
                              SizedBox(width: mq.width * .05),
                              Text(widget.user.about,
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 17)),
                            ],
                          ),
                        ),
                        SizedBox(width: mq.width, height: mq.height * .02),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.alternate_email_outlined,
                                color: Colors.blue,
                              ),
                              SizedBox(width: mq.width * .05),
                              Text(widget.user.email,
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 17)),
                            ],
                          ),
                        ),
                        SizedBox(width: mq.width, height: mq.height * .02),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.access_time_outlined,
                                color: Colors.blue,
                              ),
                              SizedBox(width: mq.width * .05),
                              Text(
                                  APIs.getJoinTime(
                                      context: context,
                                      lastActive: widget.user.createdAt),
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 17)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white70,
          clipBehavior: Clip.antiAlias,
          shape: const CircularNotchedRectangle(),
          notchMargin: 6.0,
          child: Container(
            height: 70.0,
            color: Colors.white70,
            child: Row(
              children: [
                const Spacer(flex: 1),
                IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(user: APIs.me),
                        ),
                      );
                    }),
                const Spacer(flex: 2),
                IconButton(
                    icon: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          8), // Adjust the border radius as needed
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(
                              0.80), // Set the fill color of the square
                          border: Border.all(
                            color: Colors.purple.withOpacity(
                                0.1), // Set the color of the border
                            width: 2, // Set the width of the border
                          ),
                        ),
                        child: const Icon(
                          Icons.chat,
                          //size: 32, // Set the size of the icon
                          color: Colors.white, // Set the color of the icon
                        ),
                      ),
                    ),
                    onPressed: () {}),
                const Spacer(flex: 2),
                IconButton(
                    icon: const Icon(Custom_Icon.globe_americas),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    }),
                const Spacer(flex: 2),
                IconButton(icon: const Icon(Icons.people), onPressed: () {}),
                const Spacer(flex: 2),
                IconButton(
                    icon: const Icon(Icons.settings_sharp), onPressed: () {}),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
