import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:superpower/bloc/app/app_bloc/app_bloc.dart';
import 'package:superpower/bloc/app/app_bloc/model/faq.dart';
import 'package:superpower/shared/widgets/page_loading.dart';
import 'package:superpower/util/app_state.dart';
import 'package:superpower/util/config.dart';
import 'package:superpower/util/logging.dart';
import 'package:superpower/util/strings.dart';

final log = Logging('FAQsPage');

class FAQsPage extends StatelessWidget {
  const FAQsPage({super.key});

  static const routeName = '/faqs';

  @override
  Widget build(BuildContext context) {
    log.d('in build method');
    return Scaffold(
      appBar: AppBar(
        title: const Text(FAQTitle),
      ),
      body: const SafeArea(
        child: FAQWidget(),
      ),
    );
  }
}

class FAQWidget extends StatefulWidget {
  const FAQWidget({super.key});

  @override
  State<FAQWidget> createState() => _FAQWidgetState();
}

class _FAQWidgetState extends State<FAQWidget> {
  bool dataFetched = false;
  late final faqs = <FAQ>[];
  final _appBloc = AppState.appBloc;

  @override
  void initState() {
    super.initState();
    log.d('in init state');
    _appBloc
        .appEvent(const GetAppFAQEvent())
        .then((value) => {
              setState(() {
                faqs.clear();
                faqs.addAll((value as List<FAQ>));
                dataFetched = true;
              }),
            })
        .catchError((error) => {
              log.d('in error $error'),
              snackbar('Unknown Error Occured', isError: true),
              GoRouter.of(context).pop(),
            });
  }

  @override
  Widget build(BuildContext context) {
    return !dataFetched
        ? const PageLoading()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: faqs.length,
              itemBuilder: (context, index) {
                final faq = faqs[index];
                final question = faq.getTitle();
                final answer = faq.getContent();
                return ExpansionTile(
                  title: Text(
                    question,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        answer,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ],
                );
              },
            ),
          );
  }
}
