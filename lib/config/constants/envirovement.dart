import 'package:flutter_dotenv/flutter_dotenv.dart';

class Envirovement {
  static String theMovieDBKey = dotenv.env['THE_MOVIEDB_KEY'] ?? 'No hay API KEY';
  static String googleAIStudio = dotenv.env['GOOGLE_AI_STUDIO'] ?? 'No hay API KEY';
}
