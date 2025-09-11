import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';
import 'package:seat_saver/api/account_api.dart';
import 'package:seat_saver/models/web/auth/authentication_model.dart';
import 'package:seat_saver/models/web/auth/sign_up_tab_model.dart';
import 'package:seat_saver/themes/web_theme.dart';
import 'package:seat_saver/utils/google_web/google_button_interface.dart';
import 'package:seat_saver/utils/sign_up_methods.dart';

class SignUpTab extends StatefulWidget {
  final AuthenticationModel model;

  const SignUpTab({super.key, required this.model});

  @override
  State<SignUpTab> createState() => _SignUpTabState();
}

class _SignUpTabState extends State<SignUpTab> {
  final AccountApi accountApi = AccountApi();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          SignUpTabModel(isActive: widget.model.tabBarController!.index == 0)
            ..init(context),
      child: Consumer<SignUpTabModel>(
        builder: (context, model, _) {
          return Align(
            alignment: const AlignmentDirectional(0, -1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildTitle(context),
                    const SizedBox(height: 32),
                    _buildEmailField(context, model),
                    const SizedBox(height: 16),
                    _buildUsernameField(context, model),
                    const SizedBox(height: 16),
                    _buildPasswordField(context, model),
                    const SizedBox(height: 16),
                    _buildConfirmPasswordField(context, model),
                    const SizedBox(height: 32),
                    _buildSignUpButton(context, model),
                    const SizedBox(height: 16),
                    _buildText(context),
                    const SizedBox(height: 16),
                    buildGoogleButton(),
                  ],
                ),
              ).animateOnPageLoad(widget.model.animationsMap['tabOnLoad']!),
            ),
          );
        },
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

  Widget _buildEmailField(BuildContext context, SignUpTabModel model) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        key: const Key('signUpEmailField'),
        controller: widget.model.signUpEmailTextController,
        focusNode: widget.model.signUpEmailFocusNode,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          errorText: model.emailErrorText,
          errorStyle: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontSize: 12,
          ),
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
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
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

  Widget _buildUsernameField(BuildContext context, SignUpTabModel model) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        key: const Key('signUpUsernameField'),
        controller: widget.model.signUpUsernameTextController,
        focusNode: widget.model.signUpUsernameFocusNode,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'Username',
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          errorText: model.usernameErrorText,
          errorStyle: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontSize: 12,
          ),
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
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
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

  Widget _buildPasswordField(BuildContext context, SignUpTabModel model) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        key: const Key('signUpPasswordField'),
        controller: widget.model.signUpPasswordTextController,
        focusNode: widget.model.signUpPasswordFocusNode,
        autofocus: false,
        obscureText: !widget.model.signUpPasswordVisibility,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          errorText: model.passwordErrorText,
          errorStyle: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontSize: 12,
          ),
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
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
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

  Widget _buildConfirmPasswordField(
    BuildContext context,
    SignUpTabModel model,
  ) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        key: const Key('signUpConfirmPasswordField'),
        controller: widget.model.signUpPasswordConfirmTextController,
        focusNode: widget.model.signUpPasswordConfirmFocusNode,
        autofocus: false,
        obscureText: !widget.model.signUpPasswordConfirmVisibility,
        decoration: InputDecoration(
          labelText: 'Confirm password',
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          errorText: model.confirmPasswordErrorText,
          errorStyle: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontSize: 12,
          ),
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
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
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

  Widget _buildSignUpButton(BuildContext context, SignUpTabModel model) {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: FFButtonWidget(
        key: const Key('signUpButton'),
        onPressed: () {
          model.signUp(
            context: context,
            username: widget.model.signUpUsernameTextController.text,
            email: widget.model.signUpEmailTextController.text,
            password: widget.model.signUpPasswordTextController.text,
            confirmedPassword:
                widget.model.signUpPasswordConfirmTextController.text,
            authMethod: AuthenticationMethod.custom,
          );
        },
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
