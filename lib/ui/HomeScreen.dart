import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import '../provider/PicOfTheDayProvider.dart';
import 'ImageFullScreen.dart';
import 'MarsRoverScreen.dart';

const boldSizeTwenty = TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white);
const italicSizeSixTeen = TextStyle(fontStyle: FontStyle.italic, fontSize: 16, color: Colors.white);
const regularSizeFourTeen = TextStyle(fontStyle: FontStyle.normal, fontSize: 14, color: Colors.white);
const greenBoldSizeThirtyTwo = TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Color.fromRGBO(00, 255, 85, 10));
const greenBoldSizeTwenty = TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color.fromRGBO(00, 255, 85, 10));
const greenBoldSizeFourTeen = TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color.fromRGBO(00, 255, 85, 10));
const arrowButtonStyle = ButtonStyle(foregroundColor: MaterialStatePropertyAll(Color.fromRGBO(00, 255, 85, 10)));

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PicOfTheDayProvider>(context, listen: false).fetchPicOfTheDay();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PicOfTheDayProvider>(
          builder: (context, value, child) {
            final picOfTheDay = value.picOfTheDay;
            if (value.isLoading) { return const Center(child: CircularProgressIndicator()); }
            return Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Image.network(
                      picOfTheDay.url,
                      color: Colors.black87,
                      colorBlendMode: BlendMode.srcOver,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(32, 80, 32, 0),
                        child: Text(
                          'Picture of the day',
                          style: greenBoldSizeThirtyTwo,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageFullScreen(isNetworkImage: true, image: picOfTheDay.hdurl)),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.network(
                              picOfTheDay.hdurl,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
                        child: Text(
                            picOfTheDay.copyright == null ?
                            "${picOfTheDay.title}. ${DateFormat('dd-MM-yyyy').format(picOfTheDay.date)}"
                                : '${picOfTheDay.title}. ${DateFormat('dd-MM-yyyy').format(picOfTheDay.date)}. ${picOfTheDay.copyright}',
                            style: italicSizeSixTeen
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'About',
                          style: greenBoldSizeTwenty,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
                        child: ReadMoreText(
                            picOfTheDay.explanation,
                            trimLines: 5,
                            colorClickableText: const Color.fromRGBO(00, 255, 85, 10),
                            trimMode: TrimMode.Line,
                            trimCollapsedText: ' Show more',
                            trimExpandedText: '. Show less',
                            style: regularSizeFourTeen
                        ),
                      ),
                    ],
                  )),
              ],
            );
          });
  }
}