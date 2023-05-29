import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import '../../../styles/stile1.dart';
import '../../settings/aboutus.dart';
import '../../settings/privacy.dart';
import '../../settings/termsandconditions.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 207, 202, 202),
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Lottie.network(
                'https://assets10.lottiefiles.com/packages/lf20_eu5gscby.json',
              ),
              Positioned(
                top: -10,
                child: Text(
                  'Settings',
                  style: headingStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsAndConditions_Screen(),
                ));
          },
          leading: const Icon(Icons.privacy_tip_outlined),
          title: const Text('Terms & Conditions'),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
        ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicy(),
                ));
          },
          leading: const Icon(Icons.lock_outline),
          title: const Text('Privacy Policy'),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
        ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutUs(),
                ));
          },
          leading: const Icon(Icons.error_outline),
          title: const Text('About'),
        ),
        ListTile(
          onTap: () {
            Share.share(
                'https://play.google.com/store/apps/details?id=in.siraj.blaze_player',
                subject: 'Play Store Link');
          },
          leading: const Icon(Icons.share),
          title: const Text('Share'),
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);

            //  ==================== SHOW DIALOUGE ===============

            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Confirm Exit'),
                content: const Text('Do you want to exit app ?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: textcolor),
                    ),
                  ),
                  TextButton(
                    onPressed: () => SystemNavigator.pop(),
                    child: Text(
                      'Exit',
                      style: TextStyle(color: buttoncolor),
                    ),
                  ),
                ],
              ),
            );
          },
          leading: const Icon(Icons.logout_outlined),
          title: const Text('Quit'),
        ),
      ]),
    );
  }
}
