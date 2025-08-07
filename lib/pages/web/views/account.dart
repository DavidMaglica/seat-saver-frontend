import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/components/web/modals/change_email_modal.dart';
import 'package:table_reserver/components/web/modals/change_password_modal.dart';
import 'package:table_reserver/components/web/modals/change_username_modal.dart';
import 'package:table_reserver/components/web/modals/modal_widgets.dart';
import 'package:table_reserver/components/web/modals/support_modal.dart';
import 'package:table_reserver/components/web/side_nav.dart';
import 'package:table_reserver/main.dart';
import 'package:table_reserver/models/web/account_model.dart';
import 'package:table_reserver/themes/web_theme.dart';

class WebAccount extends StatefulWidget {
  const WebAccount({super.key});

  @override
  State<WebAccount> createState() => _WebAccountState();
}

class _WebAccountState extends State<WebAccount> with TickerProviderStateMixin {
  final int userId = prefsWithCache.getInt('userId')!;
  final String userName = prefsWithCache.getString('userName')!;
  final String userEmail = prefsWithCache.getString('userEmail')!;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AccountModel()..init(),
      child: Consumer<AccountModel>(
        builder: (context, model, _) {
          return Scaffold(
            key: scaffoldKey,
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: SafeArea(
              top: true,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SideNav(),
                  Expanded(
                    child:
                        Column(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildAccountDetails(context, model),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          _buildAccountActions(context, model),
                                          const SizedBox(height: 16),
                                          _buildSupport(context, model),
                                          const SizedBox(height: 32),
                                          _buildLogOut(context, model),
                                        ],
                                      ),
                                    ].divide(const SizedBox(width: 64)),
                                  ),
                                ],
                              ),
                            ),
                          ].addToEnd(const SizedBox(height: 72)),
                        ).animateOnPageLoad(
                          model.animationsMap['columnOnPageLoadAnimation']!,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAccountDetails(BuildContext context, AccountModel model) {
    return Material(
      color: Colors.transparent,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 512),
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
                  model.numberOfReservations,
                ).animateOnPageLoad(
                  model.animationsMap['containerOnPageLoadAnimation2']!,
                ),
                _buildVenuesDetails(
                  context,
                  Icons.table_restaurant_outlined,
                  'Venues owned',
                  model.venuesOwned,
                ).animateOnPageLoad(
                  model.animationsMap['containerOnPageLoadAnimation3']!,
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    ).animateOnPageLoad(model.animationsMap['containerOnPageLoadAnimation1']!);
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
                  userEmail,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 4),
                Text(userName, style: Theme.of(context).textTheme.bodyMedium),
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
    int? data,
  ) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: WebTheme.accent1, size: 44),
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

  Widget _buildAccountActions(BuildContext context, AccountModel model) {
    return Material(
      color: Colors.transparent,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child:
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 512),
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
                  context,
                  'Change Email',
                  const ChangeEmailModal(),
                ),
                _buildDivider(context),
                _buildModalButton(
                  context,
                  'Change Username',
                  const ChangeUsernameModal(),
                ),
                _buildDivider(context),
                _buildModalButton(
                  context,
                  'Change Password',
                  const ChangePasswordModal(),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ).animateOnPageLoad(
            model.animationsMap['containerOnPageLoadAnimation4']!,
          ),
    );
  }

  Widget _buildSupport(BuildContext context, AccountModel model) {
    return Material(
      color: Colors.transparent,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child:
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 512),
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
                  const SupportModal(modalType: SupportModalType.bugReport),
                ),
                _buildDivider(context),
                _buildModalButton(
                  context,
                  'Request a feature',
                  const SupportModal(
                    modalType: SupportModalType.featureRequest,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ).animateOnPageLoad(
            model.animationsMap['containerOnPageLoadAnimation1']!,
          ),
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
          builder: (_) {
            return modal;
          },
        );
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
                  Text(label, style: Theme.of(context).textTheme.bodyLarge),
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.5),
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

  Widget _buildLogOut(BuildContext context, AccountModel model) {
    return FFButtonWidget(
      onPressed: () => model.logOut(context),
      text: 'Log Out',
      options: FFButtonOptions(
        width: 130,
        height: 50,
        color: WebTheme.errorColor,
        textStyle: const TextStyle(
          color: WebTheme.offWhite,
          fontSize: 16,
          fontFamily: 'Oswald',
        ),
        elevation: 3,
        borderRadius: BorderRadius.circular(8),
      ),
    ).animateOnPageLoad(model.animationsMap['buttonOnPageLoadAnimation']!);
  }
}
