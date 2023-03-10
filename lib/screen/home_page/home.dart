import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:superpower/screen/chat_page/chat.dart';
import 'package:superpower/data/repository.dart';
import 'package:superpower/screen/home_page/option.dart';
import 'package:superpower/main.dart';
import 'package:superpower/screen/profile_page/profile_page.dart';
import 'package:superpower/util/app_state.dart';
import 'package:superpower/util/config.dart';
import 'package:superpower/util/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: const HomeWidget(),
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              getHeading(),
              getProfileImage(context),
            ],
          ),
          Expanded(child: HomeGridWidget()),
        ],
      ),
    );
  }

  Widget getProfileImage(BuildContext context) {
    return Focus(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 12, 21, 2),
        child: InkWell(
          child: loadProfileImage(),
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            ),
          },
        ),
      ),
    );
  }

  Widget getHeading() {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(8, 25, 1, 5),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Choose your \n',
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 21.0,
                ),
              ),
              const TextSpan(
                text: "Superpower???",
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeGridWidget extends StatelessWidget {
  final Repository? _repository = AppState.getRespository();

  HomeGridWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        reverse: false,
        padding: const EdgeInsets.all(2.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: populateChildren(context),
        ),
      );
    });
  }

  List<Widget> populateChildren(BuildContext context) {
    const double half = 0.45;
    List<Widget> children = [];
    final QnAOption = registerHomePageOption(
      title: PathFor.qNAOption,
      context: context,
      intention: Intention.qna,
      color: ColorFor.qNAOption,
      icon: IconFor.qNAOption,
      divideBy: half,
      pageRoute: MaterialPageRoute(
        builder: (context) => const Chat(PathFor.qNAOption, ColorFor.qNAOption),
      ),
    );
    final codeOption = registerHomePageOption(
      title: PathFor.codeOption,
      context: context,
      intention: Intention.code,
      color: ColorFor.codeOption,
      icon: IconFor.codeOption,
      divideBy: half,
      pageRoute: MaterialPageRoute(
        builder: (context) =>
            const Chat(PathFor.codeOption, ColorFor.codeOption),
      ),
    );
    final translatorOption = registerHomePageOption(
      title: PathFor.translatorOption,
      context: context,
      intention: Intention.translator,
      color: ColorFor.translatorOption,
      icon: IconFor.translatorOption,
      pageRoute: MaterialPageRoute(
        builder: (context) =>
            const Chat(PathFor.translatorOption, ColorFor.translatorOption),
      ),
    );
    final chatOption = registerHomePageOption(
      title: PathFor.chatOption,
      context: context,
      intention: Intention.chat,
      color: ColorFor.chatOption,
      icon: IconFor.chatOption,
      divideBy: half,
      pageRoute: MaterialPageRoute(
        builder: (context) =>
            const Chat(PathFor.chatOption, ColorFor.chatOption),
      ),
    );
    final imageOption = registerHomePageOption(
      title: PathFor.imageOption,
      context: context,
      intention: Intention.story,
      color: ColorFor.imageOption,
      icon: IconFor.imageOption,
      pageRoute: MaterialPageRoute(
        builder: (context) =>
            const Chat(PathFor.imageOption, ColorFor.imageOption),
      ),
    );
    final storyOption = registerHomePageOption(
      title: PathFor.storyOption,
      context: context,
      intention: Intention.story,
      color: ColorFor.storyOption,
      icon: IconFor.storyOption,
      divideBy: half,
      pageRoute: MaterialPageRoute(
        builder: (context) =>
            const Chat(PathFor.storyOption, ColorFor.storyOption),
      ),
    );
    final topRow = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        QnAOption,
        codeOption,
      ],
    );
    children.add(topRow);
    children.add(translatorOption);
    final bottomRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: [
        storyOption,
        chatOption,
      ],
    );
    children.add(bottomRow);
    children.add(imageOption);
    return children;
  }

  Widget registerHomePageOption({
    double divideBy = 1,
    Color color = Colors.lightBlue,
    IconData icon = Icons.abc_rounded,
    double iconSize = homeIconSize,
    Color iconColor = homeIconColor,
    double innerPadding = 35,
    required BuildContext context,
    required String title,
    required Intention intention,
    required MaterialPageRoute pageRoute,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          pageRoute,
        );
        _repository!.setIntention(intention.name);
      },
      child: OptionWidget(
        color,
        Icon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
        title,
        innerPadding: innerPadding,
        widthRatio: divideBy,
      ),
    );
  }
}
