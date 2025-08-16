import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/account_api.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/api/data/user.dart';
import 'package:table_reserver/api/data/user_response.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/models/web/authentication_model.dart';
import 'package:table_reserver/models/web/sign_up_tab_model.dart';
import 'package:table_reserver/pages/web/views/homepage.dart';
import 'package:table_reserver/themes/web_theme.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/google_web/google_button_interface.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:table_reserver/utils/web_toaster.dart';

class SignUpTab extends StatefulWidget {
  final AuthenticationModel model;

  const SignUpTab({super.key, required this.model});

  @override
  State<SignUpTab> createState() => _SignUpTabState();
}

class _SignUpTabState extends State<SignUpTab> {
  late SignUpTabModel _model;
  final AccountApi accountApi = AccountApi();

  @override
  void initState() {
    super.initState();
    _model = createModel(
      context,
      () => SignUpTabModel(isActive: widget.model.tabBarController!.index == 1),
    );
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
      username: username,
      email: email,
      password: password,
      confirmedPassword: confirmPassword,
    );
    if (response.success && response.data != null) {
      int ownerId = response.data!;

      UserResponse? userResponse = await accountApi.getUser(ownerId);

      if (userResponse != null && userResponse.success) {
        User user = userResponse.user!;

        prefsWithCache.setInt('ownerId', ownerId);

        _goToHomepage(user.id);
      }
    } else {
      if (!mounted) return;
      WebToaster.displayError(context, response.message);
    }
  }

  void _goToHomepage(int ownerId) {
    Navigator.of(context).push(
      FadeInRoute(
        routeName: Routes.webHomepage,
        page: WebHomepage(ownerId: ownerId),
      ),
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
                  buildGoogleButton(),
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
        controller: widget.model.signUpEmailTextController,
        focusNode: widget.model.signUpEmailFocusNode,
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
        controller: widget.model.signUpUsernameTextController,
        focusNode: widget.model.signUpUsernameFocusNode,
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
        controller: widget.model.signUpPasswordTextController,
        focusNode: widget.model.signUpPasswordFocusNode,
        autofocus: false,
        obscureText: !widget.model.signUpPasswordVisibility,
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
              () => widget.model.signUpPasswordVisibility =
                  !widget.model.signUpPasswordVisibility,
            ),
            focusNode: FocusNode(skipTraversal: true),
            child: Icon(
              widget.model.signUpPasswordVisibility
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
        controller: widget.model.signUpPasswordConfirmTextController,
        focusNode: widget.model.signUpPasswordConfirmFocusNode,
        autofocus: false,
        obscureText: !widget.model.signUpPasswordConfirmVisibility,
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
              () => widget.model.signUpPasswordConfirmVisibility =
                  !widget.model.signUpPasswordConfirmVisibility,
            ),
            focusNode: FocusNode(skipTraversal: true),
            child: Icon(
              widget.model.signUpPasswordConfirmVisibility
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
          widget.model.signUpEmailTextController.text,
          widget.model.signUpUsernameTextController.text,
          widget.model.signUpPasswordTextController.text,
          widget.model.signUpPasswordConfirmTextController.text,
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
}
