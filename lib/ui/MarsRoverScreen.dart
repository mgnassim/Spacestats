import 'package:flutter/material.dart';
import 'package:spacestats/model/Rover.dart';
import 'package:spacestats/ui/RoverDetailScreen.dart';

const boldSizeTwenty = TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white);
const italicSizeSixTeen = TextStyle(fontStyle: FontStyle.italic, fontSize: 16, color: Colors.white);
const regularSizeFourTeen = TextStyle(fontStyle: FontStyle.normal, fontSize: 14, color: Colors.white);
const greenBoldSizeThirtyTwo = TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Color.fromRGBO(00, 255, 85, 10));
const greenBoldSizeTwenty = TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color.fromRGBO(00, 255, 85, 10));
const greenBoldSizeFourTeen = TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color.fromRGBO(00, 255, 85, 10));
const arrowButtonStyle = ButtonStyle(foregroundColor: MaterialStatePropertyAll(Color.fromRGBO(00, 255, 85, 10)));
const introText = "Over the years, NASA has sent five robotic vehicles, called rovers, to Mars. The names of the five rovers are: Sojourner, Spirit and Opportunity, Curiosity, and Perseverance. Mars is a fascinating planet. It's icy cold and covered in reddish dust and dirt.";

class MarsRoverScreen extends StatefulWidget {
  const MarsRoverScreen({super.key});

  @override
  State<MarsRoverScreen> createState() => _MarsRoverScreenState();
}

class _MarsRoverScreenState extends State<MarsRoverScreen> {
  List<Rover> rovers = [
    Rover(imageSource: 'images/sojourner.jpeg', roverName: 'Sojourner'),
    Rover(imageSource: 'images/spirit.jpeg', roverName: 'Spirit'),
    Rover(imageSource: 'images/opportunity.jpeg', roverName: 'Opportunity'),
    Rover(imageSource: 'images/curiosity.jpeg', roverName: 'Curiosity'),
    Rover(imageSource: 'images/perseverance.jpeg', roverName: 'Perseverance'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(32, 80, 32, 0),
                  child: Text(
                    'Explore Mars',
                    style: greenBoldSizeThirtyTwo,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  child: Text(introText, style: regularSizeFourTeen),
                ),
                GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 0.0),
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    crossAxisCount: 2,
                  ),
                  itemCount: rovers.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RoverDetailScreen(rover: rovers[index])),
                        );
                      },
                      child: Expanded(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.asset(rovers[index].imageSource, fit: BoxFit.cover)
                          )
                      ),
                    );
                  },
                )
          ]),
      );
  }
}
