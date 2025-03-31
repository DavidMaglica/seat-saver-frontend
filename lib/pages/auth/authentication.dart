import 'package:TableReserver/utils/toaster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../api/account_api.dart';
import '../../api/data/basic_response.dart';
import '../../themes/theme.dart';
import '../../utils/constants.dart';
import 'models/authentication_model.dart';
import 'signup_methods.dart';

export 'models/authentication_model.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication>
    with TickerProviderStateMixin {
  late AuthenticationModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  AccountApi accountApi = AccountApi();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AuthenticationModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
    _model.usernameSignupTextController ??= TextEditingController();
    _model.usernameSignupFocusNode ??= FocusNode();

    _model.emailAddressSignupTextController ??= TextEditingController();
    _model.emailAddressSignupFocusNode ??= FocusNode();

    _model.passwordSignupTextController ??= TextEditingController();
    _model.passwordSignupFocusNode ??= FocusNode();

    _model.passwordConfirmTextController ??= TextEditingController();
    _model.passwordConfirmFocusNode ??= FocusNode();

    _model.emailAddressLoginTextController ??= TextEditingController();
    _model.emailAddressLoginFocusNode ??= FocusNode();

    _model.passwordLoginTextController ??= TextEditingController();
    _model.passwordLoginFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    super.dispose();
  }

  Future<void> _login(SignupMethod? signupMethod, bool active) async {
    await Future.delayed(const Duration(seconds: 1));

    if (!active) {
      if (!mounted) return;
      Toaster.displayInfo(context, 'Currently unavailable');
      return;
    }

    switch (signupMethod) {
      case SignupMethod.apple:
        break;

      case SignupMethod.google:
        break;

      case SignupMethod.custom:
        _customLogin(
          _model.emailAddressLoginTextController.text,
          _model.passwordLoginTextController.text,
        );
        break;

      default:
        if (!mounted) return;
        Toaster.displayWarning(context, 'Unknown sign up method');
    }
  }

  Future<void> _signup(SignupMethod? signupMethod, bool active) async {
    if (!active) {
      if (!mounted) return;
      Toaster.displayInfo(context, 'Currently unavailable');
      return;
    }

    await Future.delayed(const Duration(seconds: 1));

    switch (signupMethod) {
      case SignupMethod.apple:
        break;

      case SignupMethod.google:
        break;

      case SignupMethod.custom:
        _customSignup(
            _model.usernameSignupTextController.text,
            _model.emailAddressSignupTextController.text,
            _model.passwordSignupTextController.text,
            _model.passwordConfirmTextController.text);
        break;

      default:
        if (!mounted) return;
        Toaster.displayWarning(context, 'Unknown sign up method');
    }
    return;
  }

  void _customLogin(String userEmail, String password) async {
    if (!mounted) return;

    BasicResponse response = await accountApi.login(userEmail, password);

    if (response.success) {
      _goToHomepage(userEmail);
    } else {
      if (!mounted) return;
      Toaster.displayError(context, response.message);
      return;
    }
  }

  void _customSignup(
    String username,
    String userEmail,
    String password,
    String confirmedPassword,
  ) async {
    if (!mounted) return;
    RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (password.length < 8) {
      Toaster.displayError(
          context, 'Password must be at least 8 characters long');
      return;
    }

    if (password != confirmedPassword) {
      Toaster.displayError(context, 'Passwords do not match');
      return;
    }

    if (!emailRegex.hasMatch(userEmail)) {
      Toaster.displayError(context, 'Invalid email address');
      return;
    }

    BasicResponse response =
        await accountApi.signup(username, userEmail, password);

    debugPrint(response.message);
    if (response.success) {
      _goToHomepage(userEmail);
    } else {
      if (!mounted) return;
      Toaster.displayError(context, response.message);
      return;
    }
  }

  void _forgotPassword() {
    Toaster.displayInfo(context, 'Not implemented yet');
  }

  void _goToHomepage(String userEmail) =>
      Navigator.pushNamed(context, Routes.HOMEPAGE,
          arguments: {'userEmail': userEmail, 'userLocation': null});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.sizeOf(context).height,
                      constraints: const BoxConstraints(
                        maxWidth: 530,
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                        child: Column(
                          children: [
                            Expanded(
                              child: TabBarView(
                                controller: _model.tabBarController,
                                children: [
                                  _buildSignupTab(),
                                  _buildLoginTab(),
                                ],
                              ),
                            ),
                            MediaQuery.of(context).viewInsets.bottom == 0
                                ? Padding(
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                            horizontal: 0, vertical: 36),
                                    child: CupertinoButton(
                                        child: const Text(
                                          'Continue without account.',
                                          style: TextStyle(
                                            color: AppThemes.infoColor,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                        onPressed: () => Navigator.pushNamed(
                                                context, Routes.HOMEPAGE,
                                                arguments: {
                                                  'userEmail': null,
                                                  'userLocation': null
                                                })),
                                  )
                                : const SizedBox(),
                            Align(
                              alignment: const Alignment(0, 0),
                              child: TabBar(
                                labelColor:
                                    Theme.of(context).colorScheme.primary,
                                unselectedLabelColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                labelStyle:
                                    Theme.of(context).textTheme.titleSmall,
                                unselectedLabelStyle:
                                    Theme.of(context).textTheme.titleSmall,
                                indicatorColor:
                                    Theme.of(context).colorScheme.primary,
                                indicatorWeight: 3,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 16, 0),
                                tabs: const [
                                  Tab(text: 'Create Account'),
                                  Tab(text: 'Log In'),
                                ],
                                controller: _model.tabBarController,
                                onTap: (i) async {
                                  SystemChannels.textInput
                                      .invokeMethod('TextInput.hide');
                                  [() async {}, () async {}][i]();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildPasswordField(
    TextEditingController? controller,
    FocusNode? focusNode,
    bool passwordVisibility,
    int tabIndex,
  ) =>
      TextFormField(
        controller: controller,
        focusNode: focusNode,
        autofocus: false,
        autofillHints: const [AutofillHints.password],
        obscureText: !passwordVisibility,
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
              () => tabIndex == 0
                  ? _model.passwordSignupVisibility = !passwordVisibility
                  : _model.passwordLoginVisibility = !passwordVisibility,
            ),
            focusNode: FocusNode(skipTraversal: true),
            child: Icon(
              (passwordVisibility)
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

  TextFormField _buildRetypePasswordField() => TextFormField(
        controller: _model.passwordConfirmTextController,
        focusNode: _model.passwordConfirmFocusNode,
        autofocus: false,
        autofillHints: const [AutofillHints.password],
        obscureText: !_model.passwordConfirmVisibility,
        decoration: InputDecoration(
          labelText: 'Retype password',
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
              () => _model.passwordConfirmVisibility =
                  !_model.passwordConfirmVisibility,
            ),
            focusNode: FocusNode(skipTraversal: true),
            child: Icon(
              _model.passwordConfirmVisibility
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

  TextFormField _buildEmailField(
    TextEditingController? controller,
    FocusNode? focusNode,
  ) =>
      TextFormField(
        controller: controller,
        focusNode: focusNode,
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

  TextFormField _buildUsernameField(
    TextEditingController? controller,
    FocusNode? focusNode,
  ) =>
      TextFormField(
        controller: controller,
        focusNode: focusNode,
        autofocus: false,
        autofillHints: const [AutofillHints.name, AutofillHints.familyName],
        obscureText: false,
        decoration: InputDecoration(
          isDense: false,
          labelText: 'Username',
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
        keyboardType: TextInputType.name,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
      );

  Padding _buildForgotPassword(Function() onPressed) => Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
      child: TextButton(
        onPressed: onPressed,
        child: const Text(
          'Forgot password? Reset here.',
          style: TextStyle(
            fontSize: 12,
            color: AppThemes.infoColor,
            decoration: TextDecoration.underline,
          ),
        ),
      ));

  Align _buildSignupTab() => Align(
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
                  const SizedBox(width: 230, height: 16),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 24),
                  child: Text(
                    'Create Account',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: _buildEmailField(
                      _model.emailAddressSignupTextController,
                      _model.emailAddressSignupFocusNode,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: _buildUsernameField(
                      _model.usernameSignupTextController,
                      _model.usernameSignupFocusNode,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: _buildPasswordField(
                      _model.passwordSignupTextController,
                      _model.passwordSignupFocusNode,
                      _model.passwordSignupVisibility,
                      _model.tabBarCurrentIndex,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: _buildRetypePasswordField(),
                  ),
                ),
                _buildButton(
                  'Sign up',
                  null,
                  _signup,
                  SignupMethod.custom,
                  true,
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Text(
                        'Or sign up with',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 0,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          direction: Axis.horizontal,
                          runAlignment: WrapAlignment.center,
                          verticalDirection: VerticalDirection.down,
                          clipBehavior: Clip.none,
                          children: [
                            _buildButton(
                              'Continue with Google',
                              const Icon(
                                FontAwesomeIcons.google,
                                size: 16,
                              ),
                              _signup,
                              SignupMethod.google,
                              false,
                            ),
                            _buildButton(
                              'Continue with Apple',
                              const Icon(
                                Icons.apple,
                                size: 24,
                              ),
                              _signup,
                              SignupMethod.apple,
                              false,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Align _buildButton(
          String text,
          Icon? icon,
          Function(SignupMethod?, bool)? onPressed,
          SignupMethod? signupMethod,
          bool active) =>
      Align(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
          child: FFButtonWidget(
            onPressed: onPressed != null
                ? () => onPressed(signupMethod, active)
                : null,
            text: text,
            icon: icon,
            options: FFButtonOptions(
              width: 270,
              height: 50,
              color: active
                  ? icon != null
                      ? Theme.of(context).colorScheme.background
                      : Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceVariant,
              textStyle: TextStyle(
                color: active
                    ? icon != null
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.background
                    : Theme.of(context).colorScheme.onSurface.withOpacity(.3),
                fontSize: 18,
              ),
              borderSide: icon != null
                  ? BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary,
                      width: 1,
                    )
                  : BorderSide.none,
              elevation: active ? 3 : 0,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );

  Align _buildLoginTab() => Align(
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
                    child: _buildEmailField(
                      _model.emailAddressLoginTextController,
                      _model.emailAddressLoginFocusNode,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 32),
                  child: SizedBox(
                    width: double.infinity,
                    child: _buildPasswordField(
                      _model.passwordLoginTextController,
                      _model.passwordLoginFocusNode,
                      _model.passwordLoginVisibility,
                      _model.tabBarCurrentIndex,
                    ),
                  ),
                ),
                _buildButton('Log in', null, _login, SignupMethod.custom, true),
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
                      _buildButton(
                        'Log in with Google',
                        const Icon(
                          FontAwesomeIcons.google,
                          size: 16,
                        ),
                        _login,
                        SignupMethod.google,
                        false,
                      ),
                      _buildButton(
                          'Log in with Apple',
                          const Icon(
                            Icons.apple,
                            size: 24,
                          ),
                          _login,
                          SignupMethod.apple,
                          false),
                    ],
                  ),
                ),
                Align(
                  child: _buildForgotPassword(_forgotPassword),
                ),
              ],
            ),
          ),
        ),
      );
}
