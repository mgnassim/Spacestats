import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spacestats/provider/PicOfTheDayProvider.dart';
import 'package:spacestats/provider/RoverNasaDetailProvider.dart';
import 'package:spacestats/provider/RoverWikiDetailProvider.dart';
import 'package:spacestats/ui/NavigationScreen.dart';
import 'package:spacestats/ui/MarsRoverScreen.dart';

ThemeData theme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    textTheme: GoogleFonts.andikaTextTheme(),
    useMaterial3: true,
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PicOfTheDayProvider()),
        ChangeNotifierProvider(create: (_) => RoverWikiDetailProvider()),
        ChangeNotifierProvider(create: (_) => RoverNasaDetailProvider()),
      ], 
      child: MaterialApp(
        theme: theme,
        home: const NavigationScreen(),
      ),
    );
  }
}
