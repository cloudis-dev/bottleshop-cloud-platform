import 'package:align_positioned/align_positioned.dart';
import 'package:delivery/src/core/presentation/widgets/profile_avatar.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:delivery/src/features/home/presentation/widgets/account_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

class AuthPopupButton extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  AuthPopupButton({Key? key, required this.scaffoldKey}) : super(key: key);

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

        return SafeArea(
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
                dx: screenSize.width - startPos,
                dy: buttonRenderObj.size.height,
                child: AccountMenu(
                  scaffoldKey: widget.scaffoldKey,
                  width: startPos < 300 ? startPos : 300,
                  maxHeight: screenSize.height - maxHeight,
                ),
              ),
            ],
          ),
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

class _Content extends HookWidget {
  final VoidCallback onClick;

  const _Content({Key? key, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = useProvider(currentUserProvider);

    return IconButton(
      onPressed: onClick,
      icon: user == null
          ? const Icon(Icons.supervised_user_circle_rounded)
          : AspectRatio(
              aspectRatio: 1,
              child: ProfileAvatar(imageUrl: user.avatar),
            ),
    );
  }
}
