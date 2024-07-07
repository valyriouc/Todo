import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoer/viewmodels.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
        create: (_) => TodoViewModel(models: <TodoModel>[
              TodoModel(title: "Hello world"),
              TodoModel(title: "Working on my goals")
            ])),
    ChangeNotifierProvider(create: (_) => ThemeViewModel(model: ThemeModel()))
  ], child: const MainApp()));
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
    return Consumer<TodoViewModel>(builder: (context, viewModel, test) {
      return Consumer<ThemeViewModel>(builder: (tcontext, themeModel, other) {
        return Scaffold(
            appBar: AppBar(
              title: const Text("Your todos"),
              backgroundColor: themeModel.barColor,
              actions: [
                Switch(
                    value: themeModel.currentTheme,
                    onChanged: (value) => themeModel.changeTheme()),
              ],
            ),
            bottomNavigationBar: const TodoBottomBar(),
            backgroundColor: themeModel.mainColor,
            body: ListView.builder(
                itemCount: viewModel.models.length,
                itemBuilder: (context, item) {
                  return Row(children: [
                    Flexible(
                        child: Checkbox(
                            onChanged: (value) =>
                                viewModel.editState(value ?? false, viewModel.models[item].id),
                            value: viewModel.models[item].isDone)),
                    Text(viewModel.models[item].title,
                        style: TextStyle(color: themeModel.textColor)),
                    TextButton(
                        style: ButtonStyle(
                            textStyle: WidgetStatePropertyAll(
                                TextStyle(color: themeModel.textColor))),
                        child: const Text("Edit"),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditTodoView(todo: viewModel.models[item], title: "Editing the todo")))),
                    TextButton(
                        style: ButtonStyle(
                            textStyle: WidgetStatePropertyAll(
                                TextStyle(color: themeModel.textColor))),
                        child: const Text("Delete"),
                        onPressed: () =>
                            viewModel.deleteTodo(viewModel.models[item].id))
                  ]);
                }));
      });
    });
  }
}

class TodoBottomBar extends StatelessWidget {
  const TodoBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CreateTodoView())),
        child: const Text("Create"));
  }
}

class CreateTodoView extends StatefulWidget {
  const CreateTodoView({super.key});

  @override
  State<StatefulWidget> createState() => CreateTodoState();
}

class CreateTodoState extends State<CreateTodoView> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(builder: (context, themeModel, child) {
      return Consumer<TodoViewModel>(
        builder: (context2, viewModel, test2) {
          return Scaffold(
              appBar: AppBar(
                title: const Text("Create a todo"),
                backgroundColor: themeModel.barColor,
              ),
              backgroundColor: themeModel.mainColor,
              body: Row(
                children: [
                  Flexible(
                      child: TextField(
                    style: TextStyle(color: themeModel.textColor),
                    controller: controller,
                  )),
                  TextButton(
                    onPressed: (() {
                      viewModel.addTodo(TodoModel(title: controller.text));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TodoView()));
                    }),
                    child: const Text("Create"),
                  )
                ],
              ));
        },
      );
    });
  }
}

class EditTodoView extends StatelessWidget {
  final String title;
  final TodoModel todo;

  final TextEditingController controller = TextEditingController();

  EditTodoView({super.key, required this.todo, this.title = "Editing"});

  @override
  Widget build(BuildContext context) {
    controller.text = todo.title;
    return Consumer<ThemeViewModel>(builder: (context, themeModel, child) {
      return Consumer<TodoViewModel>(builder: (context1, viewModel, child2) {
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            backgroundColor: themeModel.barColor,
          ),
          backgroundColor: themeModel.mainColor,
          body: Row(children: [
            SizedBox(
                height: 50,
                width: 300,
                child: TextField(
                  controller: controller,
                  autofocus: true,
                  style: TextStyle(
                    color: themeModel.textColor,
                  ),
                  decoration: InputDecoration(
                      hintText: "Enter the title",
                      hintStyle: TextStyle(color: themeModel.textColor)),
                )),
            TextButton(
                onPressed: () {
                      viewModel.editTitle(controller.text, todo.id);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TodoView()));
                    },
                child: const Text("Edit"))
          ]),
        );
      });
    });
  }
}
