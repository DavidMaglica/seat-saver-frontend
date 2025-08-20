import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:table_reserver/api/account_api.dart';
import 'package:table_reserver/api/data/basic_response.dart';
import 'package:table_reserver/api/data/user.dart';
import 'package:table_reserver/api/data/user_response.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/models/web/auth/authentication_model.dart';
import 'package:table_reserver/models/web/auth/log_in_tab_model.dart';
import 'package:table_reserver/pages/web/views/homepage.dart';
import 'package:table_reserver/themes/web_theme.dart';
import 'package:table_reserver/utils/fade_in_route.dart';
import 'package:table_reserver/utils/google_web/google_button_interface.dart';
import 'package:table_reserver/utils/routes.dart';
import 'package:table_reserver/utils/sign_up_methods.dart';
import 'package:table_reserver/utils/web_toaster.dart';

class LogInTab extends StatefulWidget {
  final AuthenticationModel model;

  const LogInTab({super.key, required this.model});

  @override
  State<LogInTab> createState() => _LogInTabState();
}

class _LogInTabState extends State<LogInTab> {
  late LogInTabModel _model;
  final AccountApi accountApi = AccountApi();

  @override
  void initState() {
    super.initState();
    _model = createModel(
      context,
      () => LogInTabModel(isActive: widget.model.tabBarController!.index == 1),
    );
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _performLogIn(String email, String password) async {
    BasicResponse<int?> response = await _model.logIn(
      email,
      password,
      AuthenticationMethod.custom,
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

  void _forgotPassword() {
    WebToaster.displayInfo(
      context,
      'Forgot password functionality is not implemented yet.',
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
                  _buildPasswordField(context),
                  const SizedBox(height: 32),
                  _buildLogInButton(context),
                  const SizedBox(height: 16),
                  _buildText(context),
                  const SizedBox(height: 16),
                  buildGoogleButton(),
                  const SizedBox(height: 16),
                  _buildForgotPassword(),
                ],
              ),
            ).animateOnPageLoad(
              widget.model.animationsMap['tabOnLoad']!,
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
        controller: widget.model.loginEmailTextController,
        focusNode: widget.model.loginEmailFocusNode,
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
        controller: widget.model.loginPasswordTextController,
        focusNode: widget.model.loginPasswordFocusNode,
        autofocus: false,
        obscureText: !widget.model.loginPasswordVisibility,
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
              () => widget.model.loginPasswordVisibility =
                  !widget.model.loginPasswordVisibility,
            ),
            focusNode: FocusNode(skipTraversal: true),
            child: Icon(
              widget.model.loginPasswordVisibility
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

  Widget _buildLogInButton(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: FFButtonWidget(
        onPressed: () => _performLogIn(
          widget.model.loginEmailTextController.text,
          widget.model.loginPasswordTextController.text,
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
