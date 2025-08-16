import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';
import 'package:table_reserver/models/web/side_nav_model.dart';
import 'package:table_reserver/pages/web/views/account.dart';
import 'package:table_reserver/pages/web/views/homepage.dart';
import 'package:table_reserver/pages/web/views/reservations.dart';
import 'package:table_reserver/pages/web/views/venues.dart';
import 'package:table_reserver/themes/web_theme.dart';
import 'package:table_reserver/utils/routes.dart';

class SideNav extends StatefulWidget {
  const SideNav({super.key});

  @override
  State<SideNav> createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {
  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

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
    return Consumer<SideNavModel>(
      builder: (context, model, _) {
        return Container(
          width: 270,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(context),
                _buildUserDetails(context, model),
                const Divider(
                  height: 12,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                _buildNavigation(context, model),
                _buildModeToggles(context, model),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 40,
            height: 40,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Image.asset('assets/icons/appIcon.png', fit: BoxFit.cover),
          ),
          Text(
            'Admin Dashboard',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildUserDetails(BuildContext context, SideNavModel model) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.userEmail,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontStyle: FontStyle.italic),
              ),
              Text(
                model.userName,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation(BuildContext context, SideNavModel model) {
    String? route = ModalRoute.of(context)?.settings.name;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 12),
            child: Text(
              'Platform Navigation',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          _buildDashboardButton(context, route, model),
          _buildVenuesButton(context, route, model),
          _buildReservationsButton(context, route, model),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
            child: Text(
              'Settings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          _buildAccountButton(context, route, model),
        ].divide(const SizedBox(height: 12)),
      ),
    );
  }

  Widget _buildDashboardButton(
    BuildContext context,
    String? route,
    SideNavModel model,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => model.goTo(
          context,
          WebHomepage(ownerId: model.ownerId),
          Routes.webHomepage,
        ),
        child: Material(
          color: Colors.transparent,
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            width: double.infinity,
            height: 44,
            decoration: BoxDecoration(
              color: route == Routes.webHomepage
                  ? WebTheme.successColor
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              shape: BoxShape.rectangle,
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 6, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.space_dashboard_outlined,
                    color: route == Routes.webHomepage
                        ? WebTheme.offWhite
                        : Theme.of(context).colorScheme.onPrimary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Dashboard',
                    style: TextStyle(
                      color: route == Routes.webHomepage
                          ? WebTheme.offWhite
                          : Theme.of(context).colorScheme.onPrimary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildVenuesButton(
    BuildContext context,
    String? route,
    SideNavModel model,
  ) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () =>
            model.goTo(context, const WebVenuesPage(), Routes.webVenues),
        child: Material(
          color: Colors.transparent,
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            width: double.infinity,
            height: 44,
            decoration: BoxDecoration(
              color: route == Routes.webVenues
                  ? WebTheme.successColor
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              shape: BoxShape.rectangle,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.table_restaurant_outlined,
                    color: route == Routes.webVenues
                        ? WebTheme.offWhite
                        : Theme.of(context).colorScheme.onPrimary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Venues',
                    style: TextStyle(
                      color: route == Routes.webVenues
                          ? WebTheme.offWhite
                          : Theme.of(context).colorScheme.onPrimary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildReservationsButton(
    BuildContext context,
    String? route,
    SideNavModel model,
  ) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => model.goTo(
          context,
          const WebReservations(),
          Routes.webReservations,
        ),
        child: Material(
          color: Colors.transparent,
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            width: double.infinity,
            height: 44,
            decoration: BoxDecoration(
              color: route == Routes.webReservations
                  ? WebTheme.successColor
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              shape: BoxShape.rectangle,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.rsvp_rounded,
                    color: route == Routes.webReservations
                        ? WebTheme.offWhite
                        : Theme.of(context).colorScheme.onPrimary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Reservations',
                    style: TextStyle(
                      color: route == Routes.webReservations
                          ? WebTheme.offWhite
                          : Theme.of(context).colorScheme.onPrimary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildAccountButton(
    BuildContext context,
    String? route,
    SideNavModel model,
  ) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => model.goTo(context, const WebAccount(), Routes.webAccount),
        child: Material(
          color: Colors.transparent,
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            width: double.infinity,
            height: 44,
            decoration: BoxDecoration(
              color: route == Routes.webAccount
                  ? WebTheme.successColor
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              shape: BoxShape.rectangle,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    CupertinoIcons.person,
                    color: route == Routes.webAccount
                        ? WebTheme.offWhite
                        : Theme.of(context).colorScheme.onPrimary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Account',
                    style: TextStyle(
                      color: route == Routes.webAccount
                          ? WebTheme.offWhite
                          : Theme.of(context).colorScheme.onPrimary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeToggles(BuildContext context, SideNavModel model) {
    return Align(
      alignment: const AlignmentDirectional(0, -1),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 16),
        child: Container(
          width: 250,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildLightModeButton(context, model),
                _buildDarkModeButton(context, model),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded _buildLightModeButton(BuildContext context, SideNavModel model) {
    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          model.setDarkModeSetting(context, false);
        },
        child: Container(
          width: 115,
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? WebTheme.accent1
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.sun_max,
                color: Theme.of(context).brightness == Brightness.light
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.onPrimary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Light Mode',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.onPrimary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _buildDarkModeButton(BuildContext context, SideNavModel model) {
    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          model.setDarkModeSetting(context, true);
        },
        child: Container(
          width: 115,
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? WebTheme.accent1
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.moon,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onPrimary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Dark Mode',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onPrimary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
