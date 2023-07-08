import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    required this.text,
    required this.animationController,
    required this.title,
     this.color,
    Key? key,
  }) : super(key: key);
  final String? text;
  final AnimationController animationController;
  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizeTransition(
      sizeFactor:
      CurvedAnimation(parent: animationController, curve: Curves.ease),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: color,
                    child: Text(
                      title[0],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 20)),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      text!,
                      style: textTheme.bodyText2?.copyWith(
                        color: Colors.black54,
                        height: 1.5,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}