import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:russian_words/russian_words.dart';
import 'dart:math';
import 'package:collection/collection.dart';

class Model extends ChangeNotifier {
  String randomword = '';
  List<Padding> listrow = [];
  List<String> ans = [];
  int count = 10;

  Model() {
    randomword = _getRandomWord();
    listrow = _generate();
    ans = _generateans();
  }

  void incremet() {
    count -= 1;
    notifyListeners();
  }

  String _getRandomWord() {
    var word = nouns[Random().nextInt(13571)];
    while (word.length > 8) {
      word = nouns[Random().nextInt(13571)];
    }
    return word.toLowerCase();
  }

  List<String> _generateans() =>
      List<String>.generate(randomword.length, (index) => '');

  List<Padding> _generate() {
    return List<Padding>.generate(
        randomword.length,
        (index) => Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                width: 30,
                height: 30,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
              ),
            ));
  }

  void update() {
    randomword = _getRandomWord();
    listrow = _generate();
    ans = _generateans();
    count = 10;
    notifyListeners();
  }

  List<Padding> updatelist(ind, List<List<String>> dict, ind2, ind3) {
    listrow[ind] = Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        width: 30,
        height: 30,
        child: Center(
            child: Text(
          dict[ind2][ind3],
          style: const TextStyle(fontSize: 24),
        )),
      ),
    );
    notifyListeners();
    return listrow;
  }

  bool chek(List<String> ans) {
    var tmp = randomword.split('');
    if (listEquals(tmp, ans)) {
      return true;
    }
    return false;
  }

  bool checkcount(int count) {
    return count <= 1 ? true : false;
  }

  Future<void> victory(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Вы выйграли!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Играть еще'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> lose(BuildContext context, String word) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Вы проиграли('),
          content: Text('Вы пытлась отгадать слово $word'),
          actions: <Widget>[
            TextButton(
              child: const Text('Попробовать еще'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ModelProvider extends InheritedNotifier {
  final Model model;
  ModelProvider({Key? key, required this.child, required this.model})
      : super(key: key, child: child, notifier: model);

  final Widget child;

  static ModelProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ModelProvider>();
  }

  static ModelProvider? read(BuildContext context) {
    final wid = context
        .getElementForInheritedWidgetOfExactType<ModelProvider>()
        ?.widget;
    return wid is ModelProvider ? wid : null;
  }

  @override
  bool updateShouldNotify(ModelProvider oldWidget) {
    return false;
  }
}
