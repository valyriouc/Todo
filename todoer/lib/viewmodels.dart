
import 'package:flutter/material.dart';

class TodoModel {
  bool _isDone;
  String _title;

  TodoModel({required String title, bool isDone=false})
    : _title = title,
    _isDone = isDone;

  String get title => _title;
  bool get isDone => _isDone;

  set title(String title) {
    _title = title;
  }

  set isDone(bool isDone) {
    _isDone = isDone;
  }
}

class TodoViewModel with ChangeNotifier {
  final List<TodoModel> _models;

  TodoViewModel({required List<TodoModel> models}) : _models = models;

  void addTodo(TodoModel model) {
    _models.add(model);
    notifyListeners();
  }

  void editState(bool state, int index) {
    _models[index].isDone = state;
    notifyListeners();
  }

  void editTitle(String title, int index) {
    _models[index].title = title;
    notifyListeners();
  }

  List<TodoModel> get models => _models;
}

class ThemeModel {

  static const Color barColor = Color.fromARGB(255, 41, 153, 80);
  static Color mainTheme = const Color.fromARGB(255, 39, 39, 39);
  static Color textColor = const Color.fromARGB(255, 255, 255, 255);

  bool currentTheme;
  
  ThemeModel() : currentTheme = false;
}

class ThemeViewModel with ChangeNotifier {

  final ThemeModel model;

  Color get barColor => ThemeModel.barColor;
  Color get mainColor => ThemeModel.mainTheme;
  Color get textColor => ThemeModel.textColor;

  bool get currentTheme => model.currentTheme;

  ThemeViewModel({required this.model}); 

  void changeTheme() {
    if (model.currentTheme) {
      model.currentTheme = false;
      ThemeModel.mainTheme = const Color.fromARGB(255, 255, 255, 255);
      ThemeModel.textColor = const Color.fromARGB(255, 0, 0, 0);
    } else {
      model.currentTheme = true;
      ThemeModel.mainTheme = const Color.fromARGB(255, 39, 39, 39);
      ThemeModel.textColor = const Color.fromARGB(255, 255, 255, 255);
    }
    notifyListeners();
  }
} 