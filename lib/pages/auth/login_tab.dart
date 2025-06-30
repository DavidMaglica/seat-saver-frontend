import 'package:TableReserver/api/account_api.dart';
import 'package:TableReserver/api/data/basic_response.dart';
import 'package:TableReserver/api/data/user.dart';
import 'package:TableReserver/api/data/user_response.dart';
import 'package:TableReserver/components/toaster.dart';
import 'package:TableReserver/models/authentication_model.dart';
import 'package:TableReserver/models/login_tab_model.dart';
import 'package:TableReserver/themes/theme.dart';
import 'package:TableReserver/utils/constants.dart';
import 'package:TableReserver/utils/sign_up_methods.dart';
import 'package:TableReserver/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LogInTab extends StatefulWidget {
  final AuthenticationModel model;

  const LogInTab({super.key, required this.model});

  @override
  State<LogInTab> createState() => _LogInTabState();
}

class _LogInTabState extends State<LogInTab> {
  late LogInTabModel _model;
  late final AccountApi accountApi = AccountApi();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LogInTabModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _performLogIn(SignUpMethodEnum signUpMethod) async {
    BasicResponse<int> response = await _model.logIn(signUpMethod);
    if (response.success && response.data != null) {
      int userId = response.data!;

      UserResponse? userResponse = await accountApi.getUser(userId);

      User user = userResponse!.user!;

      Position? lastKnownLocation = getPositionFromLatAndLong(
        user.lastKnownLatitude,
        user.lastKnownLongitude,
      );

      _goToHomepage(user.id, lastKnownLocation);
    } else {
      if (!mounted) return;
      Toaster.displayError(context, response.message);
    }
  }

  void _goToHomepage(int userId, Position? userLocation) {
    Navigator.pushNamed(context, Routes.homepage,
        arguments: {'userId': userId, 'userLocation': userLocation});
  }

  void _forgotPassword() {
    Toaster.displayInfo(context, 'Not implemented yet');
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0, -1),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 24, 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (responsiveVisibility(
                context: context,
                phone: false,
                tablet: false,
              ))
                Container(
                  width: 230,
                  height: 16,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                ),
              Text(
                'Welcome Back',
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 24),
                child: Text(
                  'Fill out the information below in order to access your account.',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: _buildEmailField(),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 32),
                child: SizedBox(
                  width: double.infinity,
                  child: _buildPasswordField(),
                ),
              ),
              _buildLogInButton(),
              Align(
                alignment: const AlignmentDirectional(0, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                  child: Text(
                    'Or log in with',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              Align(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  direction: Axis.horizontal,
                  runAlignment: WrapAlignment.center,
                  verticalDirection: VerticalDirection.down,
                  clipBehavior: Clip.none,
                  children: [
                    _buildAppleLogInButton(),
                    _buildGoogleLogInButton(),
                  ],
                ),
              ),
              Align(
                child: _buildForgotPassword(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: widget.model.passwordLogInTextController,
      focusNode: widget.model.passwordLogInFocusNode,
      autofocus: false,
      autofillHints: const [AutofillHints.password],
      obscureText: !widget.model.passwordLogInVisibility,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
            width: .5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppThemes.infoColor,
            width: .5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: .5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: .5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsetsDirectional.fromSTEB(24, 24, 0, 24),
        suffixIcon: InkWell(
          onTap: () => setState(
            () => widget.model.passwordLogInVisibility =
                !widget.model.passwordLogInVisibility,
          ),
          focusNode: FocusNode(skipTraversal: true),
          child: Icon(
            (widget.model.passwordLogInVisibility)
                ? CupertinoIcons.eye_solid
                : CupertinoIcons.eye_slash_fill,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 24,
          ),
        ),
      ),
      style: Theme.of(context).textTheme.bodyMedium,
      cursorColor: Theme.of(context).colorScheme.onPrimary,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: widget.model.emailAddressLogInTextController,
      focusNode: widget.model.emailAddressLogInFocusNode,
      autofocus: false,
      autofillHints: const [AutofillHints.email],
      obscureText: false,
      decoration: InputDecoration(
        isDense: false,
        labelText: 'Email',
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
            width: .5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppThemes.infoColor,
            width: .5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: .5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: .5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.all(24),
      ),
      style: Theme.of(context).textTheme.bodyLarge,
      keyboardType: TextInputType.emailAddress,
      cursorColor: Theme.of(context).colorScheme.onPrimary,
    );
  }

  Widget _buildLogInButton() {
    return Align(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
        child: FFButtonWidget(
          onPressed: () => _performLogIn(SignUpMethodEnum.custom),
          text: 'Log In',
          options: FFButtonOptions(
            width: 270,
            height: 50,
            color: AppThemes.successColor,
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
            borderSide: BorderSide.none,
            elevation: 3,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleLogInButton() {
    return Align(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
        child: FFButtonWidget(
          onPressed: () => _performLogIn(SignUpMethodEnum.google),
          text: 'Continue with Google',
          icon: const Icon(
            FontAwesomeIcons.google,
            size: 16,
          ),
          options: FFButtonOptions(
            width: 270,
            height: 50,
            color: Theme.of(context).colorScheme.background,
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(.3),
              fontSize: 18,
            ),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 1,
            ),
            elevation: 0,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildAppleLogInButton() {
    return Align(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
        child: FFButtonWidget(
          onPressed: () => _performLogIn(SignUpMethodEnum.apple),
          text: 'Continue with Apple',
          icon: const Icon(
            Icons.apple,
            size: 24,
          ),
          options: FFButtonOptions(
            width: 270,
            height: 50,
            color: Theme.of(context).colorScheme.background,
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(.3),
              fontSize: 18,
            ),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 1,
            ),
            elevation: 0,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
        child: TextButton(
          onPressed: _forgotPassword,
          child: const Text(
            'Forgot password? Reset here.',
            style: TextStyle(
              fontSize: 12,
              color: AppThemes.infoColor,
              decoration: TextDecoration.underline,
            ),
          ),
        ));
  }
}
