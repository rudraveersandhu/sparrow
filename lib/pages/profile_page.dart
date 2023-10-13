import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sparrow_v1/custom_icon.dart';
import 'package:sparrow_v1/pages/chat_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../api/apis.dart';
import '../auth/login_page.dart';
import '../helper/dialogs.dart';
import '../main.dart';
import '../models/chat_user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import 'home_page.dart';

class ProfilePage extends StatefulWidget {
  final ChatUser user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? _image;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                  child:
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      width: mq.height * 0.12,
                      height: mq.height * 0.12,
                      imageUrl: widget.user.image,
                      fit: BoxFit.fill,
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:5),
                  child: Text(widget.user.name, textAlign: TextAlign.center,
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
                        onTap: () {

                        },
                        selectedColor: Theme
                            .of(context)
                            .primaryColor,
                        selected: true,
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        leading: const Icon(Icons.person,color: Colors.purple),
                        title: const Text(
                          "Profile",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      ListTile(
                        onTap: () {

                        },
                        selectedColor: Theme
                            .of(context)
                            .primaryColor,
                        selected: true,
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        leading: const Icon(Icons.chat,color: Colors.purple),
                        title: const Text(
                          "Chats",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      ListTile(
                        onTap: () {

                        },
                        selectedColor: Theme
                            .of(context)
                            .primaryColor,
                        selected: true,
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        leading: const Icon(Icons.accessibility_new_rounded,color: Colors.purple),
                        title: const Text(
                          "Explore",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      ListTile(
                        onTap: () {

                        },
                        selectedColor: Theme
                            .of(context)
                            .primaryColor,
                        selected: true,
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        leading: const Icon(Icons.people,color: Colors.purple),
                        title: const Text(
                          "Communities",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      ListTile(
                        onTap: () {

                        },
                        selectedColor: Theme
                            .of(context)
                            .primaryColor,
                        selected: true,
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        leading: const Icon(Icons.settings,color: Colors.purple),
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
                                      borderRadius: BorderRadius.all(Radius.circular(
                                          32.0))),
                                  contentPadding: const EdgeInsets.only(top: 10.0),
                                  content: SizedBox(
                                    width: 300.0,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceEvenly,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[

                                            InkWell(
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0, bottom: 10.0),
                                                decoration: const BoxDecoration(
                                                  //color: Theme.of(context).primaryColor,
                                                ),
                                                child: const Column(children: <Widget>[
                                                  Text(
                                                    "Logout",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                    textAlign: TextAlign.center,
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
                                          padding: EdgeInsets.only(left: 20.0,
                                              right: 20.0,
                                              top: 30,
                                              bottom: 30),
                                          child: Text(
                                            "Are you sure you want to logout?",
                                            style: TextStyle(fontSize: 17.0,
                                                fontWeight: FontWeight.w200),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {

                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                top: 10.0, bottom: 10.0),
                                            decoration: BoxDecoration(
                                              color: Theme
                                                  .of(context)
                                                  .primaryColor,
                                            ),
                                            child: const Column(children: <Widget>[
                                              Text(
                                                "Yes",
                                                style: TextStyle(color: Colors.white),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                          height: 0, color: Colors.black45,),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                top: 10.0, bottom: 10.0),
                                            decoration: BoxDecoration(
                                              color: Theme
                                                  .of(context)
                                                  .primaryColor,
                                              borderRadius: const BorderRadius.only(
                                                  bottomLeft: Radius.circular(32.0),
                                                  bottomRight: Radius.circular(32.0)),
                                            ),
                                            child: const Column(children: <Widget>[
                                              Text(
                                                "No",
                                                style: TextStyle(color: Colors.white),
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
                        selectedColor: Theme
                            .of(context)
                            .primaryColor,
                        selected: true,
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        leading: const Icon(Icons.logout,color: Colors.purple),
                        title: const Text(
                          "Logout",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(children: [

                SizedBox(width: mq.width,height: mq.height *.03), // for adding space from the left and top margin

                // profile pic of the user
                Stack(
                  children: [

                    _image != null ?
                    // local image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(
                        File(_image!),
                        width: mq.height * .2,
                        height: mq.height * .2,
                        fit: BoxFit.fill,
                          ),
                      ) :
                        //image frm the server
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        width: mq.height * .2,
                        height: mq.height * .2,
                        imageUrl: widget.user.image,
                        fit: BoxFit.fill,
                        //placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),

                    Positioned(
                      bottom: -15,
                      right:-30,
                      child: MaterialButton(onPressed: (){
                        uploadPic();
                      },

                        color: Colors.white,
                        shape: const CircleBorder(),
                        child: const Icon(Icons.add_circle, color: Colors.blue,),
                      ),
                    )
                  ],
                ),
                SizedBox(width: mq.width,height: mq.height *.03),
                Text(widget.user.email,
                  style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 17)),
                SizedBox(width: mq.width,height: mq.height *.05),
                TextFormField(
                  onSaved: (val) => APIs.me.name = val ?? '',
                  validator: (val) => val != null && val.isNotEmpty ? null : "Name cant be empty",
                  initialValue: widget.user.name,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person, color: Colors.blue,),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    hintText: "eg Abhishek Singh",
                  label: const Text("Name")),
                ),
                SizedBox(width: mq.width,height: mq.height *.02),
                TextFormField(
                  onSaved: (val) => APIs.me.about = val ?? '',
                  validator: (val) => val != null && val.isNotEmpty ? null : "About cant be empty",
                  initialValue: widget.user.about,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.info_outlined, color: Colors.blue,),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      hintText: "eg Exploring world via Sparrow!",
                      label: const Text("About")),
                ),
                SizedBox(width: mq.width,height: mq.height *.04),
                ElevatedButton.icon(onPressed: (){
                  if(_formKey.currentState!.validate()){
                    _formKey.currentState!.save();
                    APIs.updateUserInfo().then((value) {
                      Dialogs.showSnackBar(context, 'Name updated successfully!', 500);
                    });
                  }
                },
                  icon: const Icon(Icons.edit, size: 28,),
                  label: const Text("Update!"),
                  style: ElevatedButton.styleFrom(shape: const StadiumBorder(),minimumSize: Size(mq.width * .5, mq.height* .06)),
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(shape: const StadiumBorder(),minimumSize: Size(mq.width * .3, mq.height* .04)),
                  onPressed: () async {

                  APIs.updateActiveStatus(false);

                  await APIs.auth.signOut();
                  await GoogleSignIn().signOut().then((value) {
                    //Navigator.pop(context);
                    Navigator.pop(context);

                    APIs.auth = FirebaseAuth.instance;

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                  });
                }, child: const Text("logout"),),
                ],
              ),
            ),
          ),
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

                IconButton(icon: ClipRRect(
                  borderRadius: BorderRadius.circular(8), // Adjust the border radius as needed
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.80), // Set the fill color of the square
                      border: Border.all(
                        color: Colors.purple.withOpacity(0.1), // Set the color of the border
                        width: 2, // Set the width of the border
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      //size: 32, // Set the size of the icon
                      color: Colors.white, // Set the color of the icon
                    ),
                  ),
                ), onPressed: () {
                }),
                const Spacer(flex: 2),

                IconButton(icon: const Icon(Icons.chat), onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatPage(),
                    ),
                  );

                }),
                const Spacer(flex: 2),

                IconButton(
                    icon: const Icon(Custom_Icon.globe_americas), onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                }),
                const Spacer(flex: 2),

                IconButton(icon: const Icon(Icons.people), onPressed: () {

                }),
                const Spacer(flex: 2),

                IconButton(icon: const Icon(Icons.settings_sharp), onPressed: () {

                }),
                const Spacer(flex: 1),



              ],
            ),
          ),
        ),
      ),
    );
  }

  uploadPic(){
        showDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(
                        32.0))),
                contentPadding: const EdgeInsets.only(top: 10.0),
                content: SizedBox(
                  width: 300.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[

                          InkWell(
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 5.0, bottom: 5.0),
                              decoration: const BoxDecoration(
                                //color: Theme.of(context).primaryColor,
                              ),
                              child: const Column(children: <Widget>[
                                Text(
                                  "Update profile picture",
                                  style: TextStyle(
                                      color: Colors.black),
                                  textAlign: TextAlign.center,
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
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0,
                            right: 20.0,
                            top: 30,
                            bottom: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
// Pick an image.
                                final XFile? image = await picker.pickImage(source: ImageSource.camera,imageQuality: 80);
                                if(image != null){
                                    setState(() {
                                      _image = image.path;
                                    });
                                    APIs.updateProfilePicture(File(_image!));
                                    Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: const CircleBorder(),
                                elevation: 0
                              ),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                size: 60.0,
                                color: Colors.black38,
                              ),
                            ),
                            //SizedBox(width: 36.0), // Add some spacing between the icons
                            ElevatedButton(
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
                                  // Pick an image.
                                final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                                if(image != null){
                                  setState(() {
                                    _image = image.path;
                                  });
                                  APIs.updateProfilePicture(File(_image!));
                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: const CircleBorder(),
                                  elevation: 0
                              ),
                              child: const Icon(
                                Icons.file_upload_rounded,
                                size: 60.0,
                                color: Colors.black38,
                              ),
                            ),
                          ],
                        )
                      ),

                      const Divider(
                        height: 0, color: Colors.black45,),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade200,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(32.0),
                                bottomRight: Radius.circular(32.0)),
                          ),
                          child: const Column(children: <Widget>[
                            Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
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

          },
        );
  }

}
