import 'package:flutter/material.dart';
import 'package:flutter_web/services/openai_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _chatLog = <Map<String, String>>[];
  final _openAiService = OpenAIService();

  void _sendMessage() async {
    final text = _controller.text;
    if (text.isNotEmpty) {
      var msgOut = '';
      try {
        final response = await _openAiService.fetchResponse(text);
        msgOut = response;
      } catch (error) {
        debugPrint("Error fetching response: $error");
      }

      setState(() async {
        _chatLog.add({'role': 'user', 'message': text});

        setState(() {
          _chatLog.add({'role': 'bot', 'message': msgOut});
        });

        _controller.clear();

        // _chatLog.add({'role': 'bot', 'message': '저는 YSM 상담사 입니다'});
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("YSMChatBot")),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB0BEC5), Color(0xFF4FC3F7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _chatLog.length,
                itemBuilder: (context, index) {
                  final entry = _chatLog[index];
                  final message = entry['message'] ?? '';
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: entry['role'] == 'user'
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: entry['role'] == 'user'
                                ? Colors.blue[100]
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Text(message),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        fillColor: Colors.white, // 채우기 색상을 하얗게 설정
                        filled: true, // 필요합니다. 이것을 설정하여 채우기 색상을 활성화합니다.
                        hintText: "Type a message",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onSubmitted: (text) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    // 이 IconButton을 다시 추가합니다.
                    icon: Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
