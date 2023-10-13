import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sparrow_v1/pages/chat_page.dart';
import 'package:sparrow_v1/pages/community_chat_page.dart';
import 'package:sparrow_v1/pages/profile_page.dart';
import 'package:sparrow_v1/widgets/community_card.dart';

import '../api/apis.dart';
import '../auth/login_page.dart';
import '../custom_icon.dart';
import '../helper/dialogs.dart';
import '../main.dart';
import '../models/chat_user.dart';
import '../models/community.dart';
import '../widgets/user_card.dart';
import 'home_page.dart';

class CommunitiesPage extends StatefulWidget {
  const CommunitiesPage({super.key});

  @override
  State<CommunitiesPage> createState() => _CommunitiesPageState();
}

class _CommunitiesPageState extends State<CommunitiesPage> {
  bool hasUserSearched = false;
  bool isLoading = false;
  QuerySnapshot? comSnapshot;
  QuerySnapshot? mySnapshot;
  List res = [];
  List sug = [];
  List<Map<String, dynamic>>? dataList = [];
  String searchString = "";
  TextEditingController searchController = TextEditingController();
  String communityName = "";
  bool track = false;
  final List<String> imageUrls = [
    'assets/us.png',
    'assets/sw.png',
    'assets/ge.png', // Add more profile picture URLs here
    'assets/fr.png',
    'assets/ar.png',
    'assets/ch.png'];

  @override
  initState() {
    super.initState();
    getCommunityList();

  }

  search(String ser) {

    res.clear();
    log(ser);
    if (ser.isEmpty) {
    } else {
      for (int i = 0; i < sug.length; i++) {
        for (int j = 0; j < ser.length; j++) {
          if(j <= sug[i].length){
            if (sug[i][j] == ser[j]) {
              track = true;
            } else {
              track = false;
              break;
            }
          }
        }
        if (track == true) {
          res.add(sug[i]);
          track = false;
        }
      }
    }
    print(res);
  }
  getCommunityList() async {
    // fetches the list of current available communities for user to search from
    await FirebaseFirestore.instance.collection("communities").get().then((snapshot) {
      setState(() {
        comSnapshot = snapshot;
        final allData = snapshot.docs.map((doc) => doc).toList();  // converts all communities into a list
        sug.clear();

        for (int i = 0; i < allData.length; i++) {
          sug.add(allData[i]['communityName'].toLowerCase());
        }
      });
    });
  }
  getCommunitySnapshot() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      await FirebaseFirestore.instance.collection("communities").get().then((snapshot) {
        setState(() {
          mySnapshot = snapshot; // this snapshot has all the communities with their respected details
          isLoading = false;
        });
      });
    }
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
                                controller: searchController,
                                onTap: () {
                                },
                                onChanged: (value) {
                                  searchString = value;
                                  hasUserSearched = true;
                                  search(searchString.toLowerCase());
                                  setState(() {
                                    if (res.contains(searchString)) {
                                      getCommunitySnapshot();
                                    } else if(searchString == "") {
                                      hasUserSearched = false;
                                    }
                                  });
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
                                  hintText: 'Search for communities...',
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
                      SizedBox(
                        height: 90, // Adjust the height as needed
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: imageUrls.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(7.0), // Add some spacing between the images
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
                                        decoration: const BoxDecoration(
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
                        padding: const EdgeInsets.only(right:210,top:20,bottom: 10,left: 5),
                        child: Text("Communities",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.63),
                            fontWeight: FontWeight.bold,
                            fontSize: 27,
                          ),
                        ),
                      ),
                      const Divider(height: 2),
                      //isLoading ? CircularProgressIndicator(color: Theme.of(context).primaryColor) : Center(child: communityList()),
                      hasUserSearched ? communityRes() : communityList()

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
                        Icons.people,
                        //size: 32, // Set the size of the icon
                        color: Colors.white, // Set the color of the icon
                      ),
                    ),
                  ), onPressed: () {
                    popUpDialog(context);
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

  Widget communityRes() {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('communities').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
              return const Text('No communities available.');
            }

            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {

                  var communityData = snapshot.data!.docs[index].data() as Map<
                      String,
                      dynamic>;
                  var communityName = communityData['communityName'] ??
                      'Unnamed Community';
                  var communityID = communityData['communityID'] ??
                      'Unnamed Community';
                  var admin = communityData['admin'] ??
                      'Unnamed admin';

                  if (!res.contains(communityName.toLowerCase())) {
                    return Container(); // Empty container if item is not present
                  }

                  //isUserJoined(communityName, communityID);

                  return Card(
                    color: Colors.grey.shade200, // Set the desired background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Set the desired corner radius
                    ),
                    child: ListTile(
                      onTap: (){
                        //nextScreenReplace(context, CommunityChatPage(communityId: communityID, communityName: communityName, userName: userName));
                      },
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: communityData['image'],
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                      /*CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(communityName.substring(0,1).toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500
                          ),),
                      ),*/
                      title: Text(communityName),
                      subtitle: const Text("username"),

                    ),
                  );
                }
            );
          },
        ),
      ),
    );
  }

  communityList(){
    return StreamBuilder(
        stream: APIs.getAllCommunities(),
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
              dataList = snapshot.data?.docs.map((doc) => doc.data()).toList();
          }

          if(dataList!.isNotEmpty){
            return Expanded(
              child: ListView.builder(
                  itemCount: dataList?.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index){

                    var datas = dataList?[index];
                    //log(datas?['communityName']);
                    return CommunityCard(community: datas); }
              ),
            );
          }else{
            return Center(
              child: Column(
                children: [
                  Text('No users added yet'),
                  ElevatedButton(onPressed: (){
                    popUpDialog(context);
                  }, child: Icon(Icons.people_outline))

                ],
              ),
            );
          }
        }
    );

  }

  // dialog that enables user to create a community
  popUpDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              contentPadding: const EdgeInsets.only(top: 10.0),
              content: SizedBox(
                width: 300.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Create a community.",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w200),
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
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextField(
                        onChanged: (val) {
                          setState(() {
                            communityName = val;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Community name",
                          hintStyle: TextStyle(
                              fontSize: 15.0, color: Colors.grey.shade400),
                          border: InputBorder.none,
                          prefixIcon: Icon(Custom_Icon.globe_americas, color: Theme
                              .of(context)
                              .primaryColor,),
                        ),
                        maxLines: 1,
                      ),
                    ),

                    InkWell(
                      onTap: () async {
                        APIs.createCommunity(APIs.me.name, APIs.user.uid, communityName, "https://firebasestorage.googleapis.com/v0/b/sparrow-v1.appspot.com/o/kurzgesagt-2f303lr3fj5hab7x.jpg?alt=media&token=25e0f5f3-1fc3-438b-b65f-45db2269eadf");
                        Navigator.of(context).pop();
                        Dialogs.showSnackBar(
                            context, "Community created successfully!", 1000);
                        },
                      child: Container(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .primaryColor,
                        ),
                        child: const Text(
                          "Create now!",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Divider(height: .5, color: Colors.black,),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .primaryColor,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(32.0),
                              bottomRight: Radius.circular(32.0)),
                        ),
                        child: const Text(
                          "Not now",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }));
        });
  }
}
