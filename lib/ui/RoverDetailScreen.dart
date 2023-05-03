import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:spacestats/provider/RoverWikiDetailProvider.dart';
import 'package:spacestats/ui/ImageFullScreen.dart';
import '../model/Rover.dart';
import '../provider/RoverNasaDetailProvider.dart';
import 'RoverImageScreen.dart';

const boldSizeTwenty = TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white);
const italicSizeSixTeen = TextStyle(fontStyle: FontStyle.italic, fontSize: 16, color: Colors.white);
const regularSizeFourTeen = TextStyle(fontStyle: FontStyle.normal, fontSize: 14, color: Colors.white);
const greenBoldSizeThirtyTwo = TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Color.fromRGBO(00, 255, 85, 10));
const greenBoldSizeTwenty = TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color.fromRGBO(00, 255, 85, 10));
const greenBoldSizeFourTeen = TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color.fromRGBO(00, 255, 85, 10));
const blackBoldSizeTwelve = TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black);
const arrowButtonStyle = ButtonStyle(foregroundColor: MaterialStatePropertyAll(Color.fromRGBO(00, 255, 85, 10)));
const outlinedButtonStyle = ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(00, 255, 85, 10)));

class RoverDetailScreen extends StatefulWidget {

  final Rover rover;

  const RoverDetailScreen({super.key, required this.rover});

  @override
  State<RoverDetailScreen> createState() => _RoverDetailScreenState();
}

class _RoverDetailScreenState extends State<RoverDetailScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<RoverWikiDetailProvider>(context, listen: false).fetchRoverWikiDetails(widget.rover.roverName);
      Provider.of<RoverNasaDetailProvider>(context, listen: false).roverExists = false;
      Provider.of<RoverNasaDetailProvider>(context, listen: false).fetchRoverManifest(widget.rover.roverName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<RoverWikiDetailProvider, RoverNasaDetailProvider>(
          builder: (context, roverWikiDetailProvider, roverNasaDetailProvider, child) {

            final wikiResponse = roverWikiDetailProvider.wikiResponse;
            final roverManifest = roverNasaDetailProvider.roverManifest;

            if (roverWikiDetailProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 32),
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: arrowButtonStyle,
                              icon: const Icon(Icons.arrow_back_outlined)
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 95),
                          child: Text(
                            widget.rover.roverName,
                            style: greenBoldSizeTwenty,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageFullScreen(isNetworkImage: false, image: widget.rover.imageSource)),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(32, 16, 32, 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset(
                          widget.rover.imageSource,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  showButtonIfRoverExists(roverNasaDetailProvider.roverExists),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
                    child: Text(
                        wikiResponse.description ?? 'No available description found.',
                        style: regularSizeFourTeen
                    ),
                  ),
                  showManifestIfRoverExists(
                      roverNasaDetailProvider.roverExists,
                      roverManifest.rover.launchDate,
                      roverManifest.rover.launchDate,
                      roverManifest.rover.maxDate,
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 0),
                    child: Text(
                      'About',
                      style: greenBoldSizeTwenty,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 8),
                    child: ReadMoreText(
                        wikiResponse.extract ?? 'No available extract found.',
                        trimLines: 5,
                        colorClickableText: const Color.fromRGBO(00, 255, 85, 10),
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Show more',
                        trimExpandedText: 'Show less',
                        style: regularSizeFourTeen
                    ),
                  ),
                  Center(
                    child: OutlinedButton(
                      onPressed: () {
                        _launchURL(context, 'https://en.wikipedia.org/w/index.php?curid=${wikiResponse.pageId}');
                      },
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Color.fromRGBO(00, 255, 85, 10), width: 2)),
                      child: Text('Learn more about ${widget.rover.roverName} (rover)', style: greenBoldSizeFourTeen)
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  showManifestIfRoverExists(
      bool roverExists,
      DateTime launchDate,
      DateTime landingDate,
      DateTime lastPhotoReceived
  ) {
    if(roverExists){
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
            child: Row(
              children: [
                const Expanded(flex: 1, child: Icon(Icons.rocket_launch, color: Colors.white)),
                Expanded(flex: 7, child: Text("${DateFormat('dd-MM-yyyy').format(launchDate)} (launch date)", style: regularSizeFourTeen))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
            child: Row(
              children: [
                const Expanded(flex: 1, child: Icon(Icons.rocket_launch_outlined, color: Colors.white)),
                Expanded(flex: 7, child: Text("${DateFormat('dd-MM-yyyy').format(landingDate)} (landed on Mars)", style: regularSizeFourTeen))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
            child: Row(
              children: [
                const Expanded(flex: 1, child: Icon(Icons.camera_alt_outlined, color: Colors.white)),
                Expanded(flex: 7, child: Text("${DateFormat('dd-MM-yyyy').format(lastPhotoReceived)} (last communication)", style: regularSizeFourTeen))
              ],
            ),
          ),
        ],
      );
    } else {
      return const Center(
        child: Chip(
            backgroundColor: Color.fromRGBO(00, 255, 85, 10),
            label: Text('Mission manifest unavailable of this rover.', style: blackBoldSizeTwelve)
        ),
      );
    }
  }

  showButtonIfRoverExists(bool roverExists){
    if(roverExists) {
      return Center(
        child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RoverImageScreen()),
              );
            },
            style: OutlinedButton.styleFrom(side: const BorderSide(color: Color.fromRGBO(00, 255, 85, 10), width: 2)),
            child: Text('See photos taken by ${widget.rover.roverName} (rover)', style: greenBoldSizeFourTeen)
        ),
      );
    } else {
      return const Center(
        child: Chip(
            backgroundColor: Color.fromRGBO(00, 255, 85, 10),
            label: Text('Photos are unavailable from this rover.', style: blackBoldSizeTwelve)
        ),
      );
    }
  }

  void _launchURL(BuildContext context, String url) async {
    try {
      await launch(
        url,
        customTabsOption: CustomTabsOption(
          toolbarColor: Colors.black,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: CustomTabsSystemAnimation.slideIn(),
          extraCustomTabs: const <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
        safariVCOption: const SafariViewControllerOption(
          preferredBarTintColor: Colors.black,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}