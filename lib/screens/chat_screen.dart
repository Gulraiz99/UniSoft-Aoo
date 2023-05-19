import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final String projectId;

  ChatScreen({required this.projectId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late User currentUser;
  late TextEditingController messageController;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser!;
    messageController = TextEditingController();
  }

  Future<void> _sendMessage(String text) async {
    try {
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId)
          .collection('messages')
          .add({
        'text': text,
        'senderId': currentUser.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Failed to send message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('projects')
                  .doc(widget.projectId)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Something went wrong'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final List<DocumentSnapshot> documents = snapshot.data!.docs;

                return ListView.builder(
                  controller: scrollController,
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final message = documents[index];
                    final isMe = message['senderId'] == currentUser.uid;
                    final alignment = isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start;
                    final bubbleColor =
                        isMe ? Colors.greenAccent : Colors.grey[300];

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                      child: Column(
                        crossAxisAlignment: alignment,
                        children: [
                          Material(
                            color: bubbleColor,
                            borderRadius: BorderRadius.circular(30.0),
                            elevation: 6.0,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 15.0,
                              ),
                              child: Text(
                                message['text'],
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            message['timestamp'].toDate().toString(),
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    String text = messageController.text.trim();
                    if (text.isNotEmpty) {
                      _sendMessage(text);
                      messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
