import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sparrow_v1/api/apis.dart';
import '../main.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../pages/user_chat_page.dart';

class UserCard extends StatefulWidget {
  final ChatUser user;
  const UserCard({super.key, required this.user});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.02, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: .5,
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => UserChatPage(
                          user: widget.user,
                        )));
          },
          child: StreamBuilder(
              stream: APIs.getLastMessage(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list = data
                        ?.map((e) =>
                            Message.fromJson(e.data() as Map<String, dynamic>))
                        .toList() ??
                    [];
                if (list.isNotEmpty) {
                  _message = list[0];
                }

                return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: mq.height * .06,
                        height: mq.height * .06,
                        imageUrl: widget.user.image,
                        //placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    title: Text(widget.user.name),
                    subtitle: _message?.type == Type.text ? Text(_message != null ? _message!.message : widget.user.about, maxLines: 1,) : const Align(alignment: Alignment.centerLeft, child: Icon(Icons.image, size: 25)),
                    trailing: _message == null
                        ? null
                        : _message!.read == 'false'
                            ? Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                    color: Colors.lightGreenAccent.shade400,
                                    borderRadius: BorderRadius.circular(10)),
                              )
                            : Text(APIs.getLastMessageTime(
                                context: context, time: _message!.sent)));
              })),
    );
  }
}
