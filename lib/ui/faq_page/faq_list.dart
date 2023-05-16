import 'package:flutter/material.dart';
import 'package:superpower/bloc/app/app_bloc/model/faq.dart';

class FaqList extends StatelessWidget {
  final List<FAQ> faqs;
  const FaqList(this.faqs, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
    );
  }
}