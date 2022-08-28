import 'package:delivery/generated/l10n.dart';
import 'package:flutter/gestures.dart';
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
        text: S.of(context).termsPopUp,
        style: Theme.of(context).textTheme.bodyText1,
        children: [
          TextSpan(
            text: S.of(context).termsPopUpLink,
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
              decorationColor: Colors.blue,
            ),
            recognizer: TapGestureRecognizer()..onTap = onNavigateToTermsPage,
          ),
          TextSpan(
            text: S.of(context).termsPopUpCompany,
          ),
        ],
      ),
    );
  }
}
