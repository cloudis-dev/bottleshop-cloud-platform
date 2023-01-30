import 'package:align_positioned/align_positioned.dart';
import 'package:delivery/src/core/data/res/app_theme.dart';
import 'package:delivery/src/core/utils/screen_adaptive_utils.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:delivery/src/features/home/presentation/widgets/account_menu.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AuthPopupButton extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const AuthPopupButton({Key? key, required this.scaffoldKey})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => AuthPopupButtonState();
}

class AuthPopupButtonState extends State<AuthPopupButton> {
  void showAccountMenu() {
    final buttonRenderObj = context.findRenderObject()! as RenderBox;

    showOverlay(
      (context, _) {
        final screenSize = MediaQuery.of(context).size;
        final pos = buttonRenderObj.localToGlobal(Offset.zero);
        final startPos = pos.dx + buttonRenderObj.size.width;
        final maxHeight = pos.dy + buttonRenderObj.size.height;

        return ResponsiveWrapper.builder(
          SafeArea(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    OverlaySupportEntry.of(context)!.dismiss(animate: false);
                  },
                  child: Container(color: const Color(0x80000000)),
                ),
                AlignPositioned(
                  alignment: Alignment.topRight,
                  dx: 0,
                  dy: shouldUseMobileLayout(context) ? 90 : 118,
                  child: AccountMenu(
                    scaffoldKey: widget.scaffoldKey,
                    width: startPos < 300 ? startPos : 300,
                    maxHeight: screenSize.height - maxHeight,
                  ),
                ),
              ],
            ),
          ),
          maxWidth: 1920,
          minWidth: 50,
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.autoScaleDown(
              50,
              name: MOBILE,
            ),
            ResponsiveBreakpoint.autoScaleDown(600,
                name: MOBILE, scaleFactor: 0.63),
            ResponsiveBreakpoint.autoScaleDown(900,
                name: TABLET, scaleFactor: 0.63),
            ResponsiveBreakpoint.autoScale(1440, name: DESKTOP),
          ],
        );
      },
      context: context,
      duration: Duration.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _Content(
      onClick: showAccountMenu,
    );
  }
}

class _Content extends HookConsumerWidget {
  final VoidCallback onClick;

  const _Content({Key? key, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return IconButton(
      onPressed: onClick,
      color: kPrimaryColor,
      icon: const Icon(
        Icons.person,
      ),
    );
  }
}
