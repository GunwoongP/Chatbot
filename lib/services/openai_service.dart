import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAIService {
  static const endpoint =
      'https://api.openai.com/v1/chat/completions'; // Your endpoint
  final apiKey = dotenv.env['OPENAI_API_KEY'];
  Future<String> fetchResponse(String text) async {
    final response = await http.post(Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'model': 'ft:gpt-3.5-turbo-0613:personal::7zKU0WwJ',
          'messages': [
            {
              'role': 'system',
              'content': '당신은 청소년 불씨 운동(YSM)에 대해 친절하게 알려주는 정보전달자이자 상담사입니다.'
            },
            {'role': 'user', 'content': text}
          ]
        }));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse['choices'][0]['message']['content'];
    } else {
      print(response.body);
      throw Exception('Failed to load response from OpenAI');
    }
  }
}
