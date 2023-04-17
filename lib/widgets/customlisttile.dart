// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables

import 'package:blaze_player/styles/stile1.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';

// class CustemListTile extends StatefulWidget {
//   const CustemListTile({
//     super.key,
//     required this.title,
//     required this.singer,
//     required this.cover,
//     required this.index,
//   });
//   final title;
//   final singer;
//   final cover;
//   final index;

//   @override
//   State<CustemListTile> createState() => _CustemListTileState();
// }

// List isPlaying = [false];
// IconData playicon = Icons.play_arrow;
// var isFavorite = true;

// class _CustemListTileState extends State<CustemListTile> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             height: 80,
//             width: 80,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16.0),
//                 image: DecorationImage(
//                     image: AssetImage(widget.cover!), fit: BoxFit.cover)),
//           ),
//           const SizedBox(
//             width: 20,
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.title!,
//                   style: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.w600),
//                 ),
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 Text(widget.singer!),
//               ],
//             ),
//           ),
//           Builder(builder: (context) {
//             return IconButton(
//               color: buttoncolor,
//               onPressed: () async {
//                 ScaffoldMessenger.of(context).clearSnackBars();
//                 if (isFavorite) {
//                   const snackBar = SnackBar(
//                     content: Text('Removed from favorite'),
//                   );

//                   ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                 } else {
//                   const snackBar = SnackBar(
//                     content: Text('Added to favorite'),
//                   );

//                   ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                 }
//                 setState(
//                   () {
//                     isFavorite = !isFavorite;
//                   },
//                 );
//               },
//               icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
//             );
//           }),
//           PopupMenuButton(
//             itemBuilder: (context) {
//               return [
//                 PopupMenuItem(
//                   value: 1,
//                   child: Row(
//                     children: const [
//                       Icon(Icons.remove_circle_outline),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Text('Rmove')
//                     ],
//                   ),
//                 ),
//               ];
//             },
//             onSelected: (value) {
//               switch (value) {
//                 case 1:
//                   break;
//               }
//             },
//           )
//         ],
//       ),
//     );
//   }
// }

Widget costemListTile({
  String? titile,
  String? singer,
  cover,
  context,
}) {
  bool isplaying = false;
  IconData playicon = Icons.play_arrow;

  var isFavorite = true;
  return BlurryContainer(
    blur: 100,
    elevation: 2,
    color: const Color.fromARGB(11, 58, 13, 219),
    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
    padding: const EdgeInsets.all(8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
          width: MediaQuery.of(context).size.height * 0.08,
          child: cover,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.03,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titile!,
                style: songnamestyle,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Text(
                singer!,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
