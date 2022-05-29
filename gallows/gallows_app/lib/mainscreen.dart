import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:russian_words/russian_words.dart';
import 'dart:math';
import 'dart:convert';

import 'model.dart';

class WindowScreen extends StatefulWidget {
  const WindowScreen({Key? key}) : super(key: key);

  @override
  State<WindowScreen> createState() => _WindowScreenState();
}

class _WindowScreenState extends State<WindowScreen> {
  final _model = Model();
  @override
  Widget build(BuildContext context) {
    return ModelProvider(
      child: _Body(),
      model: _model,
    );
  }
}

class _Body extends StatelessWidget {
  _Body({Key? key}) : super(key: key);

  late String word;
  late List<Padding> listrow;
  List<List<String>> abc = [
    ['а', 'б', 'в', 'г', 'д', 'е', 'ё', 'ж', 'з', 'и', 'й'],
    ['к', 'л', 'м', 'н', 'о', 'п', 'р', 'с', 'т', 'у', 'ф'],
    ['х', 'ц', 'ч', 'ш', 'щ', 'ъ', 'ы', 'ь', 'э', 'ю', 'я']
  ];
  late List<String> answer;
  late int count;

  @override
  Widget build(BuildContext context) {
    word = ModelProvider.read(context)!.model.randomword;
    listrow = ModelProvider.read(context)!.model.listrow;
    answer = ModelProvider.read(context)!.model.ans;
    count = ModelProvider.read(context)!.model.count;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              '$count попыток осталось',
              style: const TextStyle(fontSize: 30),
            ),
            Table(
                defaultColumnWidth: const FixedColumnWidth(30),
                children: List<TableRow>.generate(
                    3,
                    (index1) => TableRow(
                        children: List<Padding>.generate(
                            11,
                            (index2) => Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: GestureDetector(
                                      onTap: () {
                                        ModelProvider.read(context)!
                                            .model
                                            .incremet();
                                        List<String> tmp = word.split('');
                                        for (int i = 0; i < tmp.length; i++) {
                                          if (tmp[i] == abc[index1][index2]) {
                                            answer[i] = tmp[i];
                                            listrow =
                                                ModelProvider.watch(context)!
                                                    .model
                                                    .updatelist(
                                                        i, abc, index1, index2);
                                          }
                                        }
                                        if (ModelProvider.watch(context)!
                                            .model
                                            .chek(answer)) {
                                          ModelProvider.read(context)!
                                              .model
                                              .victory(context);
                                          ModelProvider.read(context)!
                                              .model
                                              .update();
                                        }
                                        if (ModelProvider.read(context)!
                                            .model
                                            .checkcount(count)) {
                                          ModelProvider.read(context)!
                                              .model
                                              .lose(context, word);
                                          ModelProvider.read(context)!
                                              .model
                                              .update();
                                        }
                                      },
                                      child: Center(
                                        child: Text(
                                          abc[index1][index2],
                                          style: const TextStyle(
                                              fontSize: 24,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    width: 40,
                                    height: 35,
                                  ),
                                ))))),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: listrow),
            )
          ],
        ),
      ),
    );
  }
}
