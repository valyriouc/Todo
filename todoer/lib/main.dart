import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoer/viewmodels.dart';

void main() {
    runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => TodoViewModel(models: <TodoModel> [ TodoModel(title: "Hello world"), TodoModel(title: "Working on my goals")])),
        ChangeNotifierProvider(create: (_) => ThemeViewModel(model: ThemeModel()))
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
        return Consumer<ThemeViewModel>(builder: (tcontext, themeModel, other) {
          return Scaffold(
          appBar: AppBar(
            title: const Text("Your todos"),
            backgroundColor: themeModel.barColor,
            actions: [
              Switch(value: themeModel.currentTheme, onChanged: (value) => themeModel.changeTheme()),
            ],
          ),
          bottomNavigationBar: const TodoBottomBar(),
          backgroundColor: themeModel.mainColor,
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
                  Text(
                    viewModel.models[item].title, 
                    style: TextStyle(color: themeModel.textColor)
                  ),
                  TextButton(
                    style: ButtonStyle(textStyle: WidgetStatePropertyAll(TextStyle(color: themeModel.textColor))),
                    child: const Text("Edit"), 
                    onPressed: () => Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => const EditTodoView()))),
                  TextButton(
                    style: ButtonStyle(textStyle: WidgetStatePropertyAll(TextStyle(color: themeModel.textColor))),
                    child: const Text("Delete"),
                    onPressed: () => viewModel.deleteTodo(viewModel.models[item].id)
                  )
                ]);
              }
            )
        );
        });
      });
  }
}

class TodoBottomBar extends StatelessWidget {
  const TodoBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        child: const Text("Create"),
        onPressed: () => { Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateTodoView()))},
      );
  }

}

class CreateTodoView extends StatelessWidget {
  const CreateTodoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(
      builder: (context, themeModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Creating"),
            backgroundColor: themeModel.barColor,
          ),
          backgroundColor: themeModel.mainColor,
          body: Center(
            child: Text(
              "Coming soon...", 
              style: TextStyle(
                color: themeModel.textColor)))
        );
      }
    );
  }
}

class EditTodoView extends StatelessWidget {
  const EditTodoView({super.key});  
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(
      builder: (context, themeModel, child) {
         return Scaffold(
        appBar: AppBar(
          title: const Text("Editing"),
          backgroundColor: themeModel.barColor,
        ),
        backgroundColor: themeModel.mainColor,
        body: Row(
          children: [   
            SizedBox(
              height: 50, 
              width: 300, 
              child: TextField(
                autofocus: true,
                style: TextStyle(
                  color: themeModel.textColor,
                ),
                decoration: InputDecoration(
                  hintText: "Enter the title",
                  hintStyle: TextStyle(color: themeModel.textColor)
                ),
              )),
            TextButton(onPressed: () => { Navigator.push(context, MaterialPageRoute(builder: (context) => const TodoView()))}, child: const Text("Edit"))
          ]),
      );
      });
  }
} 