import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../api/account_api.dart';
import '../../api/data/basic_response.dart';
import '../../themes/theme.dart';
import '../../utils/constants.dart';
import '../../utils/data.dart';
import 'models/authentication_model.dart';

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

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AuthenticationModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
    _model.nameAndSurnameSignupTextController ??= TextEditingController();
    _model.nameAndSurnameSignupFocusNode ??= FocusNode();

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
    super.dispose();
  }

  Future<void> _login(SignupMethod? signupMethod, bool active) async {
    await Future.delayed(const Duration(seconds: 1));

    if (!active) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Currently unavailable'),
        backgroundColor: AppThemes.infoColor,
      ));
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Unknown sign up method'),
          backgroundColor: AppThemes.warningColor,
        ));
    }
  }

  Future<void> _signup(SignupMethod? signupMethod, bool active) async {
    if (!active) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Currently unavailable'),
        backgroundColor: AppThemes.infoColor,
      ));
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
            _model.nameAndSurnameSignupTextController.text,
            _model.emailAddressSignupTextController.text,
            _model.passwordSignupTextController.text,
            _model.passwordConfirmTextController.text);
        break;

      default:
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Unknown sign up method'),
          backgroundColor: AppThemes.warningColor,
        ));
    }
    return;
  }

  void _customLogin(String userEmail, String password) async {
    if (!mounted) return;

    BasicResponse response = await login(userEmail, password);

    if (response.success) {
      if (!mounted) return;
      Navigator.pushNamed(context, Routes.HOMEPAGE,
          arguments: {'userEmail': userEmail, 'location': null});
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.message),
        backgroundColor: AppThemes.errorColor,
      ));
      return;
    }
  }

  void _customSignup(
    String nameAndSurname,
    String userEmail,
    String password,
    String confirmedPassword,
  ) async {
    if (!mounted) return;

    if (password != confirmedPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Passwords do not match'),
        backgroundColor: AppThemes.errorColor,
      ));
      return;
    }

    BasicResponse response = await signup(nameAndSurname, userEmail, password);

    if (response.success) {
      if (!mounted) return;
      Navigator.pushNamed(context, Routes.HOMEPAGE,
          arguments: {'userEmail': userEmail, 'location': null});
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.message),
        backgroundColor: AppThemes.errorColor,
      ));
      return;
    }
  }

  void _forgotPassword() {
    debugPrint('Forgot password button pressed ...');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.background,
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
                      height: MediaQuery.sizeOf(context).height * .8,
                      constraints: const BoxConstraints(
                        maxWidth: 530,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
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
    String? Function(BuildContext, String?)? validator,
    bool passwordVisibility,
    int tabIndex,
  ) =>
      TextFormField(
        controller: controller,
        focusNode: focusNode,
        autofocus: true,
        autofillHints: const [AutofillHints.password],
        obscureText: !passwordVisibility,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppThemes.infoColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 1,
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
        validator: validator.asValidator(context),
      );

  TextFormField _buildRetypePasswordField() => TextFormField(
        controller: _model.passwordConfirmTextController,
        focusNode: _model.passwordConfirmFocusNode,
        autofocus: true,
        autofillHints: const [AutofillHints.password],
        obscureText: !_model.passwordConfirmVisibility,
        decoration: InputDecoration(
          labelText: 'Retype password',
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppThemes.infoColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 1,
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
        validator:
            _model.passwordConfirmTextControllerValidator.asValidator(context),
      );

  TextFormField _buildEmailField(
    TextEditingController? controller,
    FocusNode? focusNode,
    String? Function(BuildContext, String?)? validator,
  ) =>
      TextFormField(
        controller: controller,
        focusNode: focusNode,
        autofocus: true,
        autofillHints: const [AutofillHints.email],
        obscureText: false,
        decoration: InputDecoration(
          isDense: false,
          labelText: 'Email',
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppThemes.infoColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.all(24),
        ),
        style: Theme.of(context).textTheme.bodyLarge,
        keyboardType: TextInputType.emailAddress,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
        validator: validator.asValidator(context),
      );

  TextFormField _buildNameAndSurnameField(
    TextEditingController? controller,
    FocusNode? focusNode,
    String? Function(BuildContext, String?)? validator,
  ) =>
      TextFormField(
        controller: controller,
        focusNode: focusNode,
        autofocus: true,
        autofillHints: const [AutofillHints.name, AutofillHints.familyName],
        obscureText: false,
        decoration: InputDecoration(
          isDense: false,
          labelText: 'Name and Surname',
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppThemes.infoColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.all(24),
        ),
        style: Theme.of(context).textTheme.bodyLarge,
        keyboardType: TextInputType.name,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
        validator: validator.asValidator(context),
      );

  Padding _buildForgotPassword(Function() onPressed) => Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
      child: TextButton(
        onPressed: onPressed,
        child: const Text(
          'Forgot password? Reset here.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.blue, // Change to your preferred color
            decoration:
                TextDecoration.underline, // Underline to resemble a link
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
                Text(
                  'Create Account',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 24),
                  child: Text(
                    "Let's get started by filling out the form below.",
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: _buildEmailField(
                      _model.emailAddressSignupTextController,
                      _model.emailAddressSignupFocusNode,
                      _model.emailAddressSignupTextControllerValidator,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: _buildNameAndSurnameField(
                      _model.nameAndSurnameSignupTextController,
                      _model.nameAndSurnameSignupFocusNode,
                      _model.nameAndSurnameSignupTextControllerValidator,
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
                      _model.passwordSignupTextControllerValidator,
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
                  : Theme.of(context).colorScheme.surface,
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
                      _model.emailAddressLoginTextControllerValidator,
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
                      _model.passwordLoginTextControllerValidator,
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
