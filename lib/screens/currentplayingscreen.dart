import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:blaze_player/screens/functions/addtofav.dart';
import 'package:blaze_player/widgets/utlities.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
// import 'package:palette_generator/palette_generator.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../model/songmodel.dart';
import '../styles/stile1.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

class CurrentPlayingScreen extends StatefulWidget {
  const CurrentPlayingScreen({super.key, required this.player});
  final AssetsAudioPlayer player;

  @override
  State<CurrentPlayingScreen> createState() => _CurrentPlayingScreenState();
}

class _CurrentPlayingScreenState extends State<CurrentPlayingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController =
      AnimationController(vsync: this, duration: const Duration(seconds: 6));

  // ValueNotifier<PaletteGenerator?> paletteGeneratorNotifier =
  //     ValueNotifier(null);
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isPlaying = true;

  final box = SongBox.getInstance();

  @override
  void initState() {
    widget.player.isPlaying.listen((event) {
      if (mounted) {
        setState(() {
          isPlaying = event;
        });
      }
    });

    widget.player.onReadyToPlay.listen((newDuration) {
      if (mounted) {
        setState(() {
          duration = newDuration?.duration ?? Duration.zero;
        });
      }
    });

    widget.player.currentPosition.listen((newPosition) {
      if (mounted) {
        setState(() {
          position = newPosition;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rheight = MediaQuery.of(context).size.height;
    final rwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () => getLyrics(context),
              icon: const Icon(
                Icons.lyrics_outlined,
                color: Colors.white,
              ))
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white60,
                    Colors.black.withOpacity(.7),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            height: rheight / 1.5,
            width: rwidth,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  Text(
                    widget.player.getCurrentAudioTitle,
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: rheight / 170,
                  ),
                  Text(
                    widget.player.getCurrentAudioArtist == '<unknown>'
                        ? 'Artist not found'
                        : widget.player.getCurrentAudioArtist,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                        overflow: TextOverflow.ellipsis),
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: rheight / 20,
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          durationFormat(position),
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const VerticalDivider(
                          color: Colors.white54,
                          thickness: 2,
                          width: 25,
                          indent: 2,
                          endIndent: 2,
                        ),
                        Text(
                          durationFormat(duration - position),
                          style: const TextStyle(color: Color(0xFFebbe8b)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          AvatarGlow(
            endRadius: 200,
            child: Center(
              child: SleekCircularSlider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                initialValue: position.inSeconds.toDouble(),
                onChange: (value) async {
                  await widget.player.seek(Duration(seconds: value.toInt()));
                },
                innerWidget: (percentage) {
                  return widget.player.builderCurrent(
                    builder: (context, playing) => Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(134, 99, 85, 85),
                          borderRadius: BorderRadius.all(Radius.circular(150)),
                        ),
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            if (!isPlaying) {
                              _animationController.stop();
                            } else {
                              _animationController.forward();
                              _animationController.repeat();
                            }
                            return Transform.rotate(
                              angle: _animationController.value * 2 * math.pi,
                              child: child,
                            );
                          },
                          child: QueryArtworkWidget(
                              size: 300,
                              quality: 100,
                              artworkBorder:
                                  const BorderRadius.all(Radius.circular(150)),
                              keepOldArtwork: true,
                              artworkFit: BoxFit.fill,
                              nullArtworkWidget: Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                          'asset/images/moosic.jpg')),
                                  color: Color.fromARGB(134, 99, 85, 85),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(150)),
                                ),
                              ),
                              id: int.parse(playing.audio.audio.metas.id!),
                              type: ArtworkType.AUDIO),
                        ),
                      ),
                    ),
                  );
                },
                appearance: CircularSliderAppearance(
                    size: 330,
                    angleRange: 300,
                    startAngle: 300,
                    customColors: CustomSliderColors(
                        progressBarColor: const Color(0xFFebbe8b),
                        dotColor: const Color(0xFFebbe8b),
                        trackColor: Colors.grey.withOpacity(.4)),
                    customWidths: CustomSliderWidths(
                        trackWidth: 6, handlerSize: 10, progressBarWidth: 6)),
              ),
            ),
          ),
          widget.player.builderCurrent(
            builder: (context, playing) => Positioned(
              top: rheight / 1.55,
              left: 25,
              right: 25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () => bottomSheet(context, playing.index),
                      icon: const Icon(
                        Icons.playlist_add,
                        color: Colors.white,
                      )),
                  IconButton(
                    icon: (checkFavourite(
                            int.parse(playing.audio.audio.metas.id!),
                            BuildContext))
                        ? const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.favorite,
                            color: buttoncolor,
                          ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      if (checkFavourite(
                          int.parse(playing.audio.audio.metas.id!),
                          BuildContext)) {
                        addToFavorite(int.parse(playing.audio.audio.metas.id!));

                        final snackBar = SnackBar(
                          backgroundColor: Colors.white,
                          content: Row(
                            children: [
                              const Text(
                                'Added to favorite ',
                                style: TextStyle(color: Colors.black),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.favorite,
                                color: buttoncolor,
                              )
                            ],
                          ),
                          dismissDirection: DismissDirection.down,
                          behavior: SnackBarBehavior.floating,
                          elevation: 30,
                          duration: const Duration(seconds: 1),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (!checkFavourite(
                          int.parse(playing.audio.audio.metas.id!),
                          BuildContext)) {
                        removeFav(int.parse(playing.audio.audio.metas.id!));
                        final snackBar = SnackBar(
                          backgroundColor: Colors.white,
                          content: Row(
                            children: const [
                              Text(
                                'Removed favorite ',
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.favorite_border_outlined,
                                color: Colors.black,
                              )
                            ],
                          ),
                          dismissDirection: DismissDirection.down,
                          behavior: SnackBarBehavior.floating,
                          elevation: 30,
                          duration: const Duration(seconds: 1),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      setState(() {
                        checkFavourite(int.parse(playing.audio.audio.metas.id!),
                                BuildContext) !=
                            checkFavourite(
                                int.parse(playing.audio.audio.metas.id!),
                                BuildContext);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: rheight / 1.3,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () async {
                        await widget.player.previous();
                      },
                      icon: const Icon(
                        Icons.skip_previous_rounded,
                        size: 50,
                        color: Colors.white,
                      )),
                  IconButton(
                    onPressed: () async {
                      await widget.player.playOrPause();
                    },
                    padding: EdgeInsets.zero,
                    icon: isPlaying
                        ? const Icon(
                            Icons.pause_circle,
                            size: 70,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.play_circle,
                            size: 70,
                            color: Colors.white,
                          ),
                  ),
                  IconButton(
                      onPressed: () async {
                        await widget.player.next();
                      },
                      icon: const Icon(
                        Icons.skip_next_rounded,
                        size: 50,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String durationFormat(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}
