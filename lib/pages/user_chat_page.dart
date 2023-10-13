import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:sparrow_v1/pages/about_user.dart';
import '../api/apis.dart';
import '../custom_icon.dart';
import '../helper/dialogs.dart';
import '../main.dart';
import '../models/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import '../models/message.dart';
import '../widgets/message_card.dart';

class UserChatPage extends StatefulWidget {
  final ChatUser user;
  const UserChatPage({super.key, required this.user});

  @override
  State<UserChatPage> createState() => _UserChatPageState();
}

class _UserChatPageState extends State<UserChatPage> {
  late int milliseconds;
  late DateTime dateTime;
  late String formattedTime;
  late int milliseconds1;
  late DateTime dateTime1;
  late String formattedTime1;
  List<Message> _list = [];
  TextEditingController messageController = TextEditingController();
  bool _showSendButton = false;
  bool _showEmoji = false;
  Future<void> _openCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    //sendImageMessage(image!, widget.communityId);
    // Process the captured image as needed
  }

  void _onTextChanged(String text) {
    setState(() {
      _showSendButton = text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_showEmoji) {
            setState(() {
              _showEmoji = !_showEmoji;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70.0),
            child: AppBar(
              iconTheme: const IconThemeData(
                color: Colors
                    .black54, // Change the color of the hamburger icon here
              ),
              flexibleSpace: Center(child: _appBar()),
              elevation: 0,
              centerTitle: true,
              //backgroundColor: Colors.transparent,
              backgroundColor: Colors.transparent,
            ),
          ),
          body: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: 100.0, // Set the desired width
                            height: 35.0, // Set the desired height
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Set the desired corner radius
                              color: Colors.white, // Set the desired color
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Today', // The text to display
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w300,
                                  color: Colors
                                      .grey.shade400, // Set the text color
                                ),
                              ),
                            ),
                          ),
                        ), // chat content
                        Padding(
                          padding: const EdgeInsets.only(top: 40, bottom: 70),
                          child: chatMessages(),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.black.withOpacity(.04),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                      icon: Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey.shade800,
                                      ),
                                      onPressed: () async {
                                        final ImagePicker picker =
                                            ImagePicker();
                                        final XFile? image =
                                            await picker.pickImage(
                                                source: ImageSource.camera,
                                                imageQuality: 70);
                                        if (image != null) {
                                          APIs.sendChatImage(
                                              widget.user, File(image.path));
                                          Navigator.pop(context);
                                        }
                                      }
                                      //_openCamera,
                                      ),
                                  Expanded(
                                    child: TextField(
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 1,
                                      onTap: () {
                                        if (_showEmoji) {
                                          setState(() {
                                            //print(_showEmoji);
                                            _showEmoji = !_showEmoji;
                                          });
                                        }
                                      },
                                      controller: messageController,
                                      onChanged: _onTextChanged,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Enter your message',
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      final ImagePicker picker = ImagePicker();
                                      final List<XFile>? images = await picker
                                          .pickMultiImage(imageQuality: 70);
                                      for (var i in images!) {
                                        APIs.sendChatImage(
                                            widget.user, File(i.path));
                                      }
                                    },
                                    icon: Icon(
                                      Icons.image,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        //print(_showEmoji);
                                        FocusScope.of(context).unfocus();
                                        _showEmoji = !_showEmoji;
                                        _showSendButton = !_showSendButton;
                                      });
                                    },
                                    icon: _showEmoji
                                        ? Icon(
                                            Icons.keyboard,
                                            color: Colors.grey.shade800,
                                          )
                                        : Icon(
                                            Icons.emoji_emotions_rounded,
                                            color: Colors.grey.shade800,
                                          ),
                                  ),
                                  if (_showSendButton)
                                    IconButton(
                                      icon: Icon(
                                        Icons.send,
                                        color: Colors.purple.withOpacity(.7),
                                      ),
                                      onPressed: () {
                                        //sendMessage();
                                        if (messageController.text.isNotEmpty) {
                                          APIs.sendMessage(
                                              widget.user,
                                              messageController.text,
                                              Type.text);
                                          messageController.text = '';
                                        }
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ), // text bar
                        //if (_showEmoji)
                      ],
                    ),
                  ),
                  if (_showEmoji)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: mq.height * .30,
                        child: EmojiPicker(
                          textEditingController: messageController,
                          config: Config(
                            columns: 8,
                            emojiSizeMax: 32 *
                                (Platform.isIOS
                                    ? 1.30
                                    : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                            verticalSpacing: 0,
                            horizontalSpacing: 0,
                            gridPadding: EdgeInsets.zero,
                            initCategory: Category.RECENT,
                            bgColor: Color(0xFFF2F2F2),
                            indicatorColor: Colors.blue,
                            iconColor: Colors.grey,
                            iconColorSelected: Colors.blue,
                            backspaceColor: Colors.blue,
                            skinToneDialogBgColor: Colors.white,
                            skinToneIndicatorColor: Colors.grey,
                            enableSkinTones: true,
                            recentTabBehavior: RecentTabBehavior.RECENT,
                            recentsLimit: 28,
                            noRecents: const Text(
                              'No Recents',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black26),
                              textAlign: TextAlign.center,
                            ), // Needs to be const Widget
                            loadingIndicator: const SizedBox
                                .shrink(), // Needs to be const Widget
                            tabIndicatorAnimDuration: kTabScrollDuration,
                            categoryIcons: const CategoryIcons(),
                            buttonMode: ButtonMode.MATERIAL,
                          ),
                        ),
                      ),
                    ),
                ],
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
                  IconButton(icon: const Icon(Icons.person), onPressed: () {}),
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
                      onPressed: () {}),
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
          resizeToAvoidBottomInset: true,
        ),
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
        stream: APIs.getAllMessages(widget.user),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;

              _list =
                  data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
              if (_list.isNotEmpty) {
                return ListView.builder(
                    reverse: true,
                    itemCount: _list.length,
                    padding: EdgeInsets.only(top: mq.height * .01),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (_list[index].read == "") {
                        APIs.updateMessageReadStatus(_list[index]);
                      }
                      return PullDownButton(
                        itemBuilder: (context) => [
                          PullDownMenuItem(
                            title: 'Reply',
                            icon: CupertinoIcons.reply,
                            onTap: () {},
                          ),
                          _list[index].type == Type.image
                              ? PullDownMenuItem(
                                  title: 'Save image',
                                  icon: Icons.save_alt,
                                  onTap: () async {
                                    try{
                                      await GallerySaver.saveImage(_list[index].message, albumName: 'Sparrow')
                                          .then((success) {
                                        if (success != null && success) {
                                          Dialogs.showSnackBar(
                                              context, "Image Saved!", 800);
                                        }
                                      });
                                    }catch(e){
                                      log("Error while saving image $e");
                                    }
                                  },
                                )
                              : PullDownMenuItem(
                                  title: 'Copy',
                                  icon: Icons.copy,
                                  onTap: () async {
                                    await Clipboard.setData(ClipboardData(
                                            text: _list[index].message))
                                        .then((value) {
                                      Dialogs.showSnackBar(
                                          context, "Text copied!", 800);
                                    });
                                  },
                                ),
                          PullDownMenuItem(
                            title: 'Mark',
                            icon: CupertinoIcons.bookmark,
                            onTap: () {},
                          ),
                          PullDownMenuItem(
                            title: 'Info',
                            icon: CupertinoIcons.info,
                            onTap: () {
                              milliseconds = int.parse(_list[index].sent);
                              dateTime = DateTime.fromMillisecondsSinceEpoch(
                                  milliseconds);
                              formattedTime =
                                  DateFormat('h:mm a').format(dateTime);

                              if (_list[index].read.isNotEmpty) {
                                milliseconds1 = int.parse(_list[index].read);
                                dateTime1 = DateTime.fromMillisecondsSinceEpoch(
                                    milliseconds1);
                                formattedTime1 =
                                    DateFormat('h:mm a').format(dateTime1);
                              } else {
                                formattedTime1 = "";
                              }
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            bottom: 10.0),
                                                    decoration: const BoxDecoration(
                                                        //color: Theme.of(context).primaryColor,
                                                        ),
                                                    child: const Column(
                                                      children: <Widget>[
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              CupertinoIcons
                                                                  .info,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              "Message Info",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ],
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
                                              padding: const EdgeInsets.only(
                                                  left: 20.0,
                                                  right: 20.0,
                                                  top: 30,
                                                  bottom: 30),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Sent at : $formattedTime",
                                                      style: const TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Read at : $formattedTime1",
                                                      style: const TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0, bottom: 10.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.purple.shade200,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  32.0),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  32.0)),
                                                ),
                                                child: const Column(
                                                  children: <Widget>[
                                                    Text(
                                                      "ok",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                      textAlign:
                                                          TextAlign.center,
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
                          ),
                          PullDownMenuItem(
                            title: 'Delete',
                            icon: CupertinoIcons.delete,
                            onTap: () async {
                              await APIs.deleteMessage(_list[index])
                                  .then((value) {});
                            },
                          ),
                        ],
                        buttonBuilder: (context, showMenu) => CupertinoButton(
                            onPressed: showMenu,
                            padding: EdgeInsets.zero,
                            child: MessageCard(
                              message: _list[index], choice: 0,
                            )),
                      );
                      /*return Container(
                        child: CupertinoContextMenu(actions: [
                          CupertinoActionSheetAction(onPressed: (){Navigator.pop(context);}, child: Text("hii")),
                          CupertinoActionSheetAction(onPressed: (){Navigator.pop(context);}, child: Text("byee")),
                          CupertinoActionSheetAction(onPressed: (){Navigator.pop(context);}, child: Text("yee")),
                        ],
                          child: MessageCard(
                            message: _list[index],
                          ),),
                      );*/
                    });
              } else {
                return const Center(
                  child: Text("Say Hi!"),
                );
              }
          }
        });
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AboutUser(user: widget.user)));
      },
      child: StreamBuilder(
          stream: APIs.getUserInfo(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 300,
                  height: mq.height * .08,
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: mq.height * .06,
                        height: mq.height * .06,
                        imageUrl:
                            list.isNotEmpty ? list[0].image : widget.user.image,
                        //placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    title:
                        Text(list.isNotEmpty ? list[0].name : widget.user.name),
                    subtitle: Text(
                      list.isNotEmpty
                          ? list[0].isOnline
                              ? "online"
                              : APIs.getLastActiveTime(
                                  context: context,
                                  lastActive: list[0].lastActive)
                          : APIs.getLastActiveTime(
                              context: context,
                              lastActive: widget.user.lastActive),
                      maxLines: 1,
                    ),
                    //trailing: Text('12:00 AM'),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
