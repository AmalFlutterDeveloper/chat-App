import 'package:chat_app/constants.dart';
import 'package:chat_app/model/Message.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widget/chat_buble.dart';

class ChatPage extends StatelessWidget {
  static String id = 'Chat Page';
  String data = '';
  TextEditingController textController = TextEditingController();
  final _controller = ScrollController();
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessageCollection);
  @override
  Widget build(BuildContext context) {
    String email = ModalRoute.of(context)!.settings.arguments as String;
    return StreamBuilder<QuerySnapshot>(
        stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            List<Message> messageList = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              messageList.add(Message.fromJson(snapshot.data!.docs[i]));
            }
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      kLogo,
                      height: 50,
                    ),
                    const Text('Scholar Chat'),
                  ],
                ),
                centerTitle: true,
                backgroundColor: kPrimaryColor,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      controller: _controller,
                      itemCount: messageList.length,
                      itemBuilder: (context, index) {
                        return messageList[index].id == email
                            ? ChatBuble(
                                message: messageList[index],
                              )
                            : ChatBubleForFriend(message: messageList[index]);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: textController,
                      onSubmitted: (value) {
                        sending(value, email);
                      },
                      onChanged: (value) {
                        data = value;
                      },
                      decoration: InputDecoration(
                        suffix: GestureDetector(
                          onTap: () {
                            sending(data, email);
                          },
                          child: Icon(
                            Icons.send,
                            color: kPrimaryColor,
                          ),
                        ),
                        hintText: 'Send Message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide:
                                BorderSide(color: kPrimaryColor, width: 2)),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Text('Loading.......');
          }
        }));
  }

  void sending(String value, String email) {
    messages.add({kmessage: value, kCreatedAt: DateTime.now(), 'id': email});
    textController.clear();
    _controller.animateTo(0,
        duration: Duration(microseconds: 500), curve: Curves.fastOutSlowIn);
  }
}
