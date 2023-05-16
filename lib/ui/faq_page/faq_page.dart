import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:superpower/bloc/app/app_bloc/app_bloc.dart';
import 'package:superpower/bloc/app/app_bloc/model/faq.dart';
import 'package:superpower/shared/widgets/page_loading.dart';
import 'package:superpower/ui/faq_page/faq_list.dart';
import 'package:superpower/util/app_state.dart';
import 'package:superpower/util/config.dart';
import 'package:superpower/util/logging.dart';
import 'package:superpower/util/strings.dart';
import 'package:superpower/util/util.dart';

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
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                  child: FaqList(faqs),
                ),
              ),
              const ContactUs()
            ],
          );
  }
}

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: '$AnyFurtherQuestions, ',
          style: Theme.of(context).textTheme.bodySmall,
          children: [
            TextSpan(
              recognizer: TapGestureRecognizer()..onTap = () => sendEmail(),
              text: ContactUsText,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
