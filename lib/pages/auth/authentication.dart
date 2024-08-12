import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../themes/theme.dart';
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
                      height: MediaQuery.sizeOf(context).height * 0.8,
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

  Future<String> _login(SignupMethod? signupMethod) async {
    switch (signupMethod) {
      case SignupMethod.apple:
        debugPrint('Apple log in button pressed ...');
        Navigator.pushNamed(context, '/landing');
        break;
      case SignupMethod.google:
        debugPrint('Google log in button pressed ...');
        Navigator.pushNamed(context, '/landing');
        break;
      case SignupMethod.custom:
        debugPrint('Custom log in button pressed ...');
        Navigator.pushNamed(context, '/landing');
        break;
      default:
        debugPrint('Log in button pressed ...');
    }
    return '';
  }

  Future<String> _signup(SignupMethod? signupMethod) async {
    switch (signupMethod) {
      case SignupMethod.apple:
        debugPrint('Apple sign up button pressed ...');
        Navigator.pushNamed(context, '/landing');
        break;
      case SignupMethod.google:
        debugPrint('Google sign up button pressed ...');
        Navigator.pushNamed(context, '/landing');
        break;
      case SignupMethod.custom:
        debugPrint('Custom sign up button pressed ...');
        Navigator.pushNamed(context, '/landing');
        break;
      default:
        debugPrint('Sign up button pressed ...');
    }
    return '';
  }

  void _forgotPassword() {
    debugPrint('Forgot password button pressed ...');
  }

  Widget _buildPasswordField(
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
        obscureText: tabIndex == 0
            ? _model.passwordSignupVisibility
            : _model.passwordLoginVisibility,
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
                  ? _model.passwordSignupVisibility =
                      !_model.passwordSignupVisibility
                  : _model.passwordLoginVisibility =
                      !_model.passwordLoginVisibility,
            ),
            focusNode: FocusNode(skipTraversal: true),
            child: Icon(
              (tabIndex == 0
                      ? _model.passwordSignupVisibility
                      : _model.passwordLoginVisibility)
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

  Widget _buildRetypePasswordField() => TextFormField(
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

  Widget _buildEmailField(
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

  Widget _buildForgotPassword(Function() onPressed) => Padding(
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

  Widget _buildSignupTab() => Align(
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
                            ),
                            _buildButton(
                              'Continue with Apple',
                              const Icon(
                                Icons.apple,
                                size: 24,
                              ),
                              _signup,
                              SignupMethod.apple,
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

  Widget _buildLoginTab() => Align(
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
                        _model.tabBarCurrentIndex),
                  ),
                ),
                _buildButton('Log in', null, _login, SignupMethod.custom),
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
                          SignupMethod.google),
                      _buildButton(
                          'Log in with Apple',
                          const Icon(
                            Icons.apple,
                            size: 24,
                          ),
                          _login,
                          SignupMethod.apple),
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

  Widget _buildButton(String text, Icon? icon,
          Function(SignupMethod?)? onPressed, SignupMethod? signupMethod) =>
      Align(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
          child: FFButtonWidget(
            onPressed: onPressed != null ? () => onPressed(signupMethod) : null,
            text: text,
            icon: icon,
            options: FFButtonOptions(
              width: 270,
              height: 50,
              color: icon != null
                  ? Theme.of(context).colorScheme.background
                  : Theme.of(context).colorScheme.primary,
              textStyle: TextStyle(
                color: icon != null
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.background,
                fontSize: 18,
              ),
              borderSide: icon != null
                  ? BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary,
                      width: 1,
                    )
                  : BorderSide.none,
              elevation: 3,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
}
