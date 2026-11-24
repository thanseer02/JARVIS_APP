import 'package:flutter/foundation.dart';
import 'package:genkit/genkit.dart';
import 'package:genkit_google_genai/genkit_google_genai.dart';


class JarvisAiService {
  late final Genkit _ai;

  JarvisAiService() {
    _ai = Genkit(plugins: [googleAI(apiKey: '')]);
  }

  Future<String> generateResponse(String userPrompt) async {
    try {
      final response = await _ai.generate(
        model: googleAI.gemini('gemini-flash-latest'),
        prompt:
            'You are JARVIS, a highly advanced, futuristic AI assistant. Respond helpfully and intelligently to the user: $userPrompt',
      );
      if (kDebugMode) {
        print('-----------------$response');
      }
      return response.text;
    } catch (e) {
      return 'Error connecting to JARVIS: $e';
    }
  }
}
