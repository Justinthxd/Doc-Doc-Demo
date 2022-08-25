import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Color backgroundColor = Colors.black;
  double x = 1;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        backgroundColor = Color.fromARGB(255, 241, 241, 241);
      });
    });
    Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        x = 0;
      });
    });
    Timer(const Duration(milliseconds: 5000), () {
      setState(() {
        x = 1;
      });
    });
    Future.delayed(const Duration(milliseconds: 5000), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        color: backgroundColor,
        child: Stack(
          children: [
            // Body - - - - - - - - - - - //
            Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  Container(
                    height: 45,
                    child: Image.asset(
                      "assets/logo.png",
                      color: Colors.white,
                      colorBlendMode: BlendMode.modulate,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "¡Somos la cura del sistema de salud!",
                    style: TextStyle(
                      fontFamily: 'GFS',
                      fontSize: 18,
                      inherit: false,
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
            // Background - - - - - - - - //
            AnimatedContainer(
              height: double.infinity,
              width: double.infinity,
              color: backgroundColor.withOpacity(x),
              duration: const Duration(seconds: 1),
            ),
          ],
        ),
      ),
    );
  }
}
