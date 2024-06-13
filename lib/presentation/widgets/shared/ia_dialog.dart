import 'package:cinemapedia/config/helpers/gemini_ia.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

enum ShowType { movie, tv, actor }

class AskGeminiAboutIt extends StatefulWidget {
  final String topic;
  final QuestionType type;

  const AskGeminiAboutIt({super.key, required this.topic, required this.type});

  @override
  State<AskGeminiAboutIt> createState() => _AskGeminiAboutItState();
}

class _AskGeminiAboutItState extends State<AskGeminiAboutIt> {
  GenerateContentResponse? response;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
        width: 120,
        child: GestureDetector(
            onTap: () async {
              showIAdialog(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('assets/loaders/google-gemini-icon.png', height: 22),
                  const SizedBox(width: 5),
                  Text(
                    'Saber más...',
                    style: textStyle.titleMedium!.copyWith(color: colors.primary),
                  ),
                ],
              ),
            )));
  }

  Future<void> showIAdialog(BuildContext context) async {
    final textStyle = Theme.of(context).textTheme;
    // final colors = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false, // Evitar que se pueda cerrar al tocar fuera
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Image.asset('assets/loaders/google-gemini-icon.png', height: 30),
              const SizedBox(width: 5),
              Text('Gemini IA', style: textStyle.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          content: SizedBox(
            height: 160.0,
            width: 200.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.topic, maxLines: 2, style: textStyle.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10.0),
                const Center(
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    response = await GeminiIA.askGeminiIA(widget.type, widget.topic);

    //Actualizar el contenido del AlertDialog

    Navigator.of(context).pop(); // Cerrar el AlertDialog con el indicador
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Image.asset('assets/loaders/google-gemini-icon.png', height: 30),
              const SizedBox(width: 5),
              Text('Gemini IA', style: textStyle.titleLarge!.copyWith(fontWeight: FontWeight.bold), maxLines: 2),
            ],
          ),
          content: SizedBox(
              height: 300.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.topic, maxLines: 2, style: textStyle.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10.0),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Center(
                        child: Text(
                          response!.text!,
                          style: textStyle.bodyLarge,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cerrar',
                style: textStyle.titleMedium!,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}



// Future<void> showIAdialog(BuildContext context, TextTheme textStyle, String tittle, String response) {
//   return showDialog<void>(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Row(
//           children: [
//             Image.asset('assets/loaders/google-gemini-icon.png', height: 30),
//             const SizedBox(width: 5),
//             Text('Gemini IA', style: textStyle.titleLarge!.copyWith(fontWeight: FontWeight.bold), maxLines: 2),
//           ],
//         ),
//         content: SizedBox(
//             height: 300.0,
//             child: SingleChildScrollView(
//                 child: Text(
//               response,
//               style: textStyle.bodyLarge,
//               textAlign: TextAlign.justify,
//             ))),
//         actions: <Widget>[
//           TextButton(
//             child: Text(
//               'Cerrar',
//               style: textStyle.labelLarge!,
//             ),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
