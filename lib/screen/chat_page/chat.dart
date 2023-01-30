import 'dart:async';
import 'dart:ui';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:superpower/data/model/messages.dart';
import 'package:superpower/data/repository.dart';
import 'package:superpower/main.dart';
import 'package:superpower/screen/chat_page/chat_style.dart';
import 'package:superpower/screen/chat_page/options.dart';
import 'package:superpower/util/app_state.dart';
import 'package:superpower/util/constants.dart';

class ChatPage extends StatelessWidget {
  static const routeName = '/chat';

  final String title;
  final Color color;
  const ChatPage({
    required this.title, 
    required this.color,
    super.key
    });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            const Expanded(
              child: ConversationsWidget(),
            ),
            const ChatOptionsWidget(),
            ActionsWidget(
              buttonColor: color,
            ),
          ],
        ),
      ),
    );
  }
}

class ConversationsWidget extends StatefulWidget {
  const ConversationsWidget({super.key});

  @override
  State<ConversationsWidget> createState() => _ConversationsWidgetState();
}

class _ConversationsWidgetState extends State<ConversationsWidget> {
  final List<Messages> _messages = [];
  StreamSubscription? _subscription;
  final Repository _repository = AppState.getRespository()!;
  final ScrollController _scrollController = ScrollController();

  Future<void> getMessages() async {
    _subscription = _repository.getController().stream.listen((event) {
      setState(() {
        _messages.clear();
        _messages.addAll(event);
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
      });
    });
    await _repository.getGreetings();
  }

  @override
  void initState() {
    super.initState();
    getMessages();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _messages.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) => Bubble(
        style: getMessageStyle(_messages[index].getMessageType()),
        child: Text(
          _messages[index].getContent(),
          style: ChatStyle.forMessages(),
        ),
      ),
    );
  }

  BubbleStyle getMessageStyle(int messageType) {
    switch (messageType) {
      case Constants.system:
        return ChatStyle.system;

      case Constants.user:
        return ChatStyle.user;

      case Constants.userImage:
        return ChatStyle.userImage;

      case Constants.systemImage:
        return ChatStyle.systemImage;

      default:
        return ChatStyle.option;
    }
  }
}

class ActionsWidget extends StatelessWidget {
  String _enteredMessage = "";
  final Color buttonColor;
  final Repository _repository = AppState.getRespository()!;
  final _messageController = TextEditingController();

  ActionsWidget({required this.buttonColor, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        messageTextField(),
        sendMessageButton(buttonColor),
      ],
    );
  }

  Widget messageTextField() {
    return Expanded(
      child: TextField(
        controller: _messageController,
        style: ChatStyle.forMessages(),
        onChanged: (value) => {
          _enteredMessage = value,
        },
        decoration: const InputDecoration(
          alignLabelWithHint: true,
          hintText: "Enter Text",
          suffixIcon: Icon(
            Icons.attachment,
          ),
          contentPadding: EdgeInsets.only(left: 19.0, right: 15.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(27.0)),
          ),
        ),
      ),
    );
  }

  Widget sendMessageButton(Color buttonColor) {
    return RawMaterialButton(
      onPressed: () {
        if (_enteredMessage.isNotEmpty) {
          _repository.updateMessage(Messages("saurav", "system", "13-12-2012",
              _enteredMessage, [], Constants.user));
          clearEnteredMessage();
        }
      },
      elevation: 2.0,
      fillColor: buttonColor,
      padding: const EdgeInsets.all(15.0),
      shape: const CircleBorder(),
      child: const Center(
        child: Icon(
          size: 22.0,
          Icons.send,
          color: Colors.white,
        ),
      ),
    );
  }

  void clearEnteredMessage() {
    _messageController.clear();
  }
}
