import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class CustomReadMoreText extends StatelessWidget {
  final String text;
  final int trimLines;

  const CustomReadMoreText({super.key, required this.text, required this.trimLines});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return ReadMoreText(
      text,
      trimLines: trimLines,
      colorClickableText: colors.primary,
      trimMode: TrimMode.Line,
      style: textStyle.bodyMedium,
      trimCollapsedText: ' Mostrar  más >>',
      trimExpandedText: ' << Mostrar menos',
      // moreStyle: textStyle.bodySmall,
    );
  }
}
