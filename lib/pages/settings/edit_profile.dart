import 'package:diplomski/pages/settings/utils/settings_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../../components/appbar.dart';
import '../../themes/theme.dart';
import 'models/edit_profile_model.dart';

export 'models/edit_profile_model.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late EditProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditProfileModel());

    _model.usernameTextController ??= TextEditingController();
    _model.usernameFocusNode ??= FocusNode();

    _model.emailTextController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();

    _model.addressTextController ??= TextEditingController();
    _model.addressFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

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
                  _model.usernameTextController,
                  _model.usernameFocusNode,
                  _model.usernameTextControllerValidator),
              _buildInputField('Email', _model.emailTextController,
                  _model.emailFocusNode, _model.emailTextControllerValidator),
              _buildInputField('Address', _model.addressTextController,
                  _model.addressFocusNode, _model.cityTextControllerValidator),
              _buildCreditCardForm(),
              buildActionButton(context, 'Save changes', _saveChanges, null),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
          String labelText,
          TextEditingController? controller,
          FocusNode? focusNode,
          String? Function(BuildContext, String?)? validator) =>
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
          cursorColor: Theme.of(context).colorScheme.onPrimary,
          style: Theme.of(context).textTheme.bodyMedium,
          validator: validator.asValidator(context),
        ),
      );

  Widget _buildCreditCardForm() => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
        child: FlutterFlowCreditCardForm(
          formKey: _model.creditCardFormKey,
          creditCardModel: _model.creditCardInfo,
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

  void _saveChanges() => debugPrint('Save changes on Edit Profile');
}
