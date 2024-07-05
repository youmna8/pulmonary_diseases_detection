import 'package:flutter/material.dart';

class SlidingText extends StatelessWidget {
  const SlidingText({
    super.key,
    required this.slidingAnimation,
  });

  final Animation<Offset> slidingAnimation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: slidingAnimation,
        builder: (context, _) {
          return SlideTransition(
            position: slidingAnimation,
            child: const Text(
              'Breathe',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Spirax-Regular'),
              textAlign: TextAlign.center,
            ),
          );
        });
  }
}
