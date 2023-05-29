import 'package:blaze_player/application/splash_provider/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    super.key,
  });

  // @override
  @override
  Widget build(BuildContext context) {
    Provider.of<SplashProvider>(context, listen: true)
        .requestPermission(context);
    return Consumer<SplashProvider>(
      builder: (context, value, child) => Scaffold(
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
      ),
    );
  }
}
