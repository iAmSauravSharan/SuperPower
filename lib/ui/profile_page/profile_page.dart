import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:superpower/bloc/auth/auth_bloc/authentication_bloc.dart';
import 'package:superpower/bloc/theme/theme_bloc/theme_bloc.dart';
import 'package:superpower/bloc/theme/theme_constants.dart';
import 'package:superpower/bloc/theme/theme_manager.dart';
import 'package:superpower/bloc/user/user_bloc/model/user.dart';
import 'package:superpower/bloc/user/user_bloc/model/user_preference.dart';
import 'package:superpower/bloc/user/user_bloc/user_bloc.dart';
import 'package:superpower/ui/faq_page/faq_page.dart';
import 'package:superpower/ui/feedback_page/feedback_page.dart';
import 'package:superpower/ui/home_page/home.dart';
import 'package:superpower/ui/settings_page/settings_page.dart';
import 'package:superpower/ui/web_page/web_page.dart';
import 'package:superpower/util/app_state.dart';
import 'package:superpower/util/config.dart';
import 'package:superpower/util/constants.dart';
import 'package:superpower/util/logging.dart';
import 'package:superpower/util/strings.dart';
import 'package:superpower/util/util.dart';
import 'package:url_launcher/url_launcher.dart';

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
  UserPreference _userPreference = UserPreference();
  late ThemeManager themeManager = AppState.themeManager;
  final _authentication = AppState.authenticationBloc;
  final _userRepository = AppState.userBloc;

  @override
  void initState() {
    log.d('entering into initState()');
    super.initState();
    retrieveUserPreference();
    retrieveUsername();
    log.d('init state done');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          loadProfileImage(size: 88),
          const SizedBox(height: 10),
          username(),
          const SizedBox(height: 20),
          rechargeCredit(),
          const SizedBox(height: 2),
          appSettings(),
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
          faqs(),
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
      style: Theme.of(context).textTheme.displayMedium,
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
        trailing: Text(
          '${_userPreference.getAvailableCredits()} credits',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () => showPointsBottomSheet(),
      ),
    );
  }

  Widget appSettings() {
    return Focus(
      child: ListTile(
        title: const Text(
          'App Settings',
          style: Profile.tilesTitleStyle,
        ),
        leading: const Icon(
          Icons.settings_suggest_rounded,
        ),
        dense: Profile.isTilesDensed,
        subtitle: const Text('update access keys, model and more'),
        trailing: const Icon(Icons.keyboard_arrow_right_rounded),
        onTap: () => {GoRouter.of(context).push(SettingPage.routeName)},
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
            value: _userPreference.getAppTheme(),
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
                _userPreference = UserPreference(
                    themeValue, _userPreference.getAvailableCredits());
                _userRepository
                    .loadUser(UpdateUserPreferenceEvent(_userPreference));
                setTheme(themeValue);
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
          Icons.star_half_rounded,
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
          Icons.rate_review_rounded,
        ),
        trailing: const Icon(Icons.keyboard_arrow_right_rounded),
        subtitle: const Text('changes you want to see'),
        title: const Text(
          'Provide feedback',
          style: Profile.tilesTitleStyle,
        ),
        onTap: () => {GoRouter.of(context).push(FeedbackPage.routeName)},
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
        subtitle: const Text('share your queries'),
        title: const Text(
          'Contact Us',
          style: Profile.tilesTitleStyle,
        ),
        onTap: () => sendEmail(),
      ),
    );
  }

  Widget faqs() {
    return Focus(
      child: ListTile(
        leading: const Icon(
          Icons.feedback_rounded,
        ),
        dense: Profile.isTilesDensed,
        trailing: const Icon(Icons.keyboard_arrow_right_rounded),
        subtitle: const Text('frequently asked questions'),
        title: const Text(
          FAQTitle,
          style: Profile.tilesTitleStyle,
        ),
        onTap: () => {GoRouter.of(context).push(FAQsPage.routeName)},
      ),
    );
  }

  Widget logout() {
    return Focus(
      child: ListTile(
        tileColor: const Color.fromARGB(255, 245, 57, 76),
        leading: const Icon(
          Icons.logout_rounded,
          color: Color.fromARGB(255, 252, 237, 236),
        ),
        dense: Profile.isTilesDensed,
        title: Text(
          'Log out',
          style: TextStyle(
            fontSize: 17,
            color: Theme.of(context).primaryColorLight,
          ),
        ),
        onTap: () => _authentication.authenticate(LogoutEvent()).whenComplete(
            () => GoRouter.of(context)
                .pop((route) => route.settings.name == HomePage.routeName)),
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
    _userRepository.loadUser(const GetUserEvent()).then((user) => {
          if ((user as User).getUsername().isNotEmpty)
            {
              setState(() => name = user.getUsername()),
            }
        });
  }

  Future<void> retrieveUserPreference() async {
    await _userRepository
        .loadUser(const GetUserPreferenceEvent())
        .then((user) => {
              if (user as UserPreference != null)
                {
                  setState(() => {
                        _userPreference = user,
                        themeValue = _userPreference.getAppTheme(),
                        setTheme(themeValue)
                      }),
                }
            });
  }

  void sendEmail() async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: developerMailId,
      queryParameters: {'subject': '', 'body': ''},
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // throw 'Could not launch $url';
    }
  }

  void share() {}

  void openStore() {
    switch (getDeviceType()) {
      case DeviceType.android:
        launch(googlePlayUrl);
        break;
      case DeviceType.macos:
      case DeviceType.ios:
        launch(appStoreUrl);
        break;
      case DeviceType.windows:
        launch(microsoftStoreUrl);
        break;
      case DeviceType.fuchsia:
      case DeviceType.web:
      case DeviceType.linux:
        launch(webStoreUrl);
        break;
    }
  }

  void launch(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      snackbar('Could not launch $url', isError: true);
    }
  }

  void showPointsBottomSheet() {}

  void setTheme(String themeValue) {
    if (themeValue == light) {
      themeManager.setLightMode();
    } else if (themeValue == dark) {
      themeManager.setDarkMode();
    } else {
      themeManager.setSystemMode();
    }
    BlocProvider.of<ThemeBloc>(context).add(
      ThemeChanged(
        themeMode: themeManager.getTheme(),
      ),
    );
  }
}
