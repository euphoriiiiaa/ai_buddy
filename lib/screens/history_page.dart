import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlighting/themes/atom-one-dark.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:lottie/lottie.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

bool getMessage = false;
int count = 0;
List<String> list = [];
List<String> listTime = [];

class _HistoryPageState extends State<HistoryPage> {
  String messageFromFirst = '';
  String lastMessage = '';
  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == '' || args == null) {
      setState(() {
        getMessage = false;
      });
    }
    messageFromFirst = args as String;
    log(messageFromFirst);
    if (messageFromFirst != '') {
      setState(() {
        list.insert(0, "Ответ от бота: ${DateTime.now()}\n\n$messageFromFirst");
        getMessage = true;
      });
    }
    for (int i = 0; i < list.length; i++) {
      log(list[i]);
    }
    log(getMessage.toString());
    //list.add("Ответ от ИИ: $messageFromFirst");
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light),
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'История запросов',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          backgroundColor: const Color.fromARGB(38, 158, 158, 158),
        ),
        backgroundColor: const Color.fromARGB(255, 18, 21, 37),
        body: getMessage
            ? Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: MarkdownBlock(
                                data: list[index],
                                config: MarkdownConfig(
                                  configs: [
                                    PreConfig(
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(24)),
                                      theme: atomOneDarkTheme,
                                    ),
                                    CodeConfig(
                                        style: TextStyle(
                                            color: Colors.purple[200])),
                                  ],
                                ),
                                selectable: true,
                              ),
                            );
                          }),
                    ),
                  )
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: 0.4,
                      child: Lottie.asset('assets/sleeping.json',
                          width: 200, height: 200),
                    ),
                    const Text(
                      'Здесь пусто.',
                      style: TextStyle(color: Colors.white38),
                    ),
                  ],
                ),
              ));
  }
}
