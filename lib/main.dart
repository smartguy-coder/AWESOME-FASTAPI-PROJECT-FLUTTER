import 'package:fastapiproject/internal/access_internal_storage.dart';
import 'package:fastapiproject/page_router.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

InternalDatabase db = InternalDatabase();
var currentThemeMode;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('Box').then((value) {
    if (!(db.getThemeMode is ThemeMode)) {
      db.createInitialData();
    }
  });

  currentThemeMode = db.getThemeMode();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void changeStateMain() {
    setState(() {
      currentThemeMode = db.getThemeMode();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PageRouter(changeStateMain: changeStateMain),
      themeMode: currentThemeMode,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            color: Color.fromRGBO(253, 123, 8, 1),
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(
            color: Color.fromRGBO(98, 98, 98, 1),
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
          bodySmall: TextStyle(
            color: Color.fromRGBO(98, 98, 98, 1),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        colorScheme: const ColorScheme.light(
          onPrimary: Color.fromRGBO(253, 123, 8, 1),
          primary: Color.fromRGBO(98, 98, 98, 1),
          secondary: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            color: Color.fromRGBO(253, 123, 8, 1),
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(
            color: Color.fromRGBO(98, 98, 98, 1),
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
          bodySmall: TextStyle(
            color: Color.fromRGBO(98, 98, 98, 1),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        colorScheme: const ColorScheme.dark(
          onPrimary: Color.fromRGBO(253, 123, 8, 1),
          primary: Color.fromRGBO(98, 98, 98, 1),
          secondary: Color.fromRGBO(70, 70, 70, 1),
        ),
      ),
    );
  }
}
