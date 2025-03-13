import 'package:cinemapedia/config/constants/envirovement.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

enum QuestionType { movie, tv, actor, voiceActorMovie, voiceActorTV }

class GeminiIA {
  static Future<GenerateContentResponse> askGeminiIA(QuestionType type, String topic) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: Envirovement.googleAIStudio,
      // generationConfig: GenerationConfig(maxOutputTokens: 200, temperature: 0.5, topP: 0.95, topK: 64, responseMimeType: "text/plain")
    );

    GenerateContentResponse? response;

    late String request;

    switch (type) {
      case QuestionType.movie:
        request =
            'Cuéntame cosas interesantes sobre la película $topic sin incluir spoilers. Estaría bien que añadieras también los premios que haya conseguido en caso de tenerlos. Responde directamente con los datos y divide la respuesta en párrafos sin viñetas.';
        break;
      case QuestionType.tv:
        request =
            'Cuéntame cosas interesantes sobre la serie de televisión $topic sin incluir spoilers. Estaría bien que añadieras también los premios que haya conseguido en caso de tenerlos. Responde directamente con los datos y divide la respuesta en párrafos sin viñetas.';
        break;
      case QuestionType.actor:
        request =
            'Cuéntame cosas interesantes sobre esta persona: $topic. Háblame de su trayectoria profesional. Estaría bien que añadieras también los premios que haya conseguido en caso de tenerlos. Responde directamente con los datos y divide la respuesta en párrafos sin viñetas.';
        break;
      case QuestionType.voiceActorMovie:
        request =
            'Necesito la lista de los actores de doblaje al Castellano (español de España) de la película $topic. Lo necesito en un JSON de la siguiente forma: {\'nombre del actor\': \'nombre del personaje\'}. Dame solamente el JSON';
        break;
      case QuestionType.voiceActorTV:
        request =
            'Necesito la lista de los actores de doblaje al Castellano (español de España) de la serie de televisón $topic. Lo necesito en un JSON de la siguiente forma: {\'nombre del actor\': \'nombre del personaje\'}. Dame solamente el JSON';
        break;
      default:
    }

    final content = [Content.text(request)];
    response = await model.generateContent(content);

    return response;
  }
}
