// // mvvm_example.dart
// import 'package:flutter/material.dart';

// // Model
// class UserModel {
//   String _name;
//   int _age;

//   UserModel({required String name, required int age}) {
//     _name = name;
//     _age = age;
//   }

//   String get name => _name;
//   int get age => _age;
// }

// // ViewModel
// class UserViewModel with ChangeNotifier {
//   final UserModel _userModel;

//   UserViewModel({required UserModel userModel}) : _userModel = userModel;

//   String get name => _userModel.name;
//   int get age => _userModel.age;

//   void updateName(String newName) {
//     _userModel.name = newName;
//     notifyListeners();
//   }

//   void updateAge(int newAge) {
//     _userModel.age = newAge;
//     notifyListeners();
//   }
// }

// // View
// class UserView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<UserViewModel>(
//       builder: (context, viewModel, child) {
//         return Scaffold(
//           appBar: AppBar(
//             title: Text('User Profile'),
//           ),
//           body: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Text('Name: ${viewModel.name}'),
//                 Text('Age: ${viewModel.age}'),
//                 ElevatedButton(
//                   child: Text('Update Name'),
//                   onPressed: () {
//                     viewModel.updateName('Jane Doe');
//                   },
//                 ),
//                 ElevatedButton(
//                   child: Text('Update Age'),
//                   onPressed: () {
//                     viewModel.updateAge(31);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => UserViewModel(userModel: UserModel(name: 'John Doe', age: 30))),
//       ],
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'MVVM Example',
//       home: UserView(),
//     );
//   }
// }