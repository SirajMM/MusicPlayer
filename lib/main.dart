import 'package:blaze_player/model/songmodel.dart';
import 'package:blaze_player/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/db_functions.dart';
import 'model/favoritemodel.dart';
import 'model/mostlyplayedmodel.dart';
import 'model/playlistmodel.dart';
import 'model/recentlyplayedmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Hive.initFlutter();
  Hive.registerAdapter(SongsAdapter());
  await Hive.openBox<Songs>('Songs');
  Hive.registerAdapter(FavSongsAdapter());
  openFavDb();
  Hive.registerAdapter(PlayListDbAdapter());
  openPlaylistDb();
  Hive.registerAdapter(RecentlyPlayedSongsAdapter());
  openRecentlyPlayed();
  Hive.registerAdapter(MostlyPlayedSongsAdapter());
  openMostlyBox();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
