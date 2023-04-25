import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:superpower/shared/widgets/page_loading.dart';
import 'package:superpower/ui/chat_page/chat.dart';
import 'package:superpower/ui/home_page/option.dart';
import 'package:superpower/ui/profile_page/profile_page.dart';
import 'package:superpower/util/app_state.dart';
import 'package:superpower/util/config.dart';
import 'package:superpower/util/constants.dart';
import 'package:superpower/util/logging.dart';

final log = Logging('HomePage');

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDataFetched = true;
  final _repository = AppState.repository;

  @override
  void initState() {
    super.initState();
    _repository.isInitialAppLaunch().then((status) => {
          setState(() => {isDataFetched = !status, loadInitialData()})
        });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: isDataFetched ? const HomeWidget() : const PageLoading(),
      ),
    );
  }

  void loadInitialData() async {
    await _repository.loadInitialData();
    setState(() {
      isDataFetched = true;
    });
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
            context.go(ProfilePage.routeName),
            // Navigator.pushNamed(
            //   context,
            //   (isLoggedIn() ? ProfilePage.routeName : AuthPage.routeName),
            // ),
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
                  wordSpacing: 4,
                  letterSpacing: 2,
                ),
              ),
              TextSpan(
                  text: "Superpower⚡",
                  style: Theme.of(context).textTheme.displayLarge),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeGridWidget extends StatelessWidget {
  final _repository = AppState.repository;

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
        arguments: {'title': PathFor.qNAOption, 'color': ColorFor.qNAOption});
    final codeOption = registerHomePageOption(
      title: PathFor.codeOption,
      context: context,
      intention: Intention.code,
      color: ColorFor.codeOption,
      icon: IconFor.codeOption,
      divideBy: half,
      arguments: {'title': PathFor.codeOption, 'color': ColorFor.codeOption},
    );
    final translatorOption = registerHomePageOption(
      title: PathFor.translatorOption,
      context: context,
      intention: Intention.translator,
      color: ColorFor.translatorOption,
      icon: IconFor.translatorOption,
      arguments: {
        'title': PathFor.translatorOption,
        'color': ColorFor.translatorOption
      },
    );
    final chatOption = registerHomePageOption(
      title: PathFor.chatOption,
      context: context,
      intention: Intention.chat,
      color: ColorFor.chatOption,
      icon: IconFor.chatOption,
      divideBy: half,
      arguments: {'title': PathFor.chatOption, 'color': ColorFor.chatOption},
    );
    final imageOption = registerHomePageOption(
      title: PathFor.imageOption,
      context: context,
      intention: Intention.story,
      color: ColorFor.imageOption,
      icon: IconFor.imageOption,
      arguments: {'title': PathFor.imageOption, 'color': ColorFor.imageOption},
    );
    final storyOption = registerHomePageOption(
      title: PathFor.storyOption,
      context: context,
      intention: Intention.story,
      color: ColorFor.storyOption,
      icon: IconFor.storyOption,
      divideBy: half,
      arguments: {'title': PathFor.storyOption, 'color': ColorFor.storyOption},
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
    String routeName = ChatPage.routeName,
    required BuildContext context,
    required String title,
    required Intention intention,
    required Map<String, Object> arguments,
  }) {
    return InkWell(
      onTap: () {
        log.d("onTap - $arguments");
        GoRouter.of(context).go(
          ChatPage.routeName,
          // queryParams: {'title': arguments['title'] as String},
          extra: (arguments),
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
