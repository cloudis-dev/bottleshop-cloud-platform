import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/core/data/models/admin_user_model.dart';
import 'package:flutter/material.dart';

class AdminUserChip extends StatelessWidget {
  const AdminUserChip({Key? key, required this.adminUser}) : super(key: key);

  final AdminUserModel? adminUser;

  @override
  Widget build(BuildContext context) => Chip(
      backgroundColor: Colors.orange,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      label: Text('@${adminUser!.nick}',
          style: AppTheme.subtitle1TextStyle.copyWith(color: Colors.black)));
}
