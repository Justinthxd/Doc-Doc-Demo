import 'package:flutter/material.dart';

class Option extends StatelessWidget {
  Option({
    required this.title,
    required this.color,
    required this.icon,
    Key? key,
  }) : super(key: key);

  String title;
  Color color;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 100,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 240, 240, 240),
          boxShadow: const [
            BoxShadow(
              blurRadius: 5,
              color: Color.fromARGB(255, 255, 255, 255),
              offset: Offset(-3, -3),
            ),
            BoxShadow(
              blurRadius: 5,
              color: Color.fromARGB(255, 230, 230, 230),
              offset: Offset(3, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: color.withOpacity(0.03),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 45,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
