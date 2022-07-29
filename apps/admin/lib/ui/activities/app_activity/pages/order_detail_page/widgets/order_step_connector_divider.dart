import 'package:flutter/material.dart';

class OrderStepConnectorDivider extends StatelessWidget {
  const OrderStepConnectorDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: SizedBox(
              height: 15,
              child: VerticalDivider(
                thickness: 2,
                color: Colors.black,
              ),
            ),
          ),
        ],
      );
}
