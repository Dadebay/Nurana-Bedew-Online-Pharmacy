// ignore_for_file: file_names, void_checks

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/Others/constants/widgets.dart';
import 'package:photo_view/photo_view.dart';

class Photoview extends StatefulWidget {
  const Photoview({
    Key key,
    this.image,
  }) : super(key: key);

  final String image;

  @override
  _PhotoviewState createState() => _PhotoviewState();
}

class _PhotoviewState extends State<Photoview> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
                child: PhotoView(
              enableRotation: true,
              minScale: 0.4,
              maxScale: 2.0,
              imageProvider: CachedNetworkImageProvider(
                widget.image,
                errorListener: () {
                  return const Icon(Icons.error_outline, color: Colors.white);
                },
              ),
              tightMode: true,
              errorBuilder: (context, url, error) =>
                  const Icon(Icons.error_outline),
              loadingBuilder: (context, url) => Center(child: spinKit()),
            )),
            Positioned(
              right: 20.0,
              top: 20.0,
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(CupertinoIcons.xmark_circle,
                      color: Colors.white, size: 40)),
            ),
          ],
        ),
      ),
    );
  }
}
