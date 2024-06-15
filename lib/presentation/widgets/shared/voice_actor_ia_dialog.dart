import 'dart:convert';

import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/widgets/shared/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:cinemapedia/config/helpers/gemini_ia.dart';

class AskGeminiAboutVoiceActors extends StatefulWidget {
  final String topic;
  final QuestionType type;

  const AskGeminiAboutVoiceActors({super.key, required this.topic, required this.type});

  @override
  State<AskGeminiAboutVoiceActors> createState() => _AskGeminiAboutVoiceActorsState();
}

class _AskGeminiAboutVoiceActorsState extends State<AskGeminiAboutVoiceActors> {
  GenerateContentResponse? response;
  String jsonString = '';
  List<Actor> voiceActors = [];

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
        width: 250,
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
                  Image.asset('assets/loaders/google-gemini-icon.png', height: 25),
                  const SizedBox(width: 5),
                  Text(
                    'Reparto de doblaje',
                    style: textStyle.titleLarge!.copyWith(color: colors.primary),
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

    // Extraer el JSON del String
    jsonString = response!.text!.substring(response!.text!.indexOf('{'), response!.text!.lastIndexOf('}') + 1);

    if (jsonString != '') {
      try {
        // Convertir el JSON en una List de Actor
        Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        jsonMap.forEach((key, value) {
          voiceActors.add(Actor(name: key, character: value, id: 0, profilePath: ''));
        });
      } on Exception {
        Navigator.of(context).pop();
        showErrorToast(context, "Reparto de doblaje no encontrado");
      }

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
                    Text('${widget.topic} - Reparto de doblaje', maxLines: 2, style: textStyle.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10.0),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                            children: voiceActors
                                .map((voiceActor) => Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          voiceActor.name,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                          voiceActor.character!,
                                          style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, overflow: TextOverflow.ellipsis),
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ))
                                .toList()),
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
    } else {
      Navigator.of(context).pop();
      showErrorToast(context, "Reparto de doblaje no encontrado");
    }
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
