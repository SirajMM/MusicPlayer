import 'package:blaze_player/screens/home_screen.dart';
// import 'package:blaze_player/widgets/favorites.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gotoHome();
      // Use the constraints here
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Image.asset('asset/images/logo.png'),
                  // ignore: prefer_const_constructors
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text(
                    'Blaze Player',
                    style: GoogleFonts.italianno(
                        fontSize: 28, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  Future<void> gotoHome() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (ctx) => const Home_Screen()),
    );
  }
}
