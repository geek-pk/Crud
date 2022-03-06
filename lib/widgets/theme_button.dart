import 'package:crud/themes/colors.dart';
import 'package:flutter/material.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({
    Key? key,
    required this.title,
    this.onPress,
    required this.loader,
    this.width,
  }) : super(key: key);

  final String title;
  final dynamic onPress;
  final bool loader;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: 45,
        width: width ?? double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: colorPrimary, borderRadius: BorderRadius.circular(32)),
        child: loader == false
            ? Text(title,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: colorWhite))
            : const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 3)),
      ),
    );
  }
}
