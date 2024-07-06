import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoer/viewmodels.dart';

class ThemeConfigurations {
  static Color barColor = const Color.fromARGB(255, 41, 153, 80);
  static Color mainTheme = const Color.fromARGB(255, 39, 39, 39);
  static Color textColor = const Color.fromARGB(255, 255, 255, 255);

  bool currentTheme = true; 

  static ThemeConfigurations? _instance;

  static ThemeConfigurations getInstance() {
    _instance ??= ThemeConfigurations._();
    return _instance!;
  }

  ThemeConfigurations._() : currentTheme = true;

  void changeTheme() {
    if (currentTheme) {
      currentTheme = false;
      mainTheme = const Color.fromARGB(255, 255, 255, 255);
      textColor = const Color.fromARGB(255, 0, 0, 0);
    } else {
      currentTheme = true;
      mainTheme = const Color.fromARGB(255, 39, 39, 39);
      textColor = const Color.fromARGB(255, 255, 255, 255);
    }
  }
}

void main() {
    runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => TodoViewModel(models: <TodoModel> [ TodoModel(title: "Hello world")])),
      ],
      child: const MainApp())
    );
} 

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  
  @override
  State<StatefulWidget> createState() => MainState();
}

class MainState extends State<MainApp> {

  final ThemeConfigurations theme = ThemeConfigurations.getInstance();

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
    MainState? main = context.findAncestorStateOfType<MainState>();
    return Consumer<TodoViewModel>(
      builder: (context, viewModel, test) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Your todos"),
            backgroundColor: ThemeConfigurations.barColor,
            actions: [
              Switch(value: main?.theme.currentTheme ?? true, onChanged: (value) => main?.theme.changeTheme())
            ],
          ),
          backgroundColor: ThemeConfigurations.mainTheme,
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
                    style: TextStyle(color: ThemeConfigurations.textColor)
                  ),
                  TextButton(
                    style: ButtonStyle(textStyle: WidgetStatePropertyAll(TextStyle(color: ThemeConfigurations.textColor))),
                    child: const Text("Edit"), 
                    onPressed: () => Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => const EditTodoView())),)
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
    return Scaffold(
        appBar: AppBar(
          title: const Text("Editing"),
          backgroundColor: ThemeConfigurations.barColor,
        ),
        backgroundColor: ThemeConfigurations.mainTheme,
        body: Row(
          children: [   
            SizedBox(
              height: 50, 
              width: 300, 
              child: TextField(
                autofocus: true,
                style: TextStyle(
                  color: ThemeConfigurations.textColor,
                ),
                decoration: InputDecoration(
                  hintText: "Enter the title",
                  hintStyle: TextStyle(color: ThemeConfigurations.textColor)
                ),
              )),
            TextButton(onPressed: () => { Navigator.push(context, MaterialPageRoute(builder: (context) => const TodoView()))}, child: const Text("Edit"))
          ]),
      );
  }
} 