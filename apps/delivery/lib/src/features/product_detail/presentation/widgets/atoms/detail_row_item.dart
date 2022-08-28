import 'package:flutter/material.dart';

class DetailRowItem extends StatelessWidget {
  const DetailRowItem({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: Theme.of(context).textTheme.subtitle2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          value!,
          style: Theme.of(context).textTheme.subtitle2,
          maxLines: 1,
        ),
      ],
    );
  }
}
