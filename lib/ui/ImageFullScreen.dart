import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacestats/provider/PicOfTheDayProvider.dart';

class ImageFullScreen extends StatefulWidget {

  final bool isNetworkImage;
  final String image;

  const ImageFullScreen({super.key, required this.isNetworkImage, required this.image});

  @override
  State<ImageFullScreen> createState() => _ImageFullScreenState();
}

class _ImageFullScreenState extends State<ImageFullScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: FittedBox(
                fit: BoxFit.cover,
                child: widget.isNetworkImage ? Image.network(
                  widget.image,
                  color: Colors.black54,
                  colorBlendMode: BlendMode.srcOver,
                ) : Image.asset(
                  widget.image,
                  color: Colors.black54,
                  colorBlendMode: BlendMode.srcOver,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: widget.isNetworkImage ? Image.network(
                    widget.image,
                    fit: BoxFit.cover,
                  ) : Image.asset(
                    widget.image,
                    fit: BoxFit.cover
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }
}
