import "package:flutter/material.dart";
import "package:expense_tracker/widgets/expenses.dart";

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 51, 255, 0),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 14, 68, 0),
);

// void main() => runApp(const MyApp()); //? same as below

// void main() //? The same as above if only returning 1 line of code
//{
//  runApp(const MyApp());
//}

void main() {
  // WidgetsFlutterBinding.ensureInitialized(); //? how to set the app fixed in 1 orientation
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  //     .then((fn) { runApp(const myApp(),) });
  //
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kDarkColorScheme.onPrimaryContainer,
            foregroundColor: kDarkColorScheme.primaryContainer),
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
              horizontal: 18, vertical: 8), //? linked with expense list
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                kDarkColorScheme.primaryContainer, //? for the container color
            foregroundColor: kDarkColorScheme
                .onPrimaryContainer, //? for the backgorund ON primary
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kDarkColorScheme.onSecondaryContainer,
                  fontSize: 25),
            ),
      ),
      theme: ThemeData().copyWith(
        // scaffoldBackgroundColor: const Color.fromARGB(255, 113, 111, 255),
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorScheme.onPrimaryContainer,
            foregroundColor: kColorScheme.primaryContainer),
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
              horizontal: 18, vertical: 8), //? linked with expense list
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: kColorScheme.primaryContainer),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kColorScheme.onSecondaryContainer,
                  fontSize: 25),
            ),
      ),
      themeMode: ThemeMode.system, //? default is ThemeMode.system
      home: const Expenses(),
    );
  }
}
