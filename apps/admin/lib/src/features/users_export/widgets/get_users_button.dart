import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:bottleshop_admin/src/features/users_export/providers/providers.dart';

class GetUsersButton extends HookWidget {
  const GetUsersButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final users = [
      ['Name', 'Date of birth', 'Phone number', 'Email'],
    ];

    Future<void> getUsers() async {
      await Permission.storage.request();
      final csv = ListToCsvConverter().convert(users);
      final dir =
          '${(await getApplicationDocumentsDirectory()).path}/mycsv.csv';
      print(dir);
      final file = File(dir);
      await file.writeAsString(csv);
      // getExternalStorageDirectory
    }

    return useProvider(getUsersListProvider).when(
      data: (value) {
        for (var element in value.docs) {
          final tempList = <String>['0', '1', '2', '3'];

          element.data().forEach((key, value) {
            if (key == 'name') {
              tempList.replaceRange(0, 1, [value.toString()]);
            } else if (key == 'dayOfBirth') {
              if (value != null) {
                final newValue = value.toDate();
                final date = DateFormat('dd/MM/yyyy').format(newValue);
                tempList.replaceRange(1, 2, [date.toString()]);
              } else {
                tempList.replaceRange(1, 2, [value.toString()]);
              }
            } else if (key == 'phone_number') {
              tempList.replaceRange(2, 3, [value.toString()]);
            } else if (key == 'email') {
              tempList.replaceRange(3, 4, [value.toString()]);
            }
          });
          users.add(tempList);
        }

        return ElevatedButton(
          onPressed: () {
            getUsers();
          },
          child: Text('Download'),
        );
      },
      loading: () => Text('Loading...'),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }
}
