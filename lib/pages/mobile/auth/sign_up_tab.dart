import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/api/account_api.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/models/mobile/auth/authentication_model.dart';
import 'package:table_reserver/models/mobile/auth/signup_tab_model.dart';
import 'package:table_reserver/themes/mobile_theme.dart';
import 'package:table_reserver/utils/logger.dart';
import 'package:table_reserver/utils/toaster.dart';

class SignUpTab extends StatefulWidget {
  final AuthenticationModel model;

  const SignUpTab({super.key, required this.model});

  @override
  State<SignUpTab> createState() => _SignUpTabState();
}

class _SignUpTabState extends State<SignUpTab> with TickerProviderStateMixin {
  final AccountApi accountApi = AccountApi();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpTabModel(),
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
                    const SizedBox(height: 20),
                    Text(
                      key: const Key('createAccountText'),
                      'Create Account',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: _buildEmailField(model),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: _buildUsernameField(model),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: _buildPasswordField(model),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: _buildRetypePasswordField(model),
                    ),
                    const SizedBox(height: 16),
                    _buildSignUpButton(model),
                    const SizedBox(height: 16),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Text(
                            key: const Key('orSignUpWithText'),
                            'Or sign up with',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Wrap(
                            spacing: 16,
                            runSpacing: 0,
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            direction: Axis.horizontal,
                            runAlignment: WrapAlignment.center,
                            verticalDirection: VerticalDirection.down,
                            clipBehavior: Clip.none,
                            children: [_buildGoogleSignUpButton(model)],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmailField(SignUpTabModel model) {
    return TextFormField(
      key: const Key('emailSignUpField'),
      controller: widget.model.emailAddressSignUpTextController,
      focusNode: widget.model.emailAddressSignUpFocusNode,
      autofocus: false,
      autofillHints: const [AutofillHints.email],
      obscureText: false,
      decoration: InputDecoration(
        isDense: false,
        labelText: 'Email',
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        errorText: model.emailErrorText,
        errorStyle: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: MobileTheme.infoColor),
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
    );
  }

  Widget _buildUsernameField(SignUpTabModel model) {
    return TextFormField(
      key: const Key('usernameSignUpField'),
      controller: widget.model.usernameSignUpTextController,
      focusNode: widget.model.usernameSignUpFocusNode,
      autofocus: false,
      autofillHints: const [AutofillHints.name, AutofillHints.familyName],
      obscureText: false,
      decoration: InputDecoration(
        isDense: false,
        labelText: 'Username',
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        errorText: model.usernameErrorText,
        errorStyle: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: MobileTheme.infoColor),
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
      keyboardType: TextInputType.name,
      cursorColor: Theme.of(context).colorScheme.onPrimary,
    );
  }

  Widget _buildPasswordField(SignUpTabModel model) {
    return TextFormField(
      key: const Key('passwordSignUpField'),
      controller: widget.model.passwordSignUpTextController,
      focusNode: widget.model.passwordSignUpFocusNode,
      autofocus: false,
      autofillHints: const [AutofillHints.password],
      obscureText: !widget.model.passwordSignUpVisibility,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        errorText: model.passwordErrorText,
        errorStyle: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: MobileTheme.infoColor, width: .5),
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
          onTap: () => setState(
            () => widget.model.passwordSignUpVisibility =
                !widget.model.passwordSignUpVisibility,
          ),
          focusNode: FocusNode(skipTraversal: true),
          child: Icon(
            (widget.model.passwordSignUpVisibility)
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

  Widget _buildRetypePasswordField(SignUpTabModel model) {
    return TextFormField(
      key: const Key('retypePasswordField'),
      controller: widget.model.passwordConfirmTextController,
      focusNode: widget.model.passwordConfirmFocusNode,
      autofocus: false,
      autofillHints: const [AutofillHints.password],
      obscureText: !widget.model.passwordConfirmVisibility,
      decoration: InputDecoration(
        labelText: 'Retype password',
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        errorText: model.confirmPasswordErrorText,
        errorStyle: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: MobileTheme.infoColor, width: .5),
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
          onTap: () => setState(
            () => widget.model.passwordConfirmVisibility =
                !widget.model.passwordConfirmVisibility,
          ),
          focusNode: FocusNode(skipTraversal: true),
          child: Icon(
            widget.model.passwordConfirmVisibility
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

  Widget _buildSignUpButton(SignUpTabModel model) {
    return Align(
      child: FFButtonWidget(
        key: const Key('signUpButton'),
        onPressed: () {
          logger.i('Sign up button pressed');
          model.signUp(
            context,
            widget.model.emailAddressSignUpTextController.text,
            widget.model.usernameSignUpTextController.text,
            widget.model.passwordSignUpTextController.text,
            widget.model.passwordConfirmTextController.text,
          );
        },
        text: 'Sign up',
        options: FFButtonOptions(
          width: 270,
          height: 50,
          color: MobileTheme.successColor,
          textStyle: const TextStyle(color: Colors.white, fontSize: 18),
          borderSide: BorderSide.none,
          elevation: 3,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildGoogleSignUpButton(SignUpTabModel model) {
    return Align(
      child: FFButtonWidget(
        key: const Key('googleSignUpButton'),
        onPressed: () async {
          try {
            GoogleSignInAccount account = await googleSignIn.authenticate();
            model.signUp(
              context,
              account.email,
              account.displayName ?? account.email,
              account.id,
              account.id,
            );
          } catch (e) {
            if (!mounted) return;
            Toaster.displayError(context, 'Google sign-in failed: $e');
          }
        },
        text: 'Sign Up with Google',
        icon: const Icon(FontAwesomeIcons.google, size: 16),
        options: FFButtonOptions(
          width: 270,
          height: 50,
          color: MobileTheme.infoColor,
          textStyle: const TextStyle(color: MobileTheme.offWhite, fontSize: 18),
          elevation: 3,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
