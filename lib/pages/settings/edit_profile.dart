import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../../components/appbar.dart';
import '../../themes/theme.dart';
import 'utils/settings_utils.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  FocusNode? _usernameFocusNode;
  TextEditingController? _usernameTextController;
  String? Function(BuildContext, String?)? _usernameTextControllerValidator;

  FocusNode? _emailFocusNode;
  TextEditingController? _emailTextController;
  String? Function(BuildContext, String?)? _emailTextControllerValidator;

  final _creditCardFormKey = GlobalKey<FormState>();
  final CreditCardModel _creditCardInfo = emptyCreditCard();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _usernameFocusNode?.dispose();
    _usernameTextController?.dispose();

    _emailFocusNode?.dispose();
    _emailTextController?.dispose();

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
              buildProfilePicture(context),
              _buildInputField(
                  'Name and Surname',
                  _usernameTextController,
                  _usernameFocusNode,
                  _usernameTextControllerValidator,
                  TextInputType.text),
              _buildInputField('Email', _emailTextController, _emailFocusNode,
                  _emailTextControllerValidator, TextInputType.emailAddress),
              _buildCreditCardForm(),
              buildActionButton(context, 'Save changes', _saveChanges, null),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildInputField(
          String labelText,
          TextEditingController? controller,
          FocusNode? focusNode,
          String? Function(BuildContext, String?)? validator,
          TextInputType keyboardType) =>
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 12),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          textCapitalization: TextCapitalization.words,
          obscureText: false,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: Theme.of(context).textTheme.bodyMedium,
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
          ),
          keyboardType: keyboardType,
          cursorColor: Theme.of(context).colorScheme.onPrimary,
          style: Theme.of(context).textTheme.bodyMedium,
          validator: validator.asValidator(context),
        ),
      );

  Padding _buildCreditCardForm() => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
        child: FlutterFlowCreditCardForm(
          formKey: _creditCardFormKey,
          creditCardModel: _creditCardInfo,
          obscureNumber: false,
          obscureCvv: false,
          spacing: 12,
          textStyle: Theme.of(context).textTheme.bodyMedium,
          inputDecoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).secondaryText,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).secondaryText,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
}
