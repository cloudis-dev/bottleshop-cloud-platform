import 'package:flutter/material.dart';

import 'package:bottleshop_admin/src/features/login/presentation/widgets/logged_user_widget.dart';

class LoadingStateColumn extends StatelessWidget {
  const LoadingStateColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    'Načítavanie potrebných dát...',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          const Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: LoggedUserWidget(),
          ),
        ],
      );
}
