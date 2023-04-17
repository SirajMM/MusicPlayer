import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:blaze_player/screens/home_screen.dart';
import 'package:blaze_player/screens/currentplayingscreen.dart';
import 'package:flutter/cupertino.dart';
// import 'package:blaze_player/styles/stile1.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:text_scroll/text_scroll.dart';

import '../styles/stile1.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});
  static int? index = 0;
  // static ValueNotifier<int> enteredvalue = ValueNotifier<int>(index!);

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  @override
  Widget build(BuildContext context) {
    var rheight = MediaQuery.of(context).size.height;
    return audioPlayer1.builderCurrent(
      builder: (context, playing) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (context) =>
                    CurrentPlayingScreen(player: audioPlayer1),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      // Colors.transparent,
                      // Color.fromARGB(255, 102, 3, 44),
                      Colors.black.withOpacity(.6),
                      Colors.white60,
                    ],
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              height: rheight * 0.08,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: rheight * 0.01,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: .5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: QueryArtworkWidget(
                          artworkHeight: rheight * 0.05,
                          artworkWidth: rheight * 0.05,
                          artworkFit: BoxFit.fill,
                          artworkBorder:
                              const BorderRadius.all(Radius.circular(10)),
                          id: int.parse(playing.audio.audio.metas.id!),
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: Container(
                            height: rheight * 0.05,
                            width: rheight * 0.05,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage('asset/images/moosic.jpg'),
                                )),
                          ),
                        ),
                      ),
                      SizedBox(width: rheight * 0.01),
                      SizedBox(
                        width: rheight * 0.18,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextScroll(
                              audioPlayer1.getCurrentAudioTitle,
                              style: songnamestyle,
                            ),
                            TextScroll(
                              audioPlayer1.getCurrentAudioArtist == "<unknown>"
                                  ? 'Artist Not Found'
                                  : audioPlayer1.getCurrentAudioArtist,
                            ),
                          ],
                        ),
                      ),
                      PlayerBuilder.isPlaying(
                        player: audioPlayer1,
                        builder: (context, isPlaying) => Wrap(children: [
                          IconButton(
                              onPressed: () {
                                audioPlayer1.previous();
                              },
                              icon: const Icon(Icons.skip_previous)),
                          IconButton(
                              onPressed: () {
                                audioPlayer1.playOrPause();
                                setState(() {
                                  isPlaying != isPlaying;
                                });
                              },
                              icon: Icon((isPlaying)
                                  ? Icons.pause
                                  : Icons.play_arrow)),
                          IconButton(
                              onPressed: () {
                                audioPlayer1.next();
                              },
                              icon: const Icon(Icons.skip_next)),
                        ]),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: rheight * 0.01,
                  ),
                  PlayerBuilder.realtimePlayingInfos(
                    player: audioPlayer1,
                    builder: (context, realtimePlayingInfos) {
                      duration = realtimePlayingInfos.current!.audio.duration;
                      position = realtimePlayingInfos.currentPosition;
                      return Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ProgressBar(
                          timeLabelLocation: TimeLabelLocation.none,
                          baseBarColor: Colors.grey.withOpacity(.2),
                          progressBarColor: Colors.black.withOpacity(.6),
                          thumbRadius: 0,
                          progress: position,
                          total: duration,
                          onSeek: (duration) async {
                            await audioPlayer1.seek(duration);
                          },
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
