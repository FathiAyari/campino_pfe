import 'package:campino/Models/Users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

final snapshotMessages = FirebaseFirestore.instance;
ScrollController controller = new ScrollController();

class Messenger extends StatefulWidget {
  final Cusers user;

  const Messenger({required this.user});

  @override
  _MessengerState createState() => _MessengerState();
}

class _MessengerState extends State<Messenger> {
  String textMessage = "";

  bool isShowSticker = false;
  bool showKeyBoard = false;
  var focusNode = FocusNode();
  var inputFlex = 1;
  var numLines;

  ScrollController controller = new ScrollController();
  TextEditingController messageController = new TextEditingController();
  @override
  var currentUser = GetStorage().read("user");

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 60,
                  color: Color(0xffEAEDEF),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () async {
                            await SystemChannels.textInput.invokeMethod('TextInput.hide');

                            Get.back();
                          },
                          icon: Icon(Icons.arrow_back_ios)),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.green,
                        child: CircleAvatar(
                          radius: 23,
                          backgroundImage: NetworkImage("${widget.user.profileUrl}"),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      Text(
                        "${widget.user.userName}",
                        style: TextStyle(fontSize: size.height * 0.028, fontFamily: "NewsCycle-Bold"),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                )),
            Expanded(
                child: Column(
              children: [
                MessageStreamBuilder(
                  uid: widget.user.uid,
                )
              ],
            )),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          onChanged: (value) {},
                          cursorColor: Colors.black,
                          style: TextStyle(
                            height: 1.7,
                          ),
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 5,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(2),
                            filled: true,
                            hintText: "Ecrir un message",
                            fillColor: Colors.cyan.withOpacity(0.2),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Container(
                        decoration: BoxDecoration(color: Color(0xff00a984), borderRadius: BorderRadius.circular(50)),
                        child: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (!messageController.text.isEmpty) {
                              snapshotMessages.collection('messages').add({
                                'text': "${messageController.text}",
                                'destination': "${widget.user.uid}",
                                'sender': "${currentUser['uid']}",
                                'time': FieldValue.serverTimestamp(),
                              }).then((value) => messageController.clear());
                            }
                          },
                          color: Colors.blueAccent,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageLine extends StatefulWidget {
  final String getText;
  final String getSender;
  final String getDestination;
  final DateTime getTime;
  final bool check;

  const MessageLine({
    required this.getText,
    required this.getSender,
    required this.getDestination,
    required this.check,
    required this.getTime,
  });

  @override
  _MessageLineState createState() => _MessageLineState();
}

class _MessageLineState extends State<MessageLine> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: widget.check ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
            borderRadius: widget.check
                ? BorderRadius.only(
                    topLeft: Radius.circular(15), bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15))
                : BorderRadius.only(
                    topRight: Radius.circular(20), bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
            color: widget.check ? Color(0xff5a40a1) : Color(0xffe6ebf5),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                "${widget.getText}",
                style: TextStyle(fontSize: 20, color: widget.check ? Colors.white : Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//tous les messages
class MessageStreamBuilder extends StatefulWidget {
  final String uid;
  const MessageStreamBuilder({
    required this.uid,
  });
  @override
  _MessageStreamBuilderState createState() => _MessageStreamBuilderState();
}

class _MessageStreamBuilderState extends State<MessageStreamBuilder> {
  var currentUser = GetStorage().read("user");

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: snapshotMessages.collection('messages').orderBy('time').snapshots(),
      builder: (context, snapshot) {
        List<MessageLine> msg = [];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        // reverse the order of the list items
        final messages = snapshot.data!.docs.reversed;
        for (var message in messages) {
          final getText = message.get('text');
          final getSender = message.get('sender');
          final getDestination = message.get('destination');
          final getTime = DateTime.now();

          if ((getSender == currentUser['uid'] && getDestination == widget.uid) ||
              (getSender == widget.uid && getDestination == currentUser['uid'])) {
            final messageWidget = MessageLine(
              getText: getText,
              getSender: getSender,
              getDestination: getDestination,
              check: currentUser['uid'] == getSender ? true : false,
              getTime: getTime,
            );

            msg.add(messageWidget);
          }
        }

        return Expanded(
            child: ListView(
          reverse: true,
          padding: EdgeInsets.all(20),
          controller: controller,
          children: msg,
        ));
      },
    );
  }
}
