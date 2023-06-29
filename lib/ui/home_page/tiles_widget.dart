import 'dart:ffi';

import 'package:flutter/material.dart';

class TilesWidget extends StatelessWidget {
  final String heading;
  final List<Tiles> tiles;
  const TilesWidget(this.heading, this.tiles, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          populateHeading(heading),
          populateListOptions(),
        ],
      ),
    );
  }

  Widget populateHeading(String heading) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Text(
        heading,
      ),
    );
  }

  Widget populateListOptions() {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              // ...
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            SizedBox(width: 8),
        itemCount: tiles.length,
      ),
    );
  }
}

class Tiles {
  final String name;
  final String imageUrl;
  final Long timeLeft;

  const Tiles(this.name, this.imageUrl, this.timeLeft);
}
