import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAIService {
  final String _apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';

  Future<String> getAssistantResponse(String userInput) async {
    const url = 'https://api.openai.com/v1/chat/completions';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    };

    final body = jsonEncode({
      "model": "gpt-3.5-turbo",
      "messages": [
        {
          "role": "system",
          "content": "You are a helpful assistant that helps users break tasks into smaller steps."
        },
        {
          "role": "user",
          "content": userInput
        }
      ],
    });

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        print('❌ OpenAI API error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to get response from OpenAI');
      }
    } catch (e) {
      print('❌ Exception during OpenAI call: $e');
      throw Exception('An error occurred: $e');
    }
  }
}
