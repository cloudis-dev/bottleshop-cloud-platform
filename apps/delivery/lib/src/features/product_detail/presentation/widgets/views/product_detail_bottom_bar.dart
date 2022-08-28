import 'package:delivery/src/features/auth/presentation/widgets/views/auth_popup_button.dart';
import 'package:delivery/src/features/product_detail/presentation/widgets/organisms/product_actions_widget.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ProductDetailBottomBar extends HookWidget {
  final ProductModel product;
  final GlobalKey<AuthPopupButtonState> authButtonKey;

  const ProductDetailBottomBar({
    Key? key,
    required this.product,
    required this.authButtonKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).hintColor.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ProductActionsWidget(
        product: product,
        authButtonKey: authButtonKey,
      ),
    );
  }
}
