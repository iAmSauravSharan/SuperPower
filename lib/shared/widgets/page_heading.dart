import 'package:flutter/material.dart';

class PageHeading extends StatelessWidget {
  final String heading;
  const PageHeading({required this.heading, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Text(
        heading,
        style: Theme.of(context).textTheme.displayMedium,
      ),
    );
  }
}
