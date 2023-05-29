import 'package:blaze_player/styles/stile1.dart';
import 'package:flutter/material.dart';


import '../../widgets/utlities.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Us',
          style: headingStyle,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(child: about()),
          ],
        ),
      )),
    );
  }
}
