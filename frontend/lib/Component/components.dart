import 'package:flutter/material.dart';

class NormalText extends StatelessWidget {
  const NormalText({
    super.key,
    required this.text,
    required this.size,
    required this.color,
    this.textAlign,
  });

  final String text;
  final double size;
  final Color color;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: size, color: color),
      textAlign: (textAlign != null) ? textAlign : .start,
    );
  }
}

class BoldText extends StatelessWidget {
  const BoldText({
    super.key,
    required this.text,
    required this.size,
    required this.color,
    this.textAlign,
  });

  final String text;
  final double size;
  final Color color;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        color: color,
        fontWeight: FontWeight.bold,
      ),
      textAlign: (textAlign != null) ? textAlign : .start,
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.text,
    required this.textColor,
    required this.textSize,
    required this.buttonColor,
    required this.onPressed,
    this.buttonWidth,
    required this.borderColor,
  });

  final String text;
  final Color textColor;
  final double textSize;
  final Color buttonColor;
  final VoidCallback onPressed;
  final double? buttonWidth;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (buttonWidth != null) ? buttonWidth : double.infinity,

      child: FilledButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(buttonColor),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: borderColor),
            ),
          ),

          padding: WidgetStateProperty.all(EdgeInsets.all(10)),
        ),
        child: NormalText(text: text, size: textSize, color: textColor),
      ),
    );
  }
}
