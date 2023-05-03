import 'dart:math';

import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spacestats/provider/RoverNasaDetailProvider.dart';
import 'package:spacestats/ui/ImageFullScreen.dart';

const boldSizeTwenty = TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white);
const italicSizeSixTeen = TextStyle(fontStyle: FontStyle.italic, fontSize: 16, color: Colors.white);
const regularSizeFourTeen = TextStyle(fontStyle: FontStyle.normal, fontSize: 14, color: Colors.white);
const greenBoldSizeThirtyTwo = TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Color.fromRGBO(00, 255, 85, 10));
const greenBoldSizeTwenty = TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color.fromRGBO(00, 255, 85, 10));
const greenBoldSizeFourTeen = TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color.fromRGBO(00, 255, 85, 10));
const blackBoldSizeTwelve = TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black);
const arrowButtonStyle = ButtonStyle(foregroundColor: MaterialStatePropertyAll(Color.fromRGBO(00, 255, 85, 10)));

class RoverImageScreen extends StatefulWidget {
  const RoverImageScreen({super.key});

  @override
  State<RoverImageScreen> createState() => _RoverImageScreenState();
}

class _RoverImageScreenState extends State<RoverImageScreen> {
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RoverNasaDetailProvider>(
          builder: (context, roverNasaDetailProvider, child) {
            final roverInfo = roverNasaDetailProvider.roverManifest;
            var dateMethod = roverNasaDetailProvider.slideValue;
            var chipsMethod = roverNasaDetailProvider.chipsValue;

            if (roverNasaDetailProvider.isLoading) {
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
                                roverNasaDetailProvider.picOfApiCall = null;
                                Navigator.pop(context);
                              },
                              style: arrowButtonStyle,
                              icon: const Icon(Icons.arrow_back_outlined)
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 95),
                          child: Text(
                            'Generator',
                            style: greenBoldSizeTwenty,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if(roverNasaDetailProvider.roverImages.photos.isNotEmpty && roverNasaDetailProvider.picOfApiCall != null) ...[
                    Visibility(
                      visible: roverNasaDetailProvider.roverImages.photos.isNotEmpty,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageFullScreen(isNetworkImage: true, image: roverNasaDetailProvider.picOfApiCall.imgSrc),
                              ));
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.network(
                                roverNasaDetailProvider.picOfApiCall.imgSrc,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Visibility(
                      visible: roverNasaDetailProvider.roverImages.photos.isNotEmpty,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
                        child: Text(
                            "Photo #${roverNasaDetailProvider.picOfApiCall.id},"
                                " from Sol ${roverNasaDetailProvider.picOfApiCall.sol},"
                                " of ${roverNasaDetailProvider.picOfApiCall.rover.name}'s "
                                "mission (Earth date: ${DateFormat('dd-MM-yyyy').format(roverNasaDetailProvider.picOfApiCall.earthDate)}), using the "
                                "${roverNasaDetailProvider.picOfApiCall.camera.fullName} (${roverNasaDetailProvider.picOfApiCall.camera.name})",
                            style: regularSizeFourTeen
                        ),
                      ),
                    ),
                  ],

                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Center(
                      child: CustomSlidingSegmentedControl<int>(
                        initialValue: dateMethod,
                        children: const {
                          1: Text('Martian sol', style: blackBoldSizeTwelve),
                          2: Text('Earth date', style: blackBoldSizeTwelve),
                        },
                        decoration: BoxDecoration(
                          color: CupertinoColors.lightBackgroundGray,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        thumbDecoration: const BoxDecoration(
                          color: Color.fromRGBO(00, 255, 85, 10),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInToLinear,
                        onValueChanged: (value) {
                          setState(() {
                            roverNasaDetailProvider.slideValue = value;
                          });
                        },
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: AnswerTextField(
                        controller: dateController,
                        hint: dateMethod == 1 ? 'Enter Sol number... (0 - ${roverInfo.rover.maxSol})'
                            : 'Enter Earth date... (${DateFormat('dd-MM-yyyy').format(roverInfo.rover.landingDate)} - ${DateFormat('dd-MM-yyyy').format(roverInfo.rover.maxDate)})'
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 8),
                    child: Text(
                      'Pick camera',
                      style: greenBoldSizeTwenty,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Wrap(
                      spacing: 5.0,
                      children: List<Widget>.generate(3, (int index) {
                        return ChoiceChip(
                          label: Text(roverInfo.rover.cameras[index].name),
                          selected: chipsMethod == index,
                          selectedColor: const Color.fromRGBO(00, 255, 85, 10),
                          onSelected: (bool selected) {
                            setState(() {
                              roverNasaDetailProvider.chipsValue = index;
                            });
                          },
                        );
                      },
                      ).toList(),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              if(dateMethod == 1) {
                                roverNasaDetailProvider.getRoverImagesBySol(int.parse(dateController.text), roverNasaDetailProvider.roverManifest.rover.cameras[chipsMethod].name);
                              } else {
                                roverNasaDetailProvider.getRoverImagesByEarthDate(dateController.text, roverNasaDetailProvider.roverManifest.rover.cameras[chipsMethod].name);
                              }
                            });
                          },
                          style: OutlinedButton.styleFrom(side: const BorderSide(
                              color: Color.fromRGBO(00, 255, 85, 10), width: 2)),
                          child: const Text(
                              'Fetch pic of this chosen day',
                              style: greenBoldSizeFourTeen
                          )
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class AnswerTextField extends StatefulWidget {
  const AnswerTextField({Key? key, required this.controller, required this.hint}) : super(key: key);

  final TextEditingController controller;
  final String hint;

  @override
  State<AnswerTextField> createState() => _AnswerTextFieldState();
}

class _AnswerTextFieldState extends State<AnswerTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: regularSizeFourTeen, //<-- SEE HERE
              controller: widget.controller,
              decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                      width: 1, color: Color.fromRGBO(00, 255, 85, 10)), //<-- SEE HERE
                ),
                hintText: widget.hint,
                hintStyle: regularSizeFourTeen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
