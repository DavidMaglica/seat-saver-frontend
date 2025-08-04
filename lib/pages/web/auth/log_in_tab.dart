import 'package:TableReserver/api/account_api.dart';
import 'package:TableReserver/api/data/basic_response.dart';
import 'package:TableReserver/api/data/user.dart';
import 'package:TableReserver/api/data/user_response.dart';
import 'package:TableReserver/components/common/toaster.dart';
import 'package:TableReserver/models/web/authentication_model.dart';
import 'package:TableReserver/models/web/log_in_tab_model.dart';
import 'package:TableReserver/pages/web/views/homepage.dart';
import 'package:TableReserver/themes/web_theme.dart';
import 'package:TableReserver/utils/fade_in_route.dart';
import 'package:TableReserver/utils/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  void _performLogIn(String email, String password) async {
    BasicResponse<int> response = await _model.logIn(email, password);
    if (response.success && response.data != null) {
      int userId = response.data!;

      UserResponse? userResponse = await accountApi.getUser(userId);

      User user = userResponse!.user!;

      _goToHomepage(user.id);
    } else {
      if (!mounted) return;
      Toaster.displayError(context, response.message);
    }
  }

  void _goToHomepage(int userId) {
    Navigator.of(context).push(
      FadeInRoute(routeName: Routes.webHomepage, page: const WebHomepage()),
    );
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
        child:
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(context),
                  const SizedBox(height: 32),
                  _buildEmailField(context),
                  const SizedBox(height: 16),
                  _buildPasswordField(context),
                  const SizedBox(height: 32),
                  _buildLogInButton(context),
                  const SizedBox(height: 16),
                  _buildText(context),
                  const SizedBox(height: 16),
                  _buildGoogleButton(context),
                  const SizedBox(height: 16),
                  _buildForgotPassword(),
                ],
              ),
            ).animateOnPageLoad(
              widget.model.animationsMap['columnOnPageLoadAnimation2']!,
            ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      'Log In',
      textAlign: TextAlign.start,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        controller: widget.model.emailAddressTextController,
        focusNode: widget.model.emailAddressFocusNode,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: WebTheme.infoColor, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsetsDirectional.fromSTEB(24, 24, 0, 24),
        ),
        style: Theme.of(context).textTheme.bodyLarge,
        keyboardType: TextInputType.emailAddress,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        controller: widget.model.passwordTextController,
        focusNode: widget.model.passwordFocusNode,
        autofocus: false,
        obscureText: !widget.model.passwordVisibility,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: WebTheme.infoColor, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsetsDirectional.fromSTEB(24, 24, 0, 24),
          suffixIcon: InkWell(
            onTap: () => safeSetState(
              () => widget.model.passwordVisibility =
                  !widget.model.passwordVisibility,
            ),
            focusNode: FocusNode(skipTraversal: true),
            child: Icon(
              widget.model.passwordVisibility
                  ? CupertinoIcons.eye_fill
                  : CupertinoIcons.eye_slash_fill,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 24,
            ),
          ),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
        keyboardType: TextInputType.visiblePassword,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildLogInButton(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: FFButtonWidget(
        onPressed: () => _performLogIn(
          widget.model.emailAddressCreateTextController.text,
          widget.model.passwordTextController.text,
        ),
        text: 'Log In',
        options: FFButtonOptions(
          width: 230,
          height: 52,
          color: WebTheme.successColor,
          textStyle: TextStyle(
            color: Theme.of(context).colorScheme.surface,
            fontSize: 18,
            fontFamily: 'Oswald',
          ),
          elevation: 3,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildText(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Text(
        'Or log in with',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildGoogleButton(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: FFButtonWidget(
        onPressed: () async {
          try {
            GoogleSignInAccount account = await GoogleSignIn.instance
                .authenticate();
            _performLogIn(account.email, account.id);
          } catch (e) {
            if (!context.mounted) return;
            Toaster.displayError(context, 'Google sign-in failed: $e');
          }
        },
        text: 'Continue with Google',
        icon: const Icon(FontAwesomeIcons.google, size: 20),
        options: FFButtonOptions(
          width: 230,
          height: 52,
          color: WebTheme.infoColor,
          textStyle: TextStyle(
            color: Theme.of(context).colorScheme.surface,
            fontSize: 18,
            fontFamily: 'Oswald',
          ),
          elevation: 3,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: TextButton(
        onPressed: _forgotPassword,
        child: const Text(
          'Forgot password? Reset here.',
          style: TextStyle(
            fontSize: 14,
            color: WebTheme.infoColor,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
