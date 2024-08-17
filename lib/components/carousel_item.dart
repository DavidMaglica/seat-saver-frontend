import 'package:diplomski/themes/theme.dart';
import 'package:flutter/material.dart';

class CarouselItem extends StatefulWidget {
  final String currentCity;

  const CarouselItem(this.currentCity, {super.key});

  @override
  State<CarouselItem> createState() => _CarouselItemState();
}

class _CarouselItemState extends State<CarouselItem> {
  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 256,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildImage(),
          _buildText(),
        ],
      ),
    );
  }

  Padding _buildText() => Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        Align(
            alignment: const AlignmentDirectional(-1, 0),
            child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                child: Text(widget.currentCity,
                    style: const TextStyle(
                      color: AppThemes.accent1,
                      fontSize: 18,
                      fontFamily: 'Oswald',
                    )))),
        Align(
            alignment: const AlignmentDirectional(-1, 0),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
              child: Text('Discover new restaurants in ${widget.currentCity}!',
                  style: Theme.of(context).textTheme.bodyMedium),
            ))
      ]));

  ClipRRect _buildImage() => ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
      child: Image.network(
        'https://images.unsplash.com/photo-1617644558945-ea1c43e5d0a8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw1fHxQdWxhfGVufDB8fHx8MTcxOTUxNjIyMXww&ixlib=rb-4.0.3&q=80&w=1080',
        width: double.infinity,
        height: 128,
        fit: BoxFit.cover,
      ));
}
