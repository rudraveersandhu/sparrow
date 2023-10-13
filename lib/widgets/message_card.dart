import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../api/apis.dart';
import '../main.dart';
import '../models/message.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  final int choice ;
  const MessageCard({super.key, required this.message, required this.choice});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  late int milliseconds;
  late DateTime dateTime;
  late String formattedTime;
  late String name ;



  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.senderID
        ? _senderMessageBox()
        : _receiverMessageBox();
  }

   _senderMessageBox() {
    milliseconds = int.parse(widget.message.sent);
    dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    formattedTime = DateFormat('h:mm a').format(dateTime);
    if (widget.message.read == "") {
      APIs.updateMessageReadStatus(widget.message);
      print("message status updated");
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 35, left: 3),
          child: Text(
            formattedTime,
            style: const TextStyle(fontSize: 10, color: Colors.black45),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 35, left: 3),
          child: getIconWidget(),
        ),
        Container(
          constraints: BoxConstraints(maxWidth: mq.width * 0.7),
          padding: EdgeInsets.all(widget.message.type == Type.image
              ? mq.width * .025
              : mq.width * .04),
          margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04, vertical: mq.height * .01),
          decoration: BoxDecoration(
            color: Colors.purple.shade200,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
          ),
          child: widget.message.type == Type.text
              ? Text(
                  widget.message.message,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),

                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: widget.message.message,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.image,
                      size: 70,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget getIconWidget() {
    if (widget.message.read.isNotEmpty) {
      return const Icon(Icons.done_all_rounded,
          color: Colors.blue,
          size:
              15); // Replace 'icon_a' with the icon you want to display for condition 'a'
    } else {
      return const Icon(Icons.done_all_rounded,
          color: Colors.grey,
          size:
              15); // Replace 'icon_b' with the icon you want to display for condition 'b'
    }
  }





  Widget _receiverMessageBox()  {
    milliseconds = int.parse(widget.message.sent);
    dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    formattedTime = DateFormat('h:mm a').format(dateTime);


    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Container(
          padding: EdgeInsets.all(widget.message.type == Type.image
              ? mq.width * .025
              : mq.width * .04),
          constraints: BoxConstraints(maxWidth: mq.width * 0.7),
          margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04, vertical: mq.height * .01),
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.message.senderName,
                style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black45,
              ),),
              widget.message.type == Type.text
                  ? Text(widget.message.message,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: widget.message.message,
                  placeholder: (context, url) =>
                  const CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.image,
                    size: 70,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 35, left: 3, right: 10),
          child: Text(
            formattedTime,
            style: const TextStyle(fontSize: 10, color: Colors.black45),
          ),
        ),
      ],
    );
  }
}
