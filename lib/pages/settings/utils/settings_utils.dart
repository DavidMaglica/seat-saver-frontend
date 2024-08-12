import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

Widget buildActionButton(BuildContext context, String title,
        Function() onPressed, IconData? iconData) =>
    Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
        child: FFButtonWidget(
          onPressed: onPressed,
          text: title,
          icon: iconData != null ? Icon(iconData, size: 16) : null,
          options: FFButtonOptions(
            width: 270,
            height: 50,
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            color: Theme.of(context).colorScheme.primary,
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.background,
              fontSize: 16,
            ),
            elevation: 3,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );

Widget buildProfilePicture(BuildContext context) => Align(
      alignment: const AlignmentDirectional(-1, 1),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 16),
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                fadeInDuration: const Duration(milliseconds: 500),
                fadeOutDuration: const Duration(milliseconds: 500),
                imageUrl:
                    'https://images.unsplash.com/photo-1617644558945-ea1c43e5d0a8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw1fHxQdWxhfGVufDB8fHx8MTcxOTUxNjIyMXww&ixlib=rb-4.3&q=80&w=1080',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
