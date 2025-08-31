import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onBack;

  const CustomAppbar({super.key, this.title, this.onBack});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      automaticallyImplyLeading: false,
      title: Text(title ?? '', style: Theme.of(context).textTheme.labelLarge),
      leading: FlutterFlowIconButton(
        borderColor: Colors.transparent,
        borderRadius: 30,
        borderWidth: 1,
        buttonSize: 60,
        icon: Icon(
          CupertinoIcons.chevron_left,
          color: Theme.of(context).colorScheme.onSurface,
          size: 24,
        ),
        onPressed: onBack ?? () => Navigator.of(context).pop(),
      ),
      centerTitle: false,
      elevation: 3,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
