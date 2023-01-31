import 'package:superpower/util/config.dart';
import 'package:flutter/material.dart';

class OptionWidget extends StatelessWidget {
  final Widget _icon;
  final String _text;
  final Color? _cardColor;
  double innerPadding;
  double widthRatio;

  OptionWidget(this._cardColor, this._icon, this._text,
      {this.innerPadding = 35, this.widthRatio = 1, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: SizedBox(
        width: (MediaQuery.of(context).size.width * widthRatio),
        child: Card(
          elevation: 7,
          color: _cardColor,
          shadowColor: const Color.fromARGB(255, 0, 0, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(innerPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _icon,
                  Text(
                    _text,
                    style: const TextStyle(
                        color: homeTextColor,
                        fontSize: homeTextSize,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
