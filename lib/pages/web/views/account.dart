import 'package:TableReserver/components/web/side_nav.dart';
import 'package:TableReserver/components/web/support_modal.dart';
import 'package:TableReserver/models/web/account_model.dart';
import 'package:TableReserver/themes/web_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class WebAccount extends StatefulWidget {
  const WebAccount({super.key});

  static String routeName = 'Account';
  static String routePath = '/account';

  @override
  State<WebAccount> createState() => _WebAccountState();
}

class _WebAccountState extends State<WebAccount> with TickerProviderStateMixin {
  late AccountModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AccountModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        top: true,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            wrapWithModel(
              model: _model.sideNavModel,
              updateCallback: () => safeSetState(() {}),
              child: const SideNav(),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 24),
                  Flexible(
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      direction: Axis.horizontal,
                      runAlignment: WrapAlignment.center,
                      verticalDirection: VerticalDirection.down,
                      clipBehavior: Clip.none,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildAccountDetails(context),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                _buildAccountActions(context),
                                const SizedBox(height: 16),
                                _buildSupport(context),
                                const SizedBox(height: 32),
                                _buildLogOut(context),
                              ],
                            ),
                          ].divide(const SizedBox(width: 64)),
                        ),
                      ],
                    ),
                  ),
                ].addToEnd(const SizedBox(height: 72)),
              ).animateOnPageLoad(
                  _model.animationsMap['columnOnPageLoadAnimation']!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountDetails(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          maxWidth: 512,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildUserDetails(context),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildVenuesDetails(
                  context,
                  Icons.rsvp_outlined,
                  'Reservations received',
                  2200,
                ).animateOnPageLoad(
                    _model.animationsMap['containerOnPageLoadAnimation2']!),
                _buildVenuesDetails(
                  context,
                  Icons.table_restaurant_outlined,
                  'Venues owned',
                  3,
                ).animateOnPageLoad(
                    _model.animationsMap['containerOnPageLoadAnimation3']!),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    ).animateOnPageLoad(_model.animationsMap['containerOnPageLoadAnimation1']!);
  }

  Widget _buildUserDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User name',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  'user@mail.com',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withValues(alpha: 0.6),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVenuesDetails(
    BuildContext context,
    IconData icon,
    String label,
    int data,
  ) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: WebTheme.accent1,
            size: 44,
          ),
          const SizedBox(height: 8),
          Text(
            '$data',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildAccountActions(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          maxWidth: 512,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(context, 'My Account Information'),
            _buildModalButton(
              context, 'Change Email', const SizedBox(), // ChangeEmailWidget(),
            ),
            _buildDivider(context),
            _buildModalButton(
              context, 'Change Username',
              const SizedBox(), // ChangeUsernameWidget(),
            ),
            _buildDivider(context),
            _buildModalButton(
              context, 'Change Password',
              const SizedBox(), // ChangePasswordWidget(),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ).animateOnPageLoad(
          _model.animationsMap['containerOnPageLoadAnimation4']!),
    );
  }

  Widget _buildSupport(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          maxWidth: 512,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(context, 'Support'),
            _buildModalButton(
              context,
              'Submit a Bug',
              const SupportModal(modalType: ModalTypes.bugReport),
            ),
            _buildDivider(context),
            _buildModalButton(
              context,
              'Request a feature',
              const SupportModal(modalType: ModalTypes.featureRequest),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ).animateOnPageLoad(
          _model.animationsMap['containerOnPageLoadAnimation1']!),
    );
  }

  Widget _buildModalButton(BuildContext context, String label, Widget modal) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        await showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            enableDrag: false,
            context: context,
            builder: (context) {
              return modal;
            }).then((value) => safeSetState(() {}));
      },
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Expanded(
                    child: Align(
                      alignment: const AlignmentDirectional(1, 0),
                      child: Icon(
                        CupertinoIcons.chevron_forward,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 18,
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
  }

  Widget _buildTitle(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onPrimary
                  .withValues(alpha: 0.5),
            ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: Theme.of(context).colorScheme.onPrimary,
    );
  }

  Widget _buildLogOut(BuildContext context) {
    return FFButtonWidget(
      onPressed: () => _model.logOut(context),
      text: 'Log Out',
      options: FFButtonOptions(
        width: 130,
        height: 50,
        color: WebTheme.errorColor,
        textStyle: const TextStyle(
          color: Color(0xFFFFFBF4),
          fontSize: 16,
          fontFamily: 'Oswald',
        ),
        elevation: 3,
        borderRadius: BorderRadius.circular(8),
      ),
    ).animateOnPageLoad(_model.animationsMap['buttonOnPageLoadAnimation']!);
  }
}
