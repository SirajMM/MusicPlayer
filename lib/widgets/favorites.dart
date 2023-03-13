import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(2),
            leading: const Icon(Icons.arrow_back_ios_new),
            title: Text(
              'Favorite Songs',
              style: GoogleFonts.italianno(
                // ignore: prefer_const_constructors
                textStyle: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(176, 0, 0, 0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
