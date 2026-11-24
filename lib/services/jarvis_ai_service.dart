import 'package:genkit/genkit.dart';
import 'package:genkit_google_genai/genkit_google_genai.dart';
import '../app_config.dart';

class JarvisAiService {
  final Genkit _ai;

  JarvisAiService()
      : _ai = Genkit(
          plugins: [
            geminiApiKey.isNotEmpty ? googleAI(apiKey: geminiApiKey) : googleAI(),
          ],
        );

  Future<String> generateResponse(String userPrompt) async {
    try {
      final response = await _ai.generate(
        model: googleAI.gemini('gemini-flash-latest'),
        prompt: userPrompt,
      );
      return response.text;
    } catch (e) {
      return 'Error connecting to JARVIS: $e';
    }
  }
}
