import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

class ChatStyle {
  static const system = BubbleStyle(
    nip: BubbleNip.leftCenter,
    // color: Colors.white,
    // borderColor: Colors.blue,
    borderWidth: 0.1,
    elevation: 4,
    radius: Radius.circular(12.0),
    margin: BubbleEdges.only(top: 8, right: 50, bottom: 6),
    padding: BubbleEdges.fromLTRB(12.0, 10.0, 12.0, 10.0),
    alignment: Alignment.topLeft,
  );

  static const user = BubbleStyle(
    nip: BubbleNip.rightCenter,
    // color: Color.fromARGB(255, 225, 255, 199),
    // borderColor: Colors.blue,
    borderWidth: 0.1,
    elevation: 4,
    radius: Radius.circular(12.0),
    margin: BubbleEdges.only(top: 8, left: 50, bottom: 6),
    padding: BubbleEdges.fromLTRB(12.0, 10.0, 12.0, 10.0),
    alignment: Alignment.topRight,
  );

  static const userImage = BubbleStyle(
    nip: BubbleNip.rightCenter,
    color: Color.fromARGB(255, 225, 255, 199),
    borderColor: Colors.blue,
    borderWidth: 1,
    elevation: 4,
    margin: BubbleEdges.only(top: 4, left: 30),
    alignment: Alignment.topRight,
  );

  static const systemImage = BubbleStyle(
    nip: BubbleNip.rightCenter,
    color: Color.fromARGB(255, 225, 255, 199),
    borderColor: Colors.blue,
    borderWidth: 1,
    elevation: 4,
    margin: BubbleEdges.only(top: 4, left: 30),
    alignment: Alignment.topRight,
  );

  static const option = BubbleStyle(
    nip: BubbleNip.no,
    color: Color.fromARGB(255, 225, 255, 199),
    borderColor: Colors.blue,
    borderWidth: 0.1,
    elevation: 4,
    radius: Radius.circular(12.0),
    margin: BubbleEdges.only(top: 8, right: 8, bottom: 6),
    padding: BubbleEdges.fromLTRB(12.0, 10.0, 12.0, 10.0),
    alignment: Alignment.topRight,
  );

  static Bubble showBroadcast(String message) {
    return Bubble(
      margin: const BubbleEdges.only(top: 10),
      alignment: Alignment.center,
      nip: BubbleNip.no,
      color: const Color.fromRGBO(212, 234, 244, 1.0),
      child: Text(message,
          textAlign: TextAlign.center, style: const TextStyle(fontSize: 11.0)),
    );
  }

  static TextStyle forMessages() {
    return const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 19,
    );
  }
}
