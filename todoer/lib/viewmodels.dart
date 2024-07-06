
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
