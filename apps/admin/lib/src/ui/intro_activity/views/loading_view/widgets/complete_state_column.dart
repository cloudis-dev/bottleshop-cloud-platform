import 'package:bottleshop_admin/src/ui/intro_activity/views/loading_view/widgets/logged_user_widget.dart';
import 'package:flutter/material.dart';

class CompleteStateColumn extends StatelessWidget {
  const CompleteStateColumn({
    Key? key,
  }) : super(key: key);

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
                    'Všetko pripravené.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: LoggedUserWidget(),
          )
        ],
      );
}
