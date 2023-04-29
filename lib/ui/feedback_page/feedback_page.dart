import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:superpower/bloc/app/app_bloc/app_bloc.dart';
import 'package:superpower/util/app_state.dart';
import 'package:superpower/util/config.dart';
import 'package:superpower/util/logging.dart';
import 'package:superpower/util/strings.dart';

final log = Logging('FeedbackPage');

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});
  static const routeName = '/feedback';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(FeedbackTitle),
      ),
      body: SafeArea(
        child: FeedbackWidget(),
      ),
    );
  }
}

class FeedbackWidget extends StatelessWidget {
  FeedbackWidget({super.key});

  final TextEditingController _controller = TextEditingController();
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const FeedbackHeading(),
          RatingBarWidget(onRatingChanged: (rating) {
            _rating = rating;
          }),
          FeedbackInputField(
            controller: _controller,
            onSubmitPressed: () {
              submitFeedback(_rating, _controller.text);
            },
          ),
          SubmitFeedback(onSubmitPressed: () {
            submitFeedback(_rating, _controller.text);
          }),
        ],
      ),
    );
  }
}

class FeedbackHeading extends StatelessWidget {
  const FeedbackHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 5, 24, 5),
      child: Center(
        child: Text(
          RateYourExperience,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class RatingBarWidget extends StatelessWidget {
  const RatingBarWidget({super.key, required this.onRatingChanged});

  final ValueChanged<double> onRatingChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 35, 4, 25),
      child: Center(
        child: RatingBar.builder(
          initialRating: 0,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return const Icon(Icons.sentiment_very_dissatisfied,
                    color: Colors.red);
              case 1:
                return const Icon(Icons.sentiment_dissatisfied,
                    color: Colors.yellow);
              case 2:
                return const Icon(Icons.sentiment_neutral, color: Colors.grey);
              case 3:
                return const Icon(Icons.sentiment_satisfied,
                    color: Colors.lightGreen);
              case 4:
                return const Icon(Icons.sentiment_very_satisfied,
                    color: Colors.green);
              default:
                return Container();
            }
          },
          onRatingUpdate: (rating) {
            onRatingChanged(
                rating); // notify the parent widget of the rating change
          },
          updateOnDrag: true,
        ),
      ),
    );
  }
}

class FeedbackInputField extends StatelessWidget {
  const FeedbackInputField(
      {super.key, required this.controller, required this.onSubmitPressed});

  final TextEditingController controller;
  final VoidCallback onSubmitPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 5, 24, 5),
      child: Container(
        constraints: const BoxConstraints(minWidth: 100, maxWidth: 550),
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.multiline,
          minLines: 5,
          maxLines: 20,
          decoration: const InputDecoration(
            hintText: EnterYourFeedback,
            contentPadding: EdgeInsets.all(15),
          ),
        ),
      ),
    );
  }
}

class SubmitFeedback extends StatelessWidget {
  const SubmitFeedback({super.key, required this.onSubmitPressed});

  final VoidCallback onSubmitPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 25, 24, 25),
      child: Container(
        constraints: const BoxConstraints(minWidth: 100, maxWidth: 520),
        child: ElevatedButton(
          onPressed: onSubmitPressed,
          child: const Text(Submit),
        ),
      ),
    );
  }
}

void submitFeedback(double rating, String feedbackText) {
  AppState.appBloc
      .appEvent(SubmitFeedbackEvent(rating, feedbackText))
      .then((value) => snackbar(FeedbackSubmittedSuccessfully, isInfo: true))
      .catchError((error) =>
          {log.e(error), snackbar(FeedbackSubmitionError, isError: true)});
}
