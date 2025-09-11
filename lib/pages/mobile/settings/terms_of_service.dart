import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:seat_saver/components/mobile/custom_appbar.dart';
import 'package:seat_saver/pages/mobile/views/account.dart';
import 'package:seat_saver/utils/fade_in_route.dart';
import 'package:seat_saver/utils/routes.dart';

class TermsOfService extends StatefulWidget {
  final int? userId;
  final Position? userLocation;

  const TermsOfService({super.key, this.userId, this.userLocation});

  @override
  State<TermsOfService> createState() => _TermsOfServiceState();
}

class _TermsOfServiceState extends State<TermsOfService> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppbar(
          title: 'Terms of Service',
          onBack: () {
            Navigator.of(context).push(
              MobileFadeInRoute(
                page: const Account(),
                routeName: Routes.account,
              ),
            );
          },
        ),
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildBodyText(
                      'titleText',
                      'Please read these terms of service carefully.',
                    ),
                    _buildDivider(),
                    _buildSection(
                      'acceptanceTitle',
                      'Acceptance of Terms',
                      'acceptanceBody',
                      'By accessing or using the app, you agree to be bound by these terms of service. If you do not agree to these terms, you may not use the app.',
                    ),
                    _buildDivider(),
                    _buildSection(
                      'useOfAppTitle',
                      'Use of the App',
                      'useOfAppBody',
                      'You may use the app for your personal, non-commercial use only. You may not use the app for any illegal or unauthorized purpose.',
                    ),
                    _buildDivider(),
                    _buildSection(
                      'intellectualPropertyTitle',
                      'Intellectual Property',
                      'intellectualPropertyBody',
                      'The app and its original content, features, and functionality are owned by us and are protected by international copyright, trademark, patent, trade secret, and other intellectual property or proprietary rights laws.',
                    ),
                    _buildDivider(),
                    _buildSection(
                      'userContentTitle',
                      'User Content',
                      'userContentBody',
                      'You retain ownership of any content you submit to the app. By submitting content, you grant us a worldwide, non-exclusive, royalty-free license to use, reproduce, modify, adapt, publish, translate, distribute, and display such content in any media.',
                    ),
                    _buildDivider(),
                    _buildSection(
                      'limitationOfLiabilityTitle',
                      'Limitation of Liability',
                      'limitationOfLiabilityBody',
                      'We shall not be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses.',
                    ),
                    _buildDivider(),
                    _buildSection(
                      'governingLawTitle',
                      'Governing Law',
                      'governingLawBody',
                      'These terms of service shall be governed by and construed in accordance with the laws of the jurisdiction in which we operate.',
                    ),
                    _buildDivider(),
                    _buildSection(
                      'changesToTermsTitle',
                      'Changes to Terms of Service',
                      'changesToTermsBody',
                      'We reserve the right to modify or replace these terms of service at any time. Your continued use of the app after any such changes constitutes your acceptance of the new terms.',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      thickness: 0.3,
      color: Theme.of(context).colorScheme.onPrimary,
    );
  }

  Widget _buildBodyText(String key, String text) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 8),
      child: Text(
        key: Key(key),
        text,
        style: Theme.of(context).textTheme.bodyLarge,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSection(
    String titleKey,
    String title,
    String bodyKey,
    String bodyText,
  ) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 12, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            key: Key(titleKey),
            title,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            key: Key(bodyKey),
            bodyText,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
