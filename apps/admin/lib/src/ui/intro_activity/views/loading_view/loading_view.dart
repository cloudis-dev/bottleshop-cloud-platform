import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/core/app_page.dart';
import 'package:bottleshop_admin/src/core/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/ui/intro_activity/views/loading_view/widgets/complete_state_column.dart';
import 'package:bottleshop_admin/src/ui/intro_activity/views/loading_view/widgets/failed_state_column.dart';
import 'package:bottleshop_admin/src/ui/intro_activity/views/loading_view/widgets/loading_state_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoadingView extends HookWidget {
  const LoadingView(this._onPagesAfterLogin, {Key? key}) : super(key: key);

  final List<AppPage> Function() _onPagesAfterLogin;

  @override
  Widget build(BuildContext context) {
    print('Loading');

    final constantAppData = useProvider(constantAppDataFutureProvider);
    final navigator = context.read(navigationProvider.notifier);

    return Scaffold(
      body: Container(
        color: AppTheme.primaryColor,
        child: Center(
          child: constantAppData.when(
            data: (appData) {
              Future.microtask(
                () => context.read(constantAppDataProvider).state = appData,
              );

              useEffect(() {
                Future.microtask(
                  () => navigator.replaceAllWith(_onPagesAfterLogin()),
                );
                return;
              }, []);

              return CompleteStateColumn();
            },
            loading: () => LoadingStateColumn(),
            error: (err, stacktrace) {
              print(err);
              print(stacktrace);
              return FailedStateColumn(_onPagesAfterLogin);
            },
          ),
        ),
      ),
    );
  }
}
