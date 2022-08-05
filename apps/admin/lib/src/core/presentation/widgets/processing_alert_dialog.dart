import 'package:bottleshop_admin/src/core/presentation/view_models/processing_alert_dialog_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final processingAlertDialogViewModelProvider =
    ChangeNotifierProvider.autoDispose((_) => ProcessingAlertDialogViewModel());

abstract class ProcessingAlertDialog extends HookWidget {
  const ProcessingAlertDialog({
    Key? key,
    required this.actionButtonColor,
    required this.negativeButtonOptionBuilder,
    required this.positiveButtonOptionBuilder,
    required this.onPositiveOption,
    required this.onNegativeOption,
    this.contentPadding = const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
    this.isPositiveButtonActive = true,
  }) : super(key: key);

  final Color actionButtonColor;
  final WidgetBuilder negativeButtonOptionBuilder;
  final WidgetBuilder positiveButtonOptionBuilder;
  final EdgeInsets contentPadding;
  final bool isPositiveButtonActive;

  final void Function(BuildContext) onPositiveOption;
  final void Function(BuildContext) onNegativeOption;

  @mustCallSuper
  @protected
  Widget negativeButton(
    BuildContext context,
    ProcessingAlertDialogViewModel model,
  ) =>
      OutlinedButton(
        onPressed:
            model.isProcessing ? null : () async => onNegativeOption(context),
        child: negativeButtonOptionBuilder(context),
      );

  @mustCallSuper
  @protected
  Widget positiveButton(
    BuildContext context,
    bool isButtonActive,
    ProcessingAlertDialogViewModel model,
  ) =>
      ElevatedButton(
        style: ElevatedButton.styleFrom(primary: actionButtonColor),
        onPressed: !isButtonActive
            ? null
            : (model.isProcessing
                ? null
                : () {
                    model.isProcessing = true;
                    onPositiveOption(context);
                  }),
        child: model.isProcessing
            ? const Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(),
                ),
              )
            : positiveButtonOptionBuilder(context),
      );

  @protected
  Widget content(BuildContext context);

  @mustCallSuper
  @override
  Widget build(BuildContext context) {
    final model = useProvider(processingAlertDialogViewModelProvider);

    return WillPopScope(
      onWillPop: model.isProcessing ? () async => false : () async => true,
      child: GestureDetector(
        behavior: model.isProcessing
            ? HitTestBehavior.opaque
            : HitTestBehavior.deferToChild,
        child: AlertDialog(
          contentPadding: contentPadding,
          content: content(context),
          actions: <Widget>[
            negativeButton(context, model),
            positiveButton(context, isPositiveButtonActive, model),
          ],
        ),
      ),
    );
  }
}
