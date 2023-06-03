// ignore_for_file: avoid_unnecessary_containers, unnecessary_null_comparison, must_be_immutable
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:blaze_player/presentation/playlistsongs/playlistfullsongs.dart';
import 'package:blaze_player/styles/stile1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../application/playlist_provider/playlist_provider.dart';
import '../../db/functions/db_functions.dart';
import '../miniplayer/miniplayer.dart';

class MyLibrary extends StatelessWidget {
  MyLibrary({
    super.key,
  });

  final TextEditingController textcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PlalistProvider>(context, listen: false).viewAllPlaylists();
    });
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Playlist',
                  style: headingStyle,
                ),
              ),
              // ===========Play List==============
              Container(
                padding: const EdgeInsets.all(8),
                child: InkWell(
                  onTap: () async => showdialogebox(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: size.height * 0.085,
                        width: size.width * 0.18,
                        decoration: BoxDecoration(
                          color: buttoncolor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                                offset: const Offset(5, 5),
                                color: Colors.grey.withOpacity(.4)),
                          ],
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      SizedBox(
                        width: size.height * 0.02,
                      ),
                      Expanded(
                        child: Text(
                          'Create Playlist',
                          style: homeStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // ========= PLAYLIST =========

              Consumer<PlalistProvider>(builder: (context, value, child) {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: value.playlistsongdb.length,
                  itemBuilder: (context, index) => playList(
                      value.playlistsongdb[index].playlistname,
                      '${value.playlistsongdb[index].playlistsongs!.length} Songs',
                      'asset/images/pop.png',
                      index,
                      context),
                );
              })
            ],
          ),
        ),
      ),
      bottomSheet: MiniPlayer(),
    );
  }

  playList(
      String? title, String? subtitle, String? cover, int? index, context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlaylistSongs(
                  songindex: index!, playlistname: textcontroller.text),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: size.height * 0.085,
              width: size.width * 0.18,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5,
                        offset: const Offset(5, 5),
                        color: Colors.grey.withOpacity(.4))
                  ],
                  image: DecorationImage(
                      image: AssetImage(cover!), fit: BoxFit.cover),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
            ),
            SizedBox(
              width: size.width * 0.04,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title!,
                        style: homeStyle,
                      ),
                      Text(subtitle!),
                    ],
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          value: 1,
                          child: Row(
                            children: [
                              Icon(Icons.edit_note),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Edit name')
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 2,
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Delete')
                            ],
                          ),
                        ),
                      ];
                    },
                    onSelected: (value) async {
                      switch (value) {
                        case 1:
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Rename Playlist'),
                              content: TextFormField(
                                controller: textcontroller,
                                decoration: InputDecoration(
                                  labelText: 'Enter new name',
                                  border: const UnderlineInputBorder(),
                                  hintText: textcontroller.text,
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(color: buttoncolor),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (textcontroller.text.isEmpty ||
                                        textcontroller.text == null) {
                                      Navigator.pop(context);
                                      AnimatedSnackBar.material(
                                        'Name required',
                                        duration: const Duration(seconds: 1),
                                        type: AnimatedSnackBarType.error,
                                      ).show(context);
                                    } else {
                                      editeplaylist(
                                          index!, textcontroller.text);
                                      Navigator.pop(context, 'Create');
                                      textcontroller.clear();
                                    }
                                  },
                                  child: Text(
                                    'Rename',
                                    style: TextStyle(color: textcolor),
                                  ),
                                ),
                              ],
                            ),
                          );
                          break;
                        case 2:
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirm Delete'),
                              content:
                                  const Text('Are you sure want to delete ?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    deleteplaylist(index!);

                                    Navigator.pop(context, 'Delete');
                                    Provider.of<PlalistProvider>(context,
                                            listen: false)
                                        .viewAllPlaylists();
                                    const snackbar = SnackBar(
                                      content: Text('Playlist deleted '),
                                      dismissDirection: DismissDirection.down,
                                      behavior: SnackBarBehavior.floating,
                                      elevation: 30,
                                      duration: Duration(milliseconds: 500),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackbar);
                                  },
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: buttoncolor),
                                  ),
                                ),
                              ],
                            ),
                          );

                          break;
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showdialogebox(context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Create Playlist'),
        content: TextFormField(
          controller: textcontroller,
          validator: (value) {
            if (value?.trim().isEmpty ?? true) {
              return 'Please enter a name for the playlist';
            }
            return null;
          },
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Enter the name of the playlist',
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text(
              'Cancel',
              style: TextStyle(color: buttoncolor),
            ),
          ),
          TextButton(
            onPressed: () {
              if (textcontroller.text.isEmpty || textcontroller.text == null) {
                Navigator.pop(context);
                AnimatedSnackBar.material(
                  'Name required',
                  duration: const Duration(seconds: 1),
                  type: AnimatedSnackBarType.error,
                ).show(context);
              } else {
                createplaylist(textcontroller.text.trim(), context);
                Provider.of<PlalistProvider>(context, listen: false)
                    .viewAllPlaylists();

                Navigator.pop(context, 'Create');
                textcontroller.clear();
              }
            },
            child: Text(
              'Create',
              style: TextStyle(color: textcolor),
            ),
          ),
        ],
      ),
    );
  }
}
