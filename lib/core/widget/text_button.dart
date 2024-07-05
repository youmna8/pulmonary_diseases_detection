import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  const MyTextButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(context).textTheme.displaySmall!.copyWith(
            color: Colors.white, fontFamily: 'Spirax-Regular', fontSize: 23),
      ),
    );
  }
}
