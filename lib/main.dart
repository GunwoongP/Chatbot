import 'package:flutter/material.dart';
import 'widgets/chat_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final double step = 0.1;
  for (int i = 1; i < 10; i++) {
    strengths.add(i * step);
  }
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    final double level = strengths[i];
    swatch[(i * 100).toInt()] = Color.fromRGBO(
      r + ((255 - r) * level).round(),
      g + ((255 - g) * level).round(),
      b + ((255 - b) * level).round(),
      1,
    );
  }
  swatch[50] = color.withOpacity(.1);
  return MaterialColor(color.value, swatch);
}

void main() async {
  await dotenv.load();
  runApp(ChatBotApp());
}

final apiKey = dotenv.env['OPENAI_API_KEY'];
final primaryColor = createMaterialColor(Color.fromARGB(255, 107, 165, 212));

class ChatBotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatBot',
      theme: ThemeData(
        primarySwatch: primaryColor,
      ),
      home: ChatScreen(),
    );
  }
}
