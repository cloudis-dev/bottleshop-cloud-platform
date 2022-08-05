import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/chips/promo_codes/promo_code_usages_chip.dart';
import 'package:bottleshop_admin/src/core/utils/formatting_util.dart';
import 'package:bottleshop_admin/src/models/promo_code_model.dart';
import 'package:flutter/material.dart';

class PromoCodeCard extends StatelessWidget {
  const PromoCodeCard({
    Key? key,
    required this.promoCode,
    required this.onPromoCodeDeleteActionSelected,
    required this.onPromoCodeModifyActionSelected,
  }) : super(key: key);

  final PromoCodeModel promoCode;
  final void Function(PromoCodeModel) onPromoCodeDeleteActionSelected;
  final void Function(PromoCodeModel) onPromoCodeModifyActionSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PromoCodeUsagesChip(
                      usagesCount: promoCode.remainingUsesCount,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        promoCode.code,
                        style: AppTheme.headline1TextStyle,
                      ),
                    ),
                    if (promoCode.promoCodeType == PromoCodeType.value) ...[
                      Text(
                        'Zľava: ${FormattingUtil.getPriceString(promoCode.discountValue)}',
                      ),
                      Text(
                        'Minimálna cena košíka: ${FormattingUtil.getPriceString(promoCode.minCartValue)}',
                      ),
                    ] else if (promoCode.promoCodeType == PromoCodeType.percent)
                      Text(
                        'Zľava: ${promoCode.discountValue}%',
                      ),
                    if (promoCode.updated != null)
                      Text(
                        'Upravené: ${FormattingUtil.getDateString(promoCode.updated!)} ${FormattingUtil.getTimeString(promoCode.updated!)}',
                      )
                  ],
                ),
              ),
              const Divider(),
            ],
          ),
        ),
        _PromoCodeCardMenuButton(
          onActionSelected: (action) async {
            switch (action) {
              case _PromoCodeCardAction.modify:
                onPromoCodeModifyActionSelected(promoCode);
                break;
              case _PromoCodeCardAction.remove:
                onPromoCodeDeleteActionSelected(promoCode);
                break;
            }
          },
        ),
      ],
    );
  }
}

enum _PromoCodeCardAction { modify, remove }

class _PromoCodeCardMenuButton extends StatelessWidget {
  const _PromoCodeCardMenuButton({
    Key? key,
    required this.onActionSelected,
  }) : super(key: key);

  final void Function(_PromoCodeCardAction selectedAction) onActionSelected;

  @override
  Widget build(BuildContext context) => PopupMenuButton(
        onSelected: onActionSelected,
        offset: Offset(0, -75),
        icon: Icon(Icons.more_vert, size: 32),
        itemBuilder: (context) => <PopupMenuEntry<_PromoCodeCardAction>>[
          PopupMenuItem<_PromoCodeCardAction>(
            value: _PromoCodeCardAction.modify,
            child: Row(
              children: <Widget>[
                const Expanded(
                  child: Text(
                    'Upraviť',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                Icon(Icons.mode_edit)
              ],
            ),
          ),
          PopupMenuItem<_PromoCodeCardAction>(
            value: _PromoCodeCardAction.remove,
            child: Row(
              children: <Widget>[
                const Expanded(
                  child: Text(
                    'Odstrániť',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
                Icon(Icons.delete)
              ],
            ),
          ),
        ],
      );
}
