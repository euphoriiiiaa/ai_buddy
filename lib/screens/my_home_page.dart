
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_highlighting/themes/atom-one-dark.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:markdown_widget/markdown_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String apiKey = 'sk-ff6aa93c89f74573b6381b7c19494165';
  final TextEditingController _controller = TextEditingController();
  String modelForChat = 'deepseek-chat';
  String finalResponse = '';
  int count = 0;
  Future<void> getResponse() async {
    Dio dio = Dio();
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $apiKey'
    };
    String userMessage = _controller.text;
    var data = {
      "messages": [
        {"content": "asd", "role": "system"},
        {"content": userMessage, "role": "user"}
      ],
      "model": modelForChat,
      "frequency_penalty": 0,
      "max_tokens": 2048,
      "presence_penalty": 0,
      "stop": null,
      "stream": false,
      "temperature": 1,
      "top_p": 1
    };
    try {
      setState(() {
        isLoading = true;
      });
      log(userMessage);
      var response = await dio.post(
        'https://api.deepseek.com/v1/chat/completions',
        data: data,
      );
      log(response.data.toString()); // Используйте log из dart:developer
      //var jsonResponse = jsonDecode(response.data.toString());
      finalResponse = response.data['choices'][0]['message']['content'];
      log('Final: $finalResponse');
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      log(e.toString()); // Используйте log из dart:developer
    }
  }
  bool isLoading = false;
  bool light = false;
  bool isFabVisible = true;
  String model = 'Общение';
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        if (notification.direction == ScrollDirection.forward) {
          setState(() => isFabVisible = true);
        }
        else if (notification.direction == ScrollDirection.reverse) {
          setState(() => isFabVisible = false);
        }

        return true;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color.fromARGB(255, 18, 21, 37),
          appBar: AppBar(
            title: Text('AI Buddy', style: theme.textTheme.bodyMedium),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 18, 21, 37),
          ),
          body: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(38, 158, 158, 158),
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 10),
                        child: Text(
                          'Модель "$model"',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      TextField(
                        controller: _controller,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            focusColor: Colors.white,
                            hintText: 'Введите запрос',
                            focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0.5)),
                            hintStyle: theme.textTheme.bodySmall),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      getResponse();
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      _controller.clear();
                                    },
                              child: const Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Отправить',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.send,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Switch(
                                  inactiveTrackColor: Colors.white,
                                  value: light,
                                  activeColor: Colors.white,
                                  activeTrackColor:
                                      const Color.fromARGB(255, 18, 21, 37),
                                  inactiveThumbColor:
                                      const Color.fromARGB(255, 18, 21, 37),
                                  onChanged: (value) {
                                    isLoading
                                        ? null
                                        : setState(() {
                                            light = value;
                                            if (model == "Общение") {
                                              model = "Кодер";
                                              modelForChat = "deepseek-coder";
                                            } else {
                                              model = "Общение";
                                              modelForChat = "deepseek-chat";
                                            }
                                          });
                                  },
                                ),
                                const Text(
                                  'Модель "Кодер"',
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: AnimatedCrossFade(
                  firstChild: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 150),
                    child: Column(
                      children: [
                        SpinKitPouringHourGlass(
                          color: Colors.white,
                          size: 50,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Загрузка...',
                          style: TextStyle(fontSize: 14, color: Colors.white38),
                        ),
                      ],
                    ),
                  ),
                  secondChild: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                        child: MarkdownBlock(
                      data: finalResponse,
                      config: MarkdownConfig(
                        configs: [
                          PreConfig(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(24)),
                            theme: atomOneDarkTheme,
                          ),
                          CodeConfig(style: TextStyle(color: Colors.purple[200]))
                        ],
                      ),
                      selectable: true,
                    )),
                  ),
                  crossFadeState: isLoading
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: Durations.long3,
                ))
              ],
            ),
          ),
          floatingActionButton: isFabVisible ? FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/history_page', arguments: finalResponse);
              finalResponse = '';
            },
            backgroundColor: Colors.black,
            child: const Icon(
              Icons.history,
              color: Colors.white,
            ),
          ) : null
          ),
    );
  }
}