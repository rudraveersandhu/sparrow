import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sparrow_v1/pages/community_chat_page.dart';

import '../api/apis.dart';
import '../main.dart';
import '../models/community.dart';
import '../models/message.dart';

class CommunityCard extends StatefulWidget {

  final Map<String,dynamic>? community;
  const CommunityCard({super.key,required this.community});

  @override
  State<CommunityCard> createState() => _CommunityCardState();
}

class _CommunityCardState extends State<CommunityCard> {
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.02, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: .5,
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) => CommunityChatPage(community: widget.community,)));
        },
          child: StreamBuilder(
              stream: APIs.getComLastMessage(widget.community!),
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
                        width: mq.height * .06,
                        height: mq.height * .06,
                        imageUrl: widget.community?['image'],
                        //placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    title: Text(widget.community?['communityName'],style: const TextStyle(
                      color: Colors.black
                    ),),
                    subtitle: Text(widget.community?['about'],style: const TextStyle(
                        color: Colors.black
                    ),),

                    //_message?.type == Type.text ? Text(_message != null ? _message!.message : widget.community.about, maxLines: 1,) : const Align(alignment: Alignment.centerLeft, child: Icon(Icons.image, size: 25)),
                    /*trailing: _message == null
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
                        context: context, time: _message!.sent)
                    )*/
                );
              })),
      );
  }
}
