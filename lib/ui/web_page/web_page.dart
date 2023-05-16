import 'package:flutter/material.dart';
import 'package:superpower/util/constants.dart';

class WebPage extends StatelessWidget {
  final Path path;
  final String title;
  const WebPage({Key? key, required this.path, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
    );
  }
}
