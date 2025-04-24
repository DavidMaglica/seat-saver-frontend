import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../components/custom_appbar.dart';
import '../../utils/constants.dart';

class TermsOfService extends StatefulWidget {
  final String? userEmail;
  final Position? userLocation;

  const TermsOfService({
    Key? key,
    this.userEmail,
    this.userLocation,
  }) : super(key: key);

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
          onBack: () => Navigator.of(context).pushNamed(Routes.ACCOUNT,
              arguments: {
                'userEmail': widget.userEmail,
                'userLocation': widget.userLocation
              }),
        ),
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          top: true,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildBodyText(
                        'Please read these terms of service carefully.'),
                    _buildDivider(),
                    _buildSection('Acceptance of Terms',
                        'By accessing or using the app, you agree to be bound by these terms of service. If you do not agree to these terms, you may not use the app.'),
                    _buildDivider(),
                    _buildSection('Use of the App',
                        'You may use the app for your personal, non-commercial use only. You may not use the app for any illegal or unauthorized purpose.'),
                    _buildDivider(),
                    _buildSection('Intellectual Property',
                        'The app and its original content, features, and functionality are owned by us and are protected by international copyright, trademark, patent, trade secret, and other intellectual property or proprietary rights laws.'),
                    _buildDivider(),
                    _buildSection('User Content',
                        'You retain ownership of any content you submit to the app. By submitting content, you grant us a worldwide, non-exclusive, royalty-free license to use, reproduce, modify, adapt, publish, translate, distribute, and display such content in any media.'),
                    _buildDivider(),
                    _buildSection('Limitation of Liability',
                        'We shall not be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses.'),
                    _buildDivider(),
                    _buildSection('Governing Law',
                        'These terms of service shall be governed by and construed in accordance with the laws of the jurisdiction in which we operate.'),
                    _buildDivider(),
                    _buildSection('Changes to Terms of Service',
                        'We reserve the right to modify or replace these terms of service at any time. Your continued use of the app after any such changes constitutes your acceptance of the new terms.'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Divider _buildDivider() => Divider(
        thickness: .3,
        color: Theme.of(context).colorScheme.onBackground,
      );

  Padding _buildBodyText(String text) => Padding(
        padding: const EdgeInsetsDirectional.only(bottom: 8),
        child: Text(text,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center),
      );

  Padding _buildSection(String title, String bodyText) => Padding(
        padding: const EdgeInsetsDirectional.only(top: 12, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(bodyText,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center)
          ],
        ),
      );
}
