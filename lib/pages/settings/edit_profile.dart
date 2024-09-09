import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../../api/data/user.dart';
import '../../components/appbar.dart';
import '../../themes/theme.dart';
import 'utils/settings_utils.dart';

class EditProfile extends StatefulWidget {
  final User? user;

  const EditProfile({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  FocusNode? _nameAndSurnameFocusNode;
  TextEditingController? _nameAndSurnameTextController;
  String? Function(BuildContext, String?)?
      _nameAndSurnameTextControllerValidator;

  FocusNode? _emailFocusNode;
  TextEditingController? _emailTextController;
  String? Function(BuildContext, String?)? _emailTextControllerValidator;

  FocusNode? _passwordFocusNode;
  TextEditingController? _passwordTextController;
  bool _passwordVisibility = false;
  String? Function(BuildContext, String?)? _passwordTextControllerValidator;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  User? user;

  @override
  void initState() {
    super.initState();

    debugPrint('User: ${widget.user}');
    if (widget.user != null) setState(() => user = widget.user);

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _nameAndSurnameFocusNode?.dispose();
    _nameAndSurnameTextController?.dispose();

    _emailFocusNode?.dispose();
    _emailTextController?.dispose();

    _passwordFocusNode?.dispose();
    _passwordTextController?.dispose();

    super.dispose();
  }

  void _saveChanges() => debugPrint('Save changes on Edit Profile');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const CustomAppbar(title: 'Edit Profile'),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 36, 0, 0),
              ),
              _buildTitle('Change name and surname'),
              _buildInputField(
                  'Name and Surname',
                  user?.nameAndSurname ?? '',
                  _nameAndSurnameTextController,
                  _nameAndSurnameFocusNode,
                  _nameAndSurnameTextControllerValidator,
                  TextInputType.text,
                  false),
              _buildInputField(
                  'Name and Surname',
                  'Enter a new name and surname.',
                  _nameAndSurnameTextController,
                  _nameAndSurnameFocusNode,
                  _nameAndSurnameTextControllerValidator,
                  TextInputType.text,
                  false),
              _buildTitle('Change email'),
              _buildInputField(
                  'Old email',
                  user?.email ?? '',
                  _emailTextController,
                  _emailFocusNode,
                  _emailTextControllerValidator,
                  TextInputType.emailAddress,
                  false),
              _buildInputField(
                  'New email',
                  'Enter a new email.',
                  _emailTextController,
                  _emailFocusNode,
                  _emailTextControllerValidator,
                  TextInputType.emailAddress,
                  false),
              _buildTitle('Change password'),
              _buildInputField(
                  'Old password',
                  user?.password ?? '',
                  _passwordTextController,
                  _passwordFocusNode,
                  _passwordTextControllerValidator,
                  TextInputType.visiblePassword,
                  true),
              _buildInputField(
                  'New password',
                  'Enter a new password.',
                  _passwordTextController,
                  _passwordFocusNode,
                  _passwordTextControllerValidator,
                  TextInputType.visiblePassword,
                  true),
              buildActionButton(context, 'Save changes', _saveChanges, null),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildTitle(String title) => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 0, 8),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    ),
  );


  Padding _buildInputField(
    String labelText,
    String hint,
    TextEditingController? controller,
    FocusNode? focusNode,
    String? Function(BuildContext, String?)? validator,
    TextInputType keyboardType,
    bool isPassword,
  ) =>
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 12),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          textCapitalization: TextCapitalization.words,
          obscureText: isPassword ? !_passwordVisibility : false,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: Theme.of(context).textTheme.bodyMedium,
            hintText: isPassword ? _passwordVisibility ? hint : '********' : hint,
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onPrimary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppThemes.infoColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
            suffixIcon: InkWell(
              onTap: () =>
                  setState(() => _passwordVisibility = !_passwordVisibility),
              focusNode: FocusNode(skipTraversal: true),
              child: Icon(
                isPassword
                    ? (_passwordVisibility)
                        ? CupertinoIcons.eye_solid
                        : CupertinoIcons.eye_slash_fill
                    : null,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 24,
              ),
            ),
          ),
          keyboardType: keyboardType,
          cursorColor: Theme.of(context).colorScheme.onPrimary,
          style: Theme.of(context).textTheme.bodyMedium,
          validator: validator.asValidator(context),
        ),
      );
}
