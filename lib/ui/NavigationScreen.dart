import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/PicOfTheDayProvider.dart';
import 'HomeScreen.dart';
import 'MarsRoverScreen.dart';

const boldSizeTwenty = TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white);
const italicSizeSixTeen = TextStyle(fontStyle: FontStyle.italic, fontSize: 16, color: Colors.white);
const regularSizeFourTeen = TextStyle(fontStyle: FontStyle.normal, fontSize: 14, color: Colors.white);
const greenBoldSizeThirtyTwo = TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Color.fromRGBO(00, 255, 85, 10));
const greenBoldSizeTwenty = TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color.fromRGBO(00, 255, 85, 10));
const greenBoldSizeFourTeen = TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color.fromRGBO(00, 255, 85, 10));
const arrowButtonStyle = ButtonStyle(foregroundColor: MaterialStatePropertyAll(Color.fromRGBO(00, 255, 85, 10)));

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PicOfTheDayProvider>(context, listen: false).fetchPicOfTheDay();
    });
  }

  int _currentIndex = 0;
  List<Widget> body = const [
    HomeScreen(),
    MarsRoverScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        unselectedItemColor: const Color.fromRGBO(00, 255, 85, 10),
        selectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
              label: 'Explore',
              icon: Icon(Icons.rocket_launch),
      ),
        ],
      ),
      body: body[_currentIndex]
    );
  }
}