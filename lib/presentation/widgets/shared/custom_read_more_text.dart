import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class CustomReadMoreText extends StatelessWidget {
  final String text;
  final int trimLines;
  final TextStyle? textStyle;

  const CustomReadMoreText({super.key, required this.text, required this.trimLines, this.textStyle});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyleFromContext = Theme.of(context).textTheme;

    return ReadMoreText(
      text,
      trimLines: trimLines,
      colorClickableText: colors.primary,
      trimMode: TrimMode.Line,
      style: (textStyle != null) ? textStyle : textStyleFromContext.bodyMedium,
      textAlign: TextAlign.justify,
      trimCollapsedText: ' Mostrar  más',
      trimExpandedText: ' Mostrar menos',

      // moreStyle: textStyle.bodySmall,
    );
  }
}
