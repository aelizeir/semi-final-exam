import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:semi_final_exam/page/todo_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'TodoList with SQLite';
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    // themeMode: ThemeMode.dark,
    theme: ThemeData(
      primaryColor: Colors.black,
      // scaffoldBackgroundColor: Colors.blueGrey.shade900,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    ),
    home: const TodoPage(),
  );
}