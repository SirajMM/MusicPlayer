import 'package:blaze_player/screens/home_screen.dart';
import 'package:blaze_player/widgets/customlisttile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

TextEditingController _searchController = TextEditingController();

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      // ignore: sized_box_for_whitespace
      child: Container(
        width: size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Search',
                style: headingStyle,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  // border:BoxBorder. ,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(40)),
              width: 300,
              height: 50,
              // Add padding around the search bar

              // Use a Material design search bar
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',

                  // Add a clear button to the search bar
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _searchController.clear(),
                  ),
                  // Add a search icon or button to the search bar
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      // Perform the search here
                    },
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 24, 13, 13)),
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: size.width * 0.02),
                  child: Text(
                    'Recent Searches',
                    style: GoogleFonts.genos(
                        // ignore: prefer_const_constructors
                        textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    )),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            // ignore: sized_box_for_whitespace
            Container(
              height: size.height,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => costemListTile(
                    titile: 'Samjhavan',
                    singer: 'Arjith Singh',
                    cover: 'asset/images/Geena mera.jpg'),
                itemCount: 5,
              ),
            )
          ],
        ),
      ),
    );
  }
}
