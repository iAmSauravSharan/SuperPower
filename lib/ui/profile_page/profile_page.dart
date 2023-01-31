import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superpower/bloc/theme/theme_bloc/theme_bloc.dart';
import 'package:superpower/bloc/theme/theme_constants.dart';
import 'package:superpower/bloc/theme/theme_manager.dart';
import 'package:superpower/data/preference_manager.dart';
import 'package:superpower/ui/web_page/web_page.dart';
import 'package:superpower/util/app_state.dart';
import 'package:superpower/util/config.dart';
import 'package:superpower/util/constants.dart';
import 'package:superpower/util/logging.dart';
import 'package:superpower/util/strings.dart';
import 'package:superpower/util/util.dart';

final log = Logging("Profile Page");

class ProfilePage extends StatelessWidget {
  static const routeName = '/profile';

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: const ProfileWidget(),
      ),
    );
  }
}

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  String themeValue = system;
  String name = 'Human';
  late ThemeManager themeManager = AppState.themeManager;

  @override
  void initState() {
    log.d('entering into initState()');
    retrieveUsername();
    PreferenceManager.readData(PrefConstant.themeMode).then((value) {
      log.d('in initState() got value from pref -> $value');
      if (value != null) {
        setState(() {
          if (value == ThemeMode.system.name) {
            themeValue = system;
          } else if (value == ThemeMode.light.name) {
            themeValue = light;
          } else {
            themeValue = dark;
          }
        });
      }
    });
    super.initState();
    log.d('init state done');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          loadProfileImage(size: 88),
          const SizedBox(height: 10),
          username(),
          const SizedBox(height: 20),
          rechargeCredit(),
          const SizedBox(height: 2),
          selectTheme(),
          const SizedBox(height: 2),
          rateApp(),
          const SizedBox(height: 2),
          shareApp(),
          const SizedBox(height: 2),
          feedback(),
          const SizedBox(height: 2),
          contactUs(),
          const SizedBox(height: 2),
          logout(),
          const SizedBox(height: 70),
          termsAndConditions(),
          const SizedBox(height: 20),
          versionInfo(),
        ],
      ),
    );
  }

  Widget username() {
    return Text(
      'Hi, $name 👋',
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget rechargeCredit() {
    return Focus(
      child: ListTile(
        title: const Text(
          'Credit points',
          style: Profile.tilesTitleStyle,
        ),
        leading: const Icon(
          Icons.attach_money_rounded,
        ),
        dense: Profile.isTilesDensed,
        subtitle: const Text('click to add credit points'),
        trailing: const Text(
          '10 credits',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () => showPointsBottomSheet(),
      ),
    );
  }

  Widget selectTheme() {
    log.i('setting up theme widget with current theme value of $themeValue');
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) => ListTile(
        leading: const Icon(
          Icons.wb_sunny_rounded,
        ),
        trailing: Focus(
          child: DropdownButton(
            elevation: 5,
            underline: null,
            value: themeValue,
            alignment: Alignment.center,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            items: themes.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: (value) {
              log.d('theme value chaged');
              setState(() {
                themeValue = value!;
                if (themeValue == light) {
                  themeManager.setLightMode();
                } else if (themeValue == dark) {
                  themeManager.setDarkMode();
                } else {
                  themeManager.setSystemMode();
                }
                BlocProvider.of<ThemeBloc>(context).add(
                  ThemeChanged(themeMode: themeManager.getTheme()),
                );
              });
            },
          ),
        ),
        subtitle: const Text('to change app color'),
        title: const Text(
          'Select app theme',
          style: Profile.tilesTitleStyle,
        ),
      ),
      //TODO: onTap: () =>  open drop-down,
    );
  }

  Widget rateApp() {
    final store = getStoreName();
    return Focus(
      child: ListTile(
        leading: const Icon(
          Icons.rate_review_rounded,
        ),
        trailing: const Icon(Icons.keyboard_arrow_right_rounded),
        subtitle: Text('on the $store'),
        title: const Text(
          'Rate app',
          style: Profile.tilesTitleStyle,
        ),
        onTap: () => openStore(),
      ),
    );
  }

  Widget shareApp() {
    return Focus(
      child: ListTile(
        leading: const Icon(
          Icons.share_rounded,
        ),
        trailing: const Icon(Icons.keyboard_arrow_right_rounded),
        subtitle: const Text('with your friends and family'),
        title: const Text(
          'Share app',
          style: Profile.tilesTitleStyle,
        ),
        onTap: () => share(),
      ),
    );
  }

  Widget feedback() {
    return Focus(
      child: ListTile(
        leading: const Icon(
          Icons.feedback_rounded,
        ),
        trailing: const Icon(Icons.keyboard_arrow_right_rounded),
        subtitle: const Text('about the changes you want to see'),
        title: const Text(
          'Provide feedback',
          style: Profile.tilesTitleStyle,
        ),
        onTap: () => sendEmail(),
      ),
    );
  }

  Widget contactUs() {
    return Focus(
      child: ListTile(
        leading: const Icon(
          Icons.support_agent_rounded,
        ),
        dense: Profile.isTilesDensed,
        trailing: const Icon(Icons.keyboard_arrow_right_rounded),
        subtitle: const Text('to share your queries'),
        title: const Text(
          'Contact Us',
          style: Profile.tilesTitleStyle,
        ),
        onTap: () => openStore(),
      ),
    );
  }

  Widget logout() {
    return Focus(
      child: ListTile(
        tileColor: Colors.red.shade100,
        leading: const Icon(
          Icons.logout_rounded,
          color: Colors.red,
        ),
        dense: Profile.isTilesDensed,
        title: const Text(
          'Log out',
          style: Profile.tilesTitleStyle,
        ),
        onTap: () => FirebaseAuth.instance
            .signOut()
            .whenComplete(() => Navigator.of(context).pop()),
      ),
    );
  }

  Widget termsAndConditions() {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: TERMS_AND_CONDITIONS_PREFIX,
          style: const TextStyle(
            fontSize: 14,
            color: Color.fromARGB(255, 160, 159, 159),
          ),
          children: [
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => launchWebPageFor(Path.terms_of_usage),
              text: TERMS_AND_CONDITIONS,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 14,
                color: Color.fromARGB(255, 100, 182, 236),
              ),
            ),
            const TextSpan(
              text: AND,
              style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 160, 159, 159),
              ),
            ),
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => launchWebPageFor(Path.privacy_policy),
              text: PRIVACY_POLICY,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 14,
                color: Color.fromARGB(255, 100, 182, 236),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget versionInfo() {
    return const Center(
      child: Text(
        'v$version',
        style: const TextStyle(
          fontSize: 11,
          color: Color.fromARGB(255, 177, 177, 177),
        ),
      ),
    );
  }

  void launchWebPageFor(Path path) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) => WebPage(path: path)),
      ),
    );
  }

  Future<void> retrieveUsername() async {
    String storedName = name;
    final pattern = RegExp('\\s+');
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    log.d('retrieveUsername userEmail is -> $userEmail');
    final collection = FirebaseFirestore.instance.collection('UserData');
    final querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      if (data['email'] == userEmail) {
        storedName = data['name'] ?? name;
        if (storedName.split(pattern).length > 1) {
          storedName = storedName.split(pattern)[0];
        }
        setState(() {
          name = storedName.isNotEmpty ? storedName : name;
        });
      }
    }
  }

  void sendEmail() {}

  void share() {}

  void openStore() {}

  void showPointsBottomSheet() {}
}
