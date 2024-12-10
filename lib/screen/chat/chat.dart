import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screen/chat/widgets/chat_box.dart';
import 'package:flutter_firebase/screen/chat/widgets/no_data.dart';
import 'package:flutter_firebase/components/prompt_dialog.dart';
import 'package:flutter_firebase/model/message_model.dart';
import 'package:flutter_firebase/screen/auth/profile.dart';
import 'package:flutter_firebase/service/chat_service.dart';
import 'package:flutter_firebase/service/user_service.dart';
import 'package:flutter_firebase/themes/constant.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
  });

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final _firebase = FirebaseFirestore.instance;
  final _chatService = ChatService();
  final _userService = UserService();

  final TextEditingController _etChat = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _userid = "";
  String _photoUrl = "";

  bool _showBackToBottomButton = false;

  @override
  void initState() {
    super.initState();

    _getUser();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _etChat.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  void _getUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userid = user.uid;
        _photoUrl = user.photoURL ?? '';
      });
    }
  }

  void _onScroll() {
    setState(() {
      if (_scrollController.offset >= 400) {
        _showBackToBottomButton = true;
      } else {
        _showBackToBottomButton = false;
      }
    });
  }

  void _scrollToBottom() {
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //two scaffold for keyboard overflow
      body: Scaffold(
        backgroundColor: kWhiteColor,
        floatingActionButton: !_showBackToBottomButton
            ? null
            : SizedBox(
                width: 45,
                height: 45,
                child: FittedBox(
                  child: FloatingActionButton(
                    heroTag: null,
                    onPressed: _scrollToBottom,
                    backgroundColor: kGreyColor,
                    child: const Icon(
                      Icons.expand_more,
                      size: 30,
                    ),
                  ),
                ),
              ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(kPadding),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: kGreyColor.shade200,
                        backgroundImage:
                            _photoUrl.isEmpty ? null : NetworkImage(_photoUrl),
                        child: InkWell(
                          onTap: () async {
                            if (!FirebaseAuth
                                .instance.currentUser!.isAnonymous) {
                              await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ProfileScreen()));

                              _getUser();
                            }
                          },
                          child: _photoUrl.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  size: 20,
                                  color: kSecondaryColor,
                                )
                              : Container(),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return PromptDialog(
                                  icon: Icons.logout,
                                  title: "Logout",
                                  content: "Are you sure you want to logout?",
                                  onConfirm: () async {
                                    Navigator.pop(context);

                                    await _userService.logout();
                                  },
                                  onCancel: () {
                                    Navigator.pop(context);
                                  },
                                );
                              });
                        },
                        icon: const Icon(
                          Icons.logout,
                          color: kRedColor,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: kPadding,
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firebase
                          .collection('users')
                          .doc(_userid)
                          .collection('chats')
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          final messages = snapshot.data?.docs;
                          List<Message> msgList = [];
                          for (int i = 0; i < messages!.length; i++) {
                            Message message = Message.fromJson(
                                messages[i].data() as Map<String, dynamic>);
                            message.id = messages[i].id;
                            msgList.add(message);
                          }

                          return msgList.isEmpty
                              ? const NoData()
                              : GroupedListView<Message, String>(
                                  controller: _scrollController,
                                  reverse: true,
                                  elements: msgList,
                                  groupBy: (Message msg) =>
                                      DateFormat('yyyy-MM-dd')
                                          .format(msg.createdAt),
                                  order: GroupedListOrder.DESC,
                                  itemComparator: (a, b) =>
                                      a.createdAt.compareTo(b.createdAt),
                                  groupSeparatorBuilder: (String value) =>
                                      Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(top: 12),
                                    alignment: Alignment.center,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 7, horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: kWhiteColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: kGreyColor.shade400,
                                            offset: const Offset(0, 1),
                                            blurRadius: 2.0,
                                          ),
                                        ],
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(6)),
                                      ),
                                      child: Text(
                                        value,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: kGreyColor),
                                      ),
                                    ),
                                  ),
                                  itemBuilder: (context, Message message) {
                                    return ChatBox(
                                      message: message,
                                      onLongPress: message.id.isEmpty
                                          ? null
                                          : () async {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return PromptDialog(
                                                      icon: Icons.delete,
                                                      title: "Delete Message",
                                                      content:
                                                          "Are you sure you want to delete this messasge?",
                                                      onConfirm: () async {
                                                        Navigator.pop(context);

                                                        String result =
                                                            await _chatService
                                                                .deleteMessage(
                                                                    _userid,
                                                                    message.id);
                                                        if (!context.mounted) {
                                                          return;
                                                        }

                                                        if (result.isNotEmpty) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            content:
                                                                Text(result),
                                                          ));
                                                        }
                                                      },
                                                      onCancel: () {
                                                        Navigator.pop(context);
                                                      },
                                                    );
                                                  });
                                            },
                                    );
                                  },
                                );
                        } else {
                          return Center(
                            child: Container(
                              height: 20,
                              width: 20,
                              margin: const EdgeInsets.all(5),
                              child: const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    kPrimaryColor),
                                strokeWidth: 2.0,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: kWhiteColor,
              boxShadow: [
                BoxShadow(
                  color: kGreyColor.shade300,
                  offset: const Offset(0, 1),
                  blurRadius: 2.0,
                ),
              ],
            ),
            padding: const EdgeInsets.all(kPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: TextFormField(
                    autofocus: false,
                    textCapitalization: TextCapitalization.sentences,
                    controller: _etChat,
                    minLines: 1,
                    maxLines: 3,
                    textAlignVertical: TextAlignVertical.top,
                    style: const TextStyle(
                        fontSize: 14, color: kBlackColor, letterSpacing: 0.2),
                    decoration: InputDecoration(
                      fillColor: kSecondaryColor.shade50,
                      filled: true,
                      hintText: 'Write a message',
                      hintStyle: const TextStyle(
                          color: kGreyColor,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1),
                      focusedBorder: UnderlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          borderSide:
                              BorderSide(color: kSecondaryColor.shade50)),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: kSecondaryColor.shade50),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                ElevatedButton(
                  onPressed: () async {
                    if (_etChat.text.trim().isNotEmpty) {
                      FocusScope.of(context).unfocus();

                      String chatMsg = _etChat.text;

                      setState(() {
                        _etChat.clear(); //clear textbox
                      });

                      String result = await _chatService.sendChat(
                          userId: _userid, messageContent: chatMsg);

                      if (result.isNotEmpty && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(result),
                        ));
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: kPrimaryColor,
                    padding: const EdgeInsets.all(8),
                  ),
                  child: const Icon(
                    Icons.send,
                    color: kWhiteColor,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
