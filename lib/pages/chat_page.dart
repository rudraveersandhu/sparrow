import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sparrow_v1/auth/login_page.dart';
import 'package:sparrow_v1/pages/communities_page.dart';
import 'package:sparrow_v1/pages/home_page.dart';
import 'package:sparrow_v1/pages/profile_page.dart';
import 'package:sparrow_v1/widgets/user_card.dart';
import 'package:sparrow_v1/custom_icon.dart';
import '../api/apis.dart';
import '../main.dart';
import '../models/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatPage extends StatefulWidget {

  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatUser> list  = [];

  final List<String> imageUrls = [
    'assets/1.png',
    'assets/1.png',
    'assets/1.png', // Add more profile picture URLs here
    'assets/1.png',
    'assets/1.png',
    'assets/1.png',
  ];

  @override
  initState() {
    super.initState();
    APIs.getSelfInfo();


    SystemChannels.lifecycle.setMessageHandler((message) {
      if(APIs.auth.currentUser != null){
        if(message.toString().contains("resume")) APIs.updateActiveStatus(true);
        if(message.toString().contains("pause")) APIs.updateActiveStatus(false);
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: (){
          return Future.value(false);
        },
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
                        imageUrl: APIs.me.image,
                        fit: BoxFit.fill,
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:5),
                    child: Text(APIs.me.name, textAlign: TextAlign.center,
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
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                child: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 27,right: 27,top: 4,bottom: 4),
                          child: Stack(
                            children: [
                              TextField(
                                onTap: () {
                                },
                                onChanged: (value) {
                                },
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(0),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  //borderRadius: BorderRadius.circular(20),
                                  //color: Colors.grey.shade300,
                                  hintText: 'Search for people...',
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.only(left: 15, top: 0),
                                    child: Icon(Icons.search),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 4, // Adjust the height of the shadow
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.9), // Set the shadow color
                                        blurRadius: 9, // Set the blur radius
                                        offset: const Offset(0, 8), // Set the shadow offset
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //const SizedBox(height: 6.0),
                      const Divider(height: 5,),
                      Container(
                        height: 90, // Adjust the height as needed
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: imageUrls.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.all(8.0), // Add some spacing between the images
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      imageUrls[index],
                                      width: 75, // Adjust the width and height to your preference
                                      height: 75,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      bottom: -5,
                                      right:0,
                                      left: 0,
                                      child: Container(
                                        width: 12, // Adjust the size of the green dot
                                        height: 15,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: -3,
                                      right:0,
                                      left: 0,
                                      child: Container(
                                        width: 10, // Adjust the size of the green dot
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: Colors.lightGreenAccent.shade700,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      ),

                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right:290,top:20,bottom: 10),
                        child: Text("Chats",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.63),
                            fontWeight: FontWeight.bold,
                            fontSize: 27,
                          ),),
                      ),
                      Divider(height: 2,),
                      //isLoading ? CircularProgressIndicator(color: Theme.of(context).primaryColor) : Center(child: communityList()),
                      StreamBuilder(
                          stream: APIs.getAllUsers(),
                          builder: (context,snapshot){


                            switch(snapshot.connectionState){
                              // if data is leading
                              case ConnectionState.waiting:
                                return const Center(child: CircularProgressIndicator());
                              case ConnectionState.none:
                                return const Center(child: CircularProgressIndicator(),);
                              //if some or all data is loaded
                              case ConnectionState.active:
                              case ConnectionState.done:
                                final data = snapshot.data?.docs;
                                list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
                            }

                            if(list.isNotEmpty){
                              return Expanded(
                                child: ListView.builder(
                                    itemCount: list.length,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index){
                                      return UserCard(user: list[index]); }
                                ),
                              );
                            }else{
                              return Center(
                                child: Column(
                                  children: [
                                    Text('No users added yet'),
                                    ElevatedButton(onPressed: () async {
                                      await APIs.auth.signOut();
                                      await GoogleSignIn().signOut();
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));

                                    }, child: Text("logout"),),

                                  ],
                                ),
                              );
                            }
                          }
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
                  IconButton(icon: const Icon(Icons.person), onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(user: APIs.me),
                      ),
                    );
                  }),

                  const Spacer(flex: 2),

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
                        Icons.chat,
                        //size: 32, // Set the size of the icon
                        color: Colors.white, // Set the color of the icon
                      ),
                    ),
                  ), onPressed: () {

                  }),
                  const Spacer(flex: 2),

                  IconButton(
                      icon: const Icon(Custom_Icon.globe_americas), onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  }),
                  const Spacer(flex: 2),

                  IconButton(icon: const Icon(Icons.people), onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunitiesPage(),
                      ),
                    );
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
      ),
    );
  }
  Widget _buildProfileAvatar(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10), // Circular radius
      child: Image.asset(
        imageUrl,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      ),
    );
  }
}

