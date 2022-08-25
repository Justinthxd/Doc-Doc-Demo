import 'dart:convert';

import 'package:doc_doc/provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../widgets/option.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  TextEditingController c1 = TextEditingController();
  TextEditingController c2 = TextEditingController();

  final icons = [
    Icons.health_and_safety_rounded,
    Icons.group_rounded,
    Icons.fastfood_rounded,
    Icons.all_inclusive_rounded,
    Icons.wb_twilight_rounded,
    Icons.person_add_rounded,
    Icons.personal_injury_rounded,
  ];

  final colors = [
    Colors.green,
    Colors.cyan,
    Colors.red,
    Colors.purpleAccent,
    Colors.orange,
    Colors.blueAccent,
    Colors.black,
  ];

  final titles = [
    'General',
    'Familia',
    'Nutricionista',
    'Psychologia',
    'Veterinaria',
    'Terapia',
    'Psiquiatria'
  ];

  userSettings() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final ref = FirebaseDatabase.instance.ref();
        final size = MediaQuery.of(context).size;
        final main = Provider.of<MainProvider>(context);
        return AlertDialog(
          title: const Text(
            'Account',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const SizedBox(height: 10),
                myField(size, 'Email', c1),
                const SizedBox(height: 10),
                myField(size, 'Password', c2),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue.withOpacity(0.9),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    ref.child('data').child('users').once().then((value) {
                      final data = value.snapshot.value;

                      final res = jsonDecode(jsonEncode(data));

                      res.forEach((key, value) {
                        if (c1.text.trim() == value['email'] &&
                            c2.text.trim() == value['password']) {
                          main.setEmail = value['email'];
                          main.setName = value['name'];
                          main.setUserActive = true;
                        }
                      });

                      c1.text = '';
                      c2.text = '';

                      Navigator.pop(context);
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Don\'t have an account?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey.withOpacity(0.4),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/user');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final main = Provider.of<MainProvider>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 12, 66, 110),
        title: Container(
          height: 25,
          child: Image.asset(
            'assets/logo.png',
          ),
        ),
        actions: [
          main.getUserActive
              ? IconButton(
                  icon: const Icon(
                    Icons.logout_rounded,
                    size: 28,
                  ),
                  onPressed: () {
                    main.setEmail = '';
                    main.setName = '';
                    main.setUserActive = false;
                  },
                )
              : IconButton(
                  icon: const Icon(
                    Icons.person_rounded,
                    size: 28,
                  ),
                  onPressed: () {
                    userSettings();
                  },
                ),
          const SizedBox(width: 5),
          IconButton(
            icon: const Icon(
              Icons.settings_rounded,
              size: 28,
            ),
            onPressed: () {
              userSettings();
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.all(10),
        child: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 69, 136, 212),
          child: const Icon(
            Icons.chat_rounded,
            size: 33,
          ),
          onPressed: () {},
        ),
      ),
      body: !main.getUserActive
          ? const Center(
              child: Text(
                'You need an account',
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 20,
                ),
              ),
            )
          : Container(
              height: size.height,
              width: size.width,
              child: Stack(
                children: [
                  ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      const SizedBox(height: 5),
                      Container(
                        height: 120,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (int i = 0; i < titles.length; i++)
                              Option(
                                title: titles[i],
                                color: colors[i],
                                icon: icons[i],
                              ),
                          ],
                        ),
                      ),
                      Container(
                        width: 600,
                        child: Row(
                          children: [
                            const SizedBox(width: 20),
                            const Text(
                              'chats',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: const Divider(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.all(17),
                        onTap: () {
                          Navigator.pushNamed(context, '/chat');
                        },
                        leading: const CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://media.istockphoto.com/photos/female-doctor-in-mask-and-with-stethoscope-on-gray-background-picture-id1191432912?k=20&m=1191432912&s=612x612&w=0&h=_DxjpDAHaNkLiGiDGiIc7nxmyQPkGfi2rBA-zbgmZmM=',
                          ),
                          backgroundColor: Color.fromARGB(95, 206, 206, 206),
                          radius: 30,
                        ),
                        title: const Text(
                          'Maria Isabel',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Online',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(95, 45, 231, 28),
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  BoxShadow(
                                    blurRadius: 1,
                                    color: Color.fromARGB(183, 45, 90, 46),
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Psicologa - Medicina General',
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Divider(),
                        ),
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.all(17),
                        onTap: () {},
                        leading: Stack(
                          children: const [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://media.istockphoto.com/photos/confident-successful-mature-doctor-at-hospital-picture-id1346124900?b=1&k=20&m=1346124900&s=170667a&w=0&h=72WNlS21HoZ3ePFDicsERYpr_KCJwrM8HqzjTdiyNdc=',
                              ),
                              backgroundColor:
                                  Color.fromARGB(95, 206, 206, 206),
                              radius: 30,
                            ),
                          ],
                        ),
                        title: const Text(
                          'Carlos Santana',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Offline',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(95, 176, 179, 176),
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  BoxShadow(
                                    blurRadius: 1,
                                    color: Color.fromARGB(183, 105, 105, 105),
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Pediatra - Psicologo',
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Divider(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget myField(Size size, String hint, TextEditingController controller) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(108, 189, 189, 189),
        borderRadius: BorderRadius.circular(9),
      ),
      child: TextField(
        controller: controller,
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(
          fontSize: 19,
        ),
        obscureText: hint == 'Password' ? true : false,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 19,
            color: Colors.black45,
            fontWeight: FontWeight.w500,
          ),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
