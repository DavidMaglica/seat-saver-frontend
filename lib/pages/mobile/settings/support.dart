import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';
import 'package:seat_saver/components/mobile/action_button.dart';
import 'package:seat_saver/components/mobile/custom_appbar.dart';
import 'package:seat_saver/components/mobile/modal_widgets.dart';
import 'package:seat_saver/components/mobile/support_banner.dart';
import 'package:seat_saver/models/mobile/views/support_model.dart';
import 'package:seat_saver/pages/mobile/views/account.dart';
import 'package:seat_saver/themes/mobile_theme.dart';
import 'package:seat_saver/utils/fade_in_route.dart';
import 'package:seat_saver/utils/routes.dart';

class Support extends StatelessWidget {
  final int userId;
  final SupportModel? modelOverride;

  const Support({super.key, required this.userId, this.modelOverride});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => modelOverride ?? SupportModel(userId: userId)
        ..init(context),
      child: Consumer<SupportModel>(
        builder: (context, model, _) {
          return GestureDetector(
            onTap: () => model.unfocusNode.canRequestFocus
                ? FocusScope.of(context).requestFocus(model.unfocusNode)
                : FocusScope.of(context).unfocus(),
            child: Scaffold(
              key: model.scaffoldKey,
              backgroundColor: Theme.of(context).colorScheme.surface,
              appBar: CustomAppbar(
                title: 'Support',
                onBack: () {
                  Navigator.of(context).push(
                    MobileFadeInRoute(
                      page: const Account(),
                      routeName: Routes.account,
                    ),
                  );
                },
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.symmetric(
                            vertical: 36,
                          ),
                          child: Text(
                            key: const Key('descriptionText'),
                            'Have you encountered an issue with the application? Search for answers in our FAQs or submit a ticket in the form below to contact us.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                key: const Key('openFAQsButton'),
                                onTap: () => model.openFAQs(context),
                                child: const SupportBanner(
                                  title: 'Search FAQs',
                                  icon: CupertinoIcons.search_circle_fill,
                                ),
                              ),
                            ),
                          ].divide(const SizedBox(width: 12)),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(top: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                  thickness: 1,
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'OR',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                bottom: 12,
                              ),
                              child: Text(
                                'Submit a Ticket',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            _buildInputField(
                              context,
                              'ticketTitleField',
                              model.ticketTitleController,
                              model.ticketTitleFocusNode,
                              'Ticket title',
                              'Enter a title for your ticket.',
                              null,
                              null,
                            ),
                            _buildInputField(
                              context,
                              'ticketDescriptionField',
                              model.ticketDescriptionController,
                              model.ticketDescriptionFocusNode,
                              'Short description',
                              'Short description of what is going on...',
                              16,
                              6,
                            ),
                          ].divide(const SizedBox(height: 12)),
                        ),
                        const SizedBox(height: 24),
                        ActionButton(
                          keyName: 'submitTicketButton',
                          title: 'Submit Ticket',
                          onPressed: () => model.submitTicket(context),
                          iconData: CupertinoIcons.paperplane_fill,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField(BuildContext context,
      String key,
    TextEditingController? controller,
    FocusNode? focusNode,
    String labelText,
    String hintText,
    int? maxLines,
    int? minLines,
  ) {
    return TextFormField(
      key: Key(key),
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.bodyLarge,
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium,
        enabledBorder: outlineInputBorder(
          Theme.of(context).colorScheme.onPrimary,
        ),
        focusedBorder: outlineInputBorder(MobileTheme.infoColor),
        errorBorder: outlineInputBorder(Theme.of(context).colorScheme.error),
        focusedErrorBorder: outlineInputBorder(MobileTheme.infoColor),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      style: Theme.of(context).textTheme.bodyLarge,
      maxLines: maxLines,
      minLines: minLines,
      cursorColor: Theme.of(context).colorScheme.onPrimary,
    );
  }
}
