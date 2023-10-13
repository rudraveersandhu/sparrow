import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sparrow_v1/models/chat_user.dart';
import 'package:sparrow_v1/models/community.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sparrow_v1/models/message.dart';
import 'package:http/http.dart';



class APIs {
  static final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //firebase messaging for push notifications
  static FirebaseMessaging fmessaging = FirebaseMessaging.instance;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing cloud firestore storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  // for storing self information.
  static late ChatUser me;

  // for returning current user
  static User get user => auth.currentUser!;

  // for checking if user exist or not
  static Future<bool> userExists() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  static Future<void> getFirebaseMessagingToken() async {
    await fmessaging.requestPermission();
    await fmessaging.getToken().then((t) {
      if(t!=null){
        me.pushToken = t;
      }
    });
  }

  static Future getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        await getFirebaseMessagingToken();
        updateActiveStatus(true);
      } else {
        createUser().then((value) => getSelfInfo());
      }
    });
  }

  // to create a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
        image: user.photoURL.toString(),
        about: "Exploring world via Sparrow!",
        name: user.displayName.toString(),
        createdAt: time,
        isOnline: false,
        id: user.uid.toString(),
        lastActive: time,
        email: user.email.toString(),
        pushToken: '');
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  // for getting all users from the firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    //return firestore.collection('users').snapshots(); // without any filter

    //with filter
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getCommunityMembers(List ids) {
    //return firestore.collection('users').snapshots(); // without any filter
    //with filter
    return firestore
        .collection('users')
        .where('id', whereIn: ids).snapshots();

  }


  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCommunities() {
    //return firestore.collection('users').snapshots(); // without any filter
    //with filter
    return firestore
        .collection('communities')
        .snapshots();
  }

  static Future<void> updateUserInfo() async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'name': me.name, 'about': me.about});
  }

  //update profile picture of a user
  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split(".").last;
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print("Data transfered: ${p0.bytesTransferred / 1000} kb");
    });
    me.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(user.uid).update({
      'image': me.image,
    });
  }

  ///************************************** Chat Screen APIS *************************************

  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
    .orderBy("sent",descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCommunityMessages(
      Map<String,dynamic>? community) {
    return firestore
        .collection('communities/${community?['communityID']}/messages/')
        .orderBy("sent",descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(ChatUser chatUser, String message, Type type ) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Message msg = Message(
        receiverID: chatUser.id,
        message:    message,
        read:       "",
        type:       type,
        senderID:   user.uid,
        sent:       time,
        senderName: '');

    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    ref.doc(time).set(msg.toJson()).then((value) => sendPushNotification(chatUser,type == Type.text ? message : 'image'));
  }

  static Future<void> sendCommunityMessage(Map<String,dynamic>? community, String message, Type type ) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    String name = await getSenderName(user.uid);
    final Message msg = Message(
        receiverID: community?['communityID'],
        message: message,
        read: "",
        type: type,
        senderID: user.uid,
        sent: time,
        senderName: name
    );

    final ref = firestore
        .collection('communities/${community?['communityID']}/messages/');
    ref.doc(time).set(msg.toJson()).then((value) => sendCommunityPushNotification(community,type == Type.text ? message : 'image'));
  }

  static getSenderName(String senderID) async {
    try {
      // Reference to the Firestore collection
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

      // Query to fetch the sender with the provided senderID
      QuerySnapshot snapshot = await usersCollection.where('id', isEqualTo: senderID).get();

      // Check if there's a matching document
      if (snapshot.docs.isNotEmpty) {
        // Get the first document and extract the name field
        String name = await snapshot.docs.first['name'];
        log(name);
        return name;
      } else {
        return null; // No matching sender found
      }
    } catch (e) {
      print("Error fetching sender name: $e");
      return null;
    }

  }

  // updating read status of message
  static Future<void> updateMessageReadStatus(Message message) async {
    final timex = DateTime.now().millisecondsSinceEpoch.toString();
    firestore
        .collection('chats/${getConversationID(message.senderID)}/messages/')
        .doc(message.sent)
        .update({'read': timex});
  }

  static Stream<QuerySnapshot> getLastMessage(ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }
  static Stream<QuerySnapshot> getComLastMessage(Map<String,dynamic> community) {
    return firestore
        .collection('chats/${getConversationID(community['communityID'])}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static String getLastMessageTime(
      {required BuildContext context, required String time}) {
    var milliseconds = int.parse(time);
    var dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    var ftime = DateFormat('h:mm a').format(dateTime);
    var date = DateFormat('d').format(dateTime);
    var fdate = DateFormat('d MMMM').format(dateTime);
    var month = DateFormat('M ').format(dateTime);
    //var fmonth = DateFormat('MMMM ').format(dateTime);
    var year =  DateFormat('y').format(dateTime);
    final DateTime now = DateTime.now();

    //if same date same month
    if(now.day == num.parse(date) && now.month == num.parse(month) && now.year == num.parse(year) ){
      return ftime;

      // if 1 day old date and same month and same year
    }else if(now.day == 1 + num.parse(date) && now.month == num.parse(month) && now.year == num.parse(year) ){
      return "yesterday";

      // if different month
    }else if(now.month > num.parse(month) && now.year == num.parse(year) ){
      return fdate;

      // if different month
    }else if( now.year > num.parse(year) ){
      return year;
    }
    else {
      return fdate;
    }
  //String _getMonth(DateTime date) {}
  }

  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    final ext = file.path.split(".").last;
    final ref = storage.ref().child('images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print("Data transfered: ${p0.bytesTransferred / 1000} kb");
    });
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);

  }

  static Future<void> sendCommunityChatImage(Map<String,dynamic>? community, File file) async {
    final ext = file.path.split(".").last;
    final ref = storage.ref().child('community_images/${community?['communityID']}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print("Data transfered: ${p0.bytesTransferred / 1000} kb");
    });
    final imageUrl = await ref.getDownloadURL();
    await sendCommunityMessage(community, imageUrl, Type.image);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(ChatUser chatUser)  {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getCommunityInfo(Map<String,dynamic>? community)  {
    return firestore
        .collection('communities')
        .where('communityID', isEqualTo: community?['communityID'])
        .snapshots();
  }

  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore
        .collection('users')
        .doc(user.uid).update({
      'is_online' : isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
        });
  }

  static String getLastActiveTime({required BuildContext context, required String lastActive}){
    final int i = int.tryParse(lastActive) ?? -1;

    if(i== -1) return "Last seen not available";

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if(time.day == now.day &&
    time.month == now.month &&
    time.year == time.year){
      return 'last seen today at $formattedTime';
    }

    if((now.difference(time).inHours / 24).round() == 1){
      return 'last seen yesterday at $formattedTime';
    }

    String month = _getMonth(time);
    return 'last seen on ${time.day} $month on $formattedTime';
  }

  static String getJoinTime({required BuildContext context, required String lastActive}){
    final int i = int.tryParse(lastActive) ?? -1;

    if(i== -1) return "Not available";

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if(time.day == now.day &&
        time.month == now.month &&
        time.year == time.year){
      return 'Joined on $formattedTime';
    }

    if((now.difference(time).inHours / 24).round() == 1){
      return 'last seen yesterday at $formattedTime';
    }

    String month = _getMonth(time);
    return 'Joined on ${time.day} $month on $formattedTime';
  }

  static String _getMonth(DateTime date){
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return'NA';
  }

  static Future<void> sendPushNotification(ChatUser chatUser, String message) async {
    try{
      final body = {
        "to":chatUser.pushToken,
        "notification": {
          "title": chatUser.name,
          "body": message,
        }
      };
      var response = await post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: {
            HttpHeaders.contentTypeHeader : 'application/json',
            HttpHeaders.authorizationHeader : 'key=AAAAQRfuZbk:APA91bEII-26Nt81Pp_b8VlG0PpKeyEy1VSAKL_9D1LBwdfXx0sIWRUUA0Zf3xkgmECaHv876hXzOPS12wrk3ce6WwWhO0nr4oyPrtTue0P9puCh4J4fcJtqWK5-4kHkJLORjzhLGL9-'
          },
          body: jsonEncode(body));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      print(await read(Uri.https('example.com', 'foobar.txt')));
    }
    catch(e){
      print(e);
    }
  }

  static Future<void> sendCommunityPushNotification(Map<String,dynamic>? community, String message) async {
    try{
      final body = {
        "to":community?['pushToken'],
        "notification": {
          "title": community?['name'],
          "body": message,
        }
      };
      var response = await post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: {
            HttpHeaders.contentTypeHeader : 'application/json',
            HttpHeaders.authorizationHeader : 'key=AAAAQRfuZbk:APA91bEII-26Nt81Pp_b8VlG0PpKeyEy1VSAKL_9D1LBwdfXx0sIWRUUA0Zf3xkgmECaHv876hXzOPS12wrk3ce6WwWhO0nr4oyPrtTue0P9puCh4J4fcJtqWK5-4kHkJLORjzhLGL9-'
          },
          body: jsonEncode(body));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      print(await read(Uri.https('example.com', 'foobar.txt')));
    }
    catch(e){
      print(e);
    }
  }

  static Future<void> deleteMessage(Message message) async {
    if(message.type == Type.image) {
      await storage.refFromURL(message.message).delete();
    }
    firestore
        .collection('chats/${getConversationID(message.receiverID)}/messages/')
        .doc(message.sent)
        .delete();
  }

  //creating community
  static Future<void> createCommunity(String userName, String id, String communityName, String communityPic) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    DocumentReference comRef = await firestore
        .collection('communities')
        .add({
      "communityName": communityName,
      "image": communityPic,
      'admin': id,
      "about": "Connecting world via Sparrow!",
      "members": [],
      "communityID": "",
      "createdAt": time,
      "pushToken": '',


    });

    await comRef.update({
      "members" : [id],
      "communityID": comRef.id,
    });



  }



}
