import 'package:bubble/bubble.dart';
import 'package:superpower/ui/chat_page/chat_style.dart';
import 'package:superpower/data/data_repository.dart';
import 'package:superpower/main.dart';
import 'package:superpower/data/model/messages.dart';
import 'package:superpower/data/model/options.dart';
import 'package:superpower/util/app_state.dart';
import 'package:superpower/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatOptionsWidget extends StatefulWidget {
  const ChatOptionsWidget({super.key});

  @override
  State<ChatOptionsWidget> createState() => _ChatOptionsWidgetState();
}

class _ChatOptionsWidgetState extends State<ChatOptionsWidget> {
  final DataRepository? _repository = AppState.repository;

  List<Option> _options = [];

  @override
  void initState() {
    super.initState();
    getOptions();
  }

  void getOptions() async {
    var options = await _repository!.getOptions();
    setState(() {
      _options = options;
    });
  }

  List<Widget> createChildren() {
    List<Widget> children = [];
    for (int i = 0; i < _options.length; i++) {
      children.add(getBubble(_options[i].getOption()));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: createChildren(),
        ),
      ),
    );
  }

  Widget getBubble(String message) {
    return InkWell(
      onTap: () {
        _repository!.updateMessage(
          Messages("_from", "_to", "_timestamp", message, [], MessageType.user),
        );
      },
      child: Bubble(
        style: ChatStyle.option,
        child: Text(
          message,
          style: ChatStyle.forMessages(),
        ),
      ),
    );
  }
}
