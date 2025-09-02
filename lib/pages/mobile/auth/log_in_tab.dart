import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/api/account_api.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/models/mobile/auth/authentication_model.dart';
import 'package:table_reserver/models/mobile/auth/login_tab_model.dart';
import 'package:table_reserver/themes/mobile_theme.dart';
import 'package:table_reserver/utils/toaster.dart';

class LogInTab extends StatefulWidget {
  final AuthenticationModel model;

  const LogInTab({super.key, required this.model});

  @override
  State<LogInTab> createState() => _LogInTabState();
}

class _LogInTabState extends State<LogInTab> {
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
      create: (_) => LogInTabModel(),
      child: Consumer<LogInTabModel>(
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
                    Text(
                      'Welcome Back',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fill out the information below in order to access your account.',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: _buildEmailField(model),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: _buildPasswordField(model),
                    ),
                    const SizedBox(height: 32),
                    _buildLogInButton(model),
                    const SizedBox(height: 16),
                    Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Text(
                        'Or log in with',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        direction: Axis.horizontal,
                        runAlignment: WrapAlignment.center,
                        verticalDirection: VerticalDirection.down,
                        clipBehavior: Clip.none,
                        children: [_buildGoogleLogInButton(model)],
                      ),
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

  Widget _buildEmailField(LogInTabModel model) {
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
        errorText: model.emailErrorText,
        errorStyle: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
            width: .5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: MobileTheme.infoColor, width: .5),
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

  Widget _buildPasswordField(LogInTabModel model) {
    return TextFormField(
      controller: widget.model.passwordLogInTextController,
      focusNode: widget.model.passwordLogInFocusNode,
      autofocus: false,
      autofillHints: const [AutofillHints.password],
      obscureText: !widget.model.passwordLogInVisibility,
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
            width: .5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: MobileTheme.infoColor, width: .5),
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

  Widget _buildLogInButton(LogInTabModel model) {
    return Align(
      child: FFButtonWidget(
        onPressed: () {
          model.logIn(
            context,
            widget.model.emailAddressLogInTextController.text,
            widget.model.passwordLogInTextController.text,
          );
        },
        text: 'Log In',
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

  Widget _buildGoogleLogInButton(LogInTabModel model) {
    return Align(
      child: FFButtonWidget(
        onPressed: () async {
          try {
            GoogleSignInAccount account = await googleSignIn.authenticate();
            model.logIn(context, account.email, account.id);
          } catch (e) {
            if (!mounted) return;
            Toaster.displayError(context, 'Google sign-in failed: $e');
          }
        },
        text: 'Log In with Google',
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
