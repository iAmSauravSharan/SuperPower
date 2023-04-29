import 'dart:async';

import 'package:superpower/data/model/messages.dart';
import 'package:superpower/data/remote.dart';
import 'package:superpower/data/model/options.dart';
import 'package:superpower/data/model/request.dart';
import 'package:superpower/util/constants.dart';
import 'package:superpower/util/logging.dart';

final log = Logging('Repository');

class Repository {
  late final StreamController _controller;
  static Repository? instance;
  String _intention = Intention.qna.name;

  Repository._() {
    log.d("initializing repository..");
    _controller = StreamController();
  }

  final List<Messages> _messages = [];
  final Remote _remote = Remote();

  StreamController getController() => _controller;

  Future<void> getGreetings() async {
    _messages.addAll(await _remote.getGreetings());
    _controller.sink.add(_messages);
  }

  Future<void> sendQuery(String query) async {
    _remote.withThis(_intention);
    _messages.addAll(await _remote.sendQuery(Request(query)));
    _controller.sink.add(_messages);
  }

  Future<List<Option>> getOptions() async {
    _remote.withThis(_intention);
    return await _remote.getOptions();
  }

  void updateMessage(Messages message) {
    sendQuery(message.getContent());
    _messages.add(message);
    _controller.sink.add(_messages);
  }

  void setIntention(String name) {
    _intention = name;
  }

  factory Repository() => instance ??= Repository._();
}
