import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoer/viewmodels.dart';

void main() {
    runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => TodoViewModel(models: <TodoModel> [ TodoModel(title: "Hello world")])),
      ],
      child: const MainApp())
    );
} 

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Todoer',
      home: TodoView(),
    );
  }
}

class TodoView extends StatelessWidget {
  const TodoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoViewModel>(
      builder: (context, viewModel, test) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Your todos"),
          ),
          body: ListView.builder(
              itemCount: viewModel.models.length,
              itemBuilder: (context, item) {
                return Row(children: [
                  Flexible(
                    child: 
                    Checkbox(
                      onChanged: (value) => viewModel.editState(value ?? false, item), 
                      value: viewModel.models[item].isDone
                      )
                    ),
                  Text(viewModel.models[item].title),
                  TextButton(child: const Text("Edit"), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditTodoView())),)
                ]);
              }
            )
        );
      });
  }
}

class EditTodoView extends StatelessWidget {
  const EditTodoView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Row(
          children: [
            const Flexible(child: TextField()),
            TextButton(onPressed: () => { Navigator.push(context, MaterialPageRoute(builder: (context) => const TodoView()))}, child: const Text("Edit"))
          ]),
      )
    );
  }
} 