import 'dart:convert';

import 'package:doc_doc/provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ref = FirebaseDatabase.instance.ref();
    final main = Provider.of<MainProvider>(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 12, 66, 110),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Maria Isabel',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            Text(
              'Online',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white38,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.video_call_rounded,
              size: 32,
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.call_rounded,
              size: 30,
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            Flexible(
              flex: 10,
              child: StreamBuilder(
                stream: ref.child('data').child('chat').onValue,
                builder: ((context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<Map> messages = [];

                    final data = snapshot.data.snapshot.value;

                    if (data != null) {
                      for (int i = 1; i < data.length; i++) {
                        messages.add(data[i]);
                      }
                    }

                    return ListView.builder(
                      itemCount: messages.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, index) {
                        return Message(
                          messages: messages[index]['message'],
                          user: messages[index]['user'],
                          date: DateTime.parse(messages[index]['date']),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(66, 180, 180, 180),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: TextField(
                      controller: controller,
                      textCapitalization: TextCapitalization.sentences,
                      style: const TextStyle(
                        fontSize: 19,
                      ),
                      decoration: const InputDecoration(
                        // filled: true,
                        hintText: 'Send a message',
                        hintStyle: TextStyle(
                          fontSize: 19,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        ref.child('data').once().then((value) {
                          final data = value.snapshot.value;
                          final res = jsonDecode(jsonEncode(data));
                          int x = res['count'];
                          x++;
                          // send message - - - - - - //
                          ref
                              .child('data')
                              .child('chat')
                              .child(x.toString())
                              .set(
                            {
                              'id': x,
                              'user': main.getName,
                              'message': controller.text,
                              'date': DateTime.now().toString(),
                            },
                          );
                          // update count - - - - - - //
                          ref.child('data').update({'count': x});
                          controller.text = '';
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                IconButton(
                  icon: const Icon(
                    Icons.send_rounded,
                    size: 30,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {
                    ref.child('data').once().then((value) {
                      final data = value.snapshot.value;
                      final re = jsonDecode(jsonEncode(data));
                      int x = re['count'];
                      x++;
                      // send message - - - - - - //
                      ref.child('data').child('chat').child(x.toString()).set(
                        {
                          'id': x,
                          'user': main.getName,
                          'message': controller.text,
                          'date': DateTime.now().toString(),
                        },
                      );
                      // update count - - - - - - //
                      ref.child('data').update({'count': x});
                      controller.text = '';
                    });

                    // FocusManager.instance.primaryFocus?.unfocus();
                  },
                ),
                const SizedBox(width: 15),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

class Message extends StatelessWidget {
  const Message({
    Key? key,
    required this.messages,
    required this.user,
    required this.date,
  }) : super(key: key);

  final String messages;
  final String user;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final main = Provider.of<MainProvider>(context);
    return ListTile(
      title: Row(
        mainAxisAlignment: user == main.getName
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: user == 'Justin'
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 0,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 236, 236, 236),
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white10,
                        Colors.black12,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        messages,
                        maxLines: 30,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  ' ${date.hour.toString()}:${date.minute.toString()} ',
                  style: const TextStyle(
                    color: Colors.black26,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
