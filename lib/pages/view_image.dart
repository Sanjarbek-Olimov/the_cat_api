import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ViewImage extends StatelessWidget {
  String url;
  int idImage;

  ViewImage({Key? key, required this.url, required this.idImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "$idImage",
      child: InteractiveViewer(
          minScale: 0.5, maxScale: 3, child: CachedNetworkImage(imageUrl: url)),
    );
  }
}
