// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hive_flutter/hive_flutter.dart';

Widget costemListTile({String? titile, String? singer, String? cover, onTap}) {
  bool isplaying = false;
  IconData playicon = Icons.play_arrow;
  var hiveBox = Hive.box('favorites');
  final isFavorite = hiveBox.get(titile) != null;
  return Container(
    padding: const EdgeInsets.all(8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              image: DecorationImage(
                  image: AssetImage(cover!), fit: BoxFit.cover)),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titile!,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(singer!),
            ],
          ),
        ),
        Builder(builder: (context) {
          return IconButton(
            color: Colors.red,
            onPressed: () async {
              ScaffoldMessenger.of(context).clearSnackBars();
              if (isFavorite) {
                await hiveBox.delete(titile);
                const snackBar = SnackBar(
                  content: Text('Removed from favorite'),
                );
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                await hiveBox.put(titile, cover);
                const snackBar = SnackBar(
                  content: Text('Added to favorite'),
                );
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              // await hiveBox.put(titile, cover);

              // ScaffoldMessenger.of(context).clearSnackBars();
            },
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
          );
        }),
       
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert),
        ),
      ],
    ),
  );
}
