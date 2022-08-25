import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class User extends StatefulWidget {
  const User({Key? key}) : super(key: key);

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  final ref = FirebaseDatabase.instance.ref();

  List<TextEditingController> controllers = [
    for (int i = 0; i < 4; i++) TextEditingController(text: ''),
  ];

  add() {
    if (controllers[0].text != '' &&
        controllers[1].text != '' &&
        controllers[2].text != '' &&
        controllers[3].text != '') {
      ref.child('data').child('users').push().set({
        'name': controllers[0].text.trim(),
        'lastname': controllers[1].text.trim(),
        'email': controllers[2].text.trim(),
        'password': controllers[3].text.trim(),
      });
      for (int i = 0; i < 4; i++) {
        controllers[i].text = '';
      }
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 12, 66, 110),
        title: const Text(
          'Create User',
          style: TextStyle(
            color: Colors.white,
            fontSize: 27,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_rounded),
            onPressed: () {
              add();
            },
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(height: size.height * 0.02),
          myField(size, "Name", Icons.person, controllers[0]),
          SizedBox(height: size.height * 0.005),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05,
            ),
            child: const Divider(),
          ),
          SizedBox(height: size.height * 0.005),
          myField(
              size, "Last Name", Icons.person_outline_rounded, controllers[1]),
          SizedBox(height: size.height * 0.005),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05,
            ),
            child: const Divider(),
          ),
          SizedBox(height: size.height * 0.005),
          myField(size, "Email", Icons.email, controllers[2]),
          SizedBox(height: size.height * 0.005),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05,
            ),
            child: const Divider(),
          ),
          SizedBox(height: size.height * 0.005),
          myField(size, "Password", Icons.lock_rounded, controllers[3]),
          SizedBox(height: size.height * 0.005),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05,
            ),
            child: const Divider(),
          ),
          SizedBox(height: size.height * 0.005),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                add();
              },
            ),
          ),
          SizedBox(height: size.height * 0.02),
        ],
      ),
    );
  }
}

Widget myField(
    Size size, String hint, IconData icon, TextEditingController controller) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: size.width * 0.01,
      vertical: size.height * 0.01,
    ),
    decoration: BoxDecoration(
      color: Color.fromARGB(108, 70, 70, 70),
      borderRadius: BorderRadius.circular(9),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 15),
    child: TextField(
      controller: controller,
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(
        fontSize: 19,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.white,
        ),
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 19,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    ),
  );
}
