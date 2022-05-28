import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/utils/app_config.dart';
import 'package:delivery/src/core/utils/screen_adaptive_utils.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/auth_popup_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/cart_appbar_button.dart';
import 'package:delivery/src/features/home/presentation/widgets/home_page_template.dart';
import 'package:delivery/src/features/home/presentation/widgets/page_body_template.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StripeCheckoutFailurePage extends HookConsumerWidget {
  const StripeCheckoutFailurePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());

    if (shouldUseMobileLayout(context)) {
      return Scaffold(
        appBar: AppBar(
          leading: CloseButton(
            onPressed: null,
          ),
        ),
        body: const _Body(),
      );
    } else {
      return HomePageTemplate(
        scaffoldKey: scaffoldKey,
        appBarActions: [
          const CartAppbarButton(),
          AuthPopupButton(scaffoldKey: scaffoldKey),
        ],
        body: const PageBodyTemplate(child: _Body()),
      );
    }
  }
}

class _Body extends ConsumerWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        alignment: AlignmentDirectional.center,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        height: AppConfig(context.l10n.appHeight(60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                      ])),
                  child: Icon(
                    Icons.clear,
                    color: Theme.of(context).primaryColor,
                    size: 70,
                  ),
                ),
                Positioned(
                  right: -30,
                  bottom: -50,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(150),
                    ),
                  ),
                ),
                Positioned(
                  left: -20,
                  top: -50,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(150),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            Opacity(
              opacity: 0.8,
              child: Text(
                context.l10n.orderNotCompletedAndPaid,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            const SizedBox(height: 20.0),
            Opacity(
              opacity: 0.8,
              child: Text(
                context.l10n.checkoutFailure,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 20.0),
              ),
            ),
            const SizedBox(height: 50),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                primary: Theme.of(context).colorScheme.secondary,
                shape: const StadiumBorder(),
              ),
              onPressed: () {},
              child: Text(context.l10n.start_shopping),
            ),
          ],
        ),
      ),
    );
  }
}
