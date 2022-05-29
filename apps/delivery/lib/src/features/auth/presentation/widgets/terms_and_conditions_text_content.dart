import 'package:delivery/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class TermsAndConditionsTextContent extends StatelessWidget {
  final VoidCallback onNavigateToTermsPage;

  @literal
  const TermsAndConditionsTextContent({
    Key? key,
    required this.onNavigateToTermsPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      softWrap: true,
      text: TextSpan(
        text: context.l10n.termsPopUp,
        style: Theme.of(context).textTheme.bodyText1,
        children: [
          TextSpan(
              text: context.l10n.termsPopUpLink,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                decorationColor: Colors.blue,
              ),
              recognizer: null
              //TapGestureRecognizer.onTap = onNavigateToTermsPage,
              ),
          TextSpan(
            text: context.l10n.termsPopUpCompany,
          ),
        ],
      ),
    );
  }
}
