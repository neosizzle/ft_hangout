
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../widgets/messages_app_bar.dart';

class MessagePage extends StatefulWidget {
  final int contactId;

  const MessagePage({super.key, required this.contactId});

  @override
  MessagePageState createState() => MessagePageState();
}

class MessagePageState extends State<MessagePage> {
  List<Map<String, dynamic>>? messages;
  Map<String, dynamic>? contact;

  final TextEditingController messageController =
      TextEditingController();

  final ScrollController scrollController = ScrollController();

  Future<void> loadMessages() async {
    final result = await DatabaseHelper.instance
        .getAllMessagesFromContactId(widget.contactId);

    if (!mounted) return;

    setState(() {
      messages = result;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(
          scrollController.position.maxScrollExtent,
        );
      }
    });
  }

  Future<void> loadUser() async {
    final result = await DatabaseHelper.instance
        .getContactById(widget.contactId);

    if (!mounted) return;

    setState(() {
      contact = result;
    });
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();

    if (text.isEmpty) return;

    // TODO: Insert the message into your database.
    // Example:
    // await DatabaseHelper.instance.insertMessage(...);

    messageController.clear();

    await loadMessages();
  }

  @override
  void initState() {
    super.initState();
    loadMessages();
    loadUser();
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MessagesAppBar(
        username: contact?['name'] ?? '',
        contactId: widget.contactId,
        onEdit: loadUser,
      ),

      body: Column(
        children: [
          // Messages
          Expanded(
            child: messages == null
                ? const Center(child: CircularProgressIndicator())
                : messages!.isEmpty
                    ? const Center(
                        child: Text('No messages yet. Say hello!'),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.all(12),
                        itemCount: messages!.length,
                        itemBuilder: (context, index) {
                          final message = messages![index];

                          // TODO: Replace with your actual
                          // sent/received field.
                          final bool isSent =
                              message['is_sender'] == 1;

                          return Align(
                            alignment: isSent
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.75,
                              ),
                              margin: const EdgeInsets.symmetric(
                                vertical: 5,
                              ),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSent
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    message['contents'] ?? '',
                                    style: TextStyle(
                                      color: isSent
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 5),

                                  Text(
                                    message['created_at'] ?? '',
                                    style: TextStyle(
                                      color: isSent
                                          ? Colors.white70
                                          : Colors.black54,
                                      fontSize: 10,
                                    ),
                                  ),


                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),

          // Message input
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send),
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
