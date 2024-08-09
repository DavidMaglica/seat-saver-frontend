import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;

  const CustomAppbar({
    Key? key,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      automaticallyImplyLeading: false,
      leading: FlutterFlowIconButton(
        borderColor: Colors.transparent,
        borderRadius: 30.0,
        borderWidth: 1.0,
        buttonSize: 60.0,
        icon: const Icon(
          CupertinoIcons.chevron_back,
          color: Colors.white,
          size: 30.0,
        ),
        onPressed: () async {
          Navigator.of(this.context).pop();
        },
      ),
      centerTitle: false,
      elevation: 2.0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);}
