import 'package:blaze_player/application/homeprovider/home_provider.dart';
import 'package:blaze_player/application/splash_provider/splash_provider.dart';
import 'package:blaze_player/presentation/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'application/playlist_all_songs_provider/playlist_all_songs.dart';
import 'application/playlist_provider/playlist_provider.dart';
import 'db/functions/db_functions.dart';
import 'db/model/favoritemodel.dart';
import 'db/model/mostlyplayedmodel.dart';
import 'db/model/playlistmodel.dart';
import 'db/model/recentlyplayedmodel.dart';
import 'db/model/songmodel.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SplashProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => PlalistProvider()),
        ChangeNotifierProvider(create: (context) => PlayListSongsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
              foregroundColor: Colors.black, backgroundColor: Colors.white),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
