import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:superpower/bloc/payment/payment_bloc/model/payment.dart';
import 'package:superpower/bloc/payment/payment_bloc/payment_bloc.dart';
import 'package:superpower/shared/widgets/page_loading.dart';
import 'package:superpower/util/app_state.dart';
import 'package:superpower/util/config.dart';
import 'package:superpower/util/logging.dart';
import 'package:superpower/util/strings.dart';

final log = Logging('PaymentPage');

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  static const routeName = '/payment';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(PaymentTitle),
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: const PaymentWidget(),
        ),
      ),
    );
  }
}

class PaymentWidget extends StatefulWidget {
  const PaymentWidget({super.key});

  @override
  State<PaymentWidget> createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  bool dataFetched = false;
  late final Payment payment;
  final _appBloc = AppState.paymentBloc;
  int selectedSubcriptionOption = 0;

  @override
  void initState() {
    super.initState();
    _appBloc
        .appEvent(const GetPaymentDataEvent())
        .then((value) => {
              setState(() {
                payment = value as Payment;
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
        : Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Column(children: [
                heading(),
                subHeading(),
                paymentTabBar(),
                subscriptionDetails(),
                // FaqList(faqs),
                subscribeButton(),
              ]),
            ),
          );
  }

  Widget paymentTabBar() {
    Map<int, Widget> options = payment.getSubscriptions().asMap().map(
        (index, subscription) => MapEntry(index + 1, Text(subscription.name)));
    log.d(options.toString());
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 45, 5, 25),
      child: CustomSlidingSegmentedControl<int>(
        initialValue: 1,
        isStretch: true,
        children: options,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(8),
        ),
        thumbDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.3),
              blurRadius: 4.0,
              spreadRadius: 4.0,
              offset: const Offset(
                0.0,
                2.0,
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInToLinear,
        onValueChanged: (v) {
          setState(() {
            selectedSubcriptionOption = v - 1;
          });
        },
      ),
    );
  }

  Widget subscribeButton() {
    return Focus(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
        child: ElevatedButton(
          onPressed: () => launchPaymentOptions(),
          child: const Text(
            Subscribe,
          ),
        ),
      ),
    );
  }

  void launchPaymentOptions() {}

  Widget heading() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
      child: Text(
        'Unlock all features',
        style: Theme.of(context).textTheme.displayLarge,
      ),
    );
  }

  Widget subHeading() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 2, 5, 5),
      child: Text(
        'get daily updates, crafted for you',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget subscriptionDetails() {
    final subscription = payment.getSubscriptions()[selectedSubcriptionOption];
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          if (subscription.refererText.isNotEmpty)
            Text(
              subscription.refererText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 17, color: Colors.green, fontFamily: 'NotoSerif'),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 25, 25, 25),
            child: Card(
              elevation: 4,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: subscription.benefits.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: const Icon(
                      Icons.check_rounded,
                      color: Colors.green,
                    ),
                    title: Text(subscription.benefits[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
