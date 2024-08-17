import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullScreenImageView extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const FullScreenImageView({
    Key? key,
    required this.imageUrl,
    required this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              CupertinoIcons.xmark_circle_fill,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Hero(
            tag: heroTag,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
}
