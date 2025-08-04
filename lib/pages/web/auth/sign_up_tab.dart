import 'package:TableReserver/api/data/basic_response.dart';
import 'package:TableReserver/components/common/toaster.dart';
import 'package:TableReserver/models/web/authentication_model.dart';
import 'package:TableReserver/models/web/sign_up_tab_model.dart';
import 'package:TableReserver/pages/web/views/homepage.dart';
import 'package:TableReserver/themes/web_theme.dart';
import 'package:TableReserver/utils/fade_in_route.dart';
import 'package:TableReserver/utils/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpTab extends StatefulWidget {
  final AuthenticationModel model;

  const SignUpTab({super.key, required this.model});

  @override
  State<SignUpTab> createState() => _SignUpTabState();
}

class _SignUpTabState extends State<SignUpTab> {
  late SignUpTabModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SignUpTabModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _performSignUp(
    String email,
    String username,
    String password,
    String confirmPassword,
  ) async {
    BasicResponse<int?> response = await _model.signUp(
      username,
      email,
      password,
      confirmPassword,
    );
    if (response.success && response.data != null) {
      _goToHomepage(response.data!);
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
                  _buildUsernameField(context),
                  const SizedBox(height: 16),
                  _buildPasswordField(context),
                  const SizedBox(height: 16),
                  _buildConfirmPasswordField(context),
                  const SizedBox(height: 32),
                  _buildSignUpButton(context),
                  const SizedBox(height: 16),
                  _buildText(context),
                  const SizedBox(height: 16),
                  _buildGoogleButton(context),
                ],
              ),
            ).animateOnPageLoad(
              widget.model.animationsMap['columnOnPageLoadAnimation1']!,
            ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      'Create Account',
      textAlign: TextAlign.start,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        controller: widget.model.emailAddressCreateTextController,
        focusNode: widget.model.emailAddressCreateFocusNode,
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
          contentPadding: const EdgeInsets.all(24),
        ),
        style: Theme.of(context).textTheme.bodyLarge,
        keyboardType: TextInputType.emailAddress,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildUsernameField(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        controller: widget.model.usernameCreateTextController,
        focusNode: widget.model.usernameCreateFocusNode,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'Username',
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
          contentPadding: const EdgeInsets.all(24),
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
        controller: widget.model.passwordCreateTextController,
        focusNode: widget.model.passwordCreateFocusNode,
        autofocus: false,
        obscureText: !widget.model.passwordCreateVisibility,
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
          contentPadding: const EdgeInsets.all(24),
          suffixIcon: InkWell(
            onTap: () => safeSetState(
              () => widget.model.passwordCreateVisibility =
                  !widget.model.passwordCreateVisibility,
            ),
            focusNode: FocusNode(skipTraversal: true),
            child: Icon(
              widget.model.passwordCreateVisibility
                  ? CupertinoIcons.eye_fill
                  : CupertinoIcons.eye_slash_fill,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 24,
            ),
          ),
        ),
        style: Theme.of(context).textTheme.bodyLarge,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        controller: widget.model.passwordCreateConfirmTextController,
        focusNode: widget.model.passwordCreateConfirmFocusNode,
        autofocus: false,
        obscureText: !widget.model.passwordCreateConfirmVisibility,
        decoration: InputDecoration(
          labelText: 'Confirm password',
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
          contentPadding: const EdgeInsets.all(24),
          suffixIcon: InkWell(
            onTap: () => safeSetState(
              () => widget.model.passwordCreateConfirmVisibility =
                  !widget.model.passwordCreateConfirmVisibility,
            ),
            focusNode: FocusNode(skipTraversal: true),
            child: Icon(
              widget.model.passwordCreateConfirmVisibility
                  ? CupertinoIcons.eye_fill
                  : CupertinoIcons.eye_slash_fill,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 24,
            ),
          ),
        ),
        style: Theme.of(context).textTheme.bodyLarge,
        keyboardType: TextInputType.visiblePassword,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: FFButtonWidget(
        onPressed: () => _performSignUp(
          widget.model.emailAddressCreateTextController.text,
          widget.model.usernameCreateTextController.text,
          widget.model.passwordCreateTextController.text,
          widget.model.passwordCreateConfirmTextController.text,
        ),
        text: 'Sign Up',
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
        'Or sign up with',
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
            _performSignUp(
              account.email,
              account.displayName ?? account.email,
              account.id,
              account.id,
            );
          } catch (e) {
            if (!context.mounted) return;
            Toaster.displayError(context, 'Google sign-in failed: $e');
          }
        },
        text: 'Sign Up with Google',
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
}
