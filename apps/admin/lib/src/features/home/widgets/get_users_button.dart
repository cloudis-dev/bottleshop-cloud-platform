import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:bottleshop_admin/src/features/home/presentation/providers/providers.dart';

class GetUsersButton extends HookWidget {
  const GetUsersButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return useProvider(getUsersListProvider).when(
      data: (value) {
        List tempList = [];
        for (var element in value.docs) {
          ///gets all 193 users
          tempList.insert(0, element.data());
        }

        Future<void> getAccounts() async {
          await [
            Permission.location,
            Permission.storage,
          ].request();

          List<List> finalList = [];
          finalList.add(tempList);

          final csv = ListToCsvConverter().convert(finalList);

          final dir =
              '${(await getExternalStorageDirectory())!.path}/mycsv.csv';
          final file = dir;

          final f = File(file);
          await f.writeAsString(csv);

          const docFields = [
            'avatar',
            'billing_adress',
            'dayOfBirth',
            'email',
            'email_verified',
            'introSeen',
            'is_annonymous',
            'last_logged_in',
            'name',
            'phone_number',
            'preffered_language',
            'registration_date',
            'shipping_address',
            'stripe_customer_id',
            'uid',
          ];
        }

        return ElevatedButton(
          onPressed: () {
            // print(tempList);
            getAccounts();
          },
          child: Text('Download'),
        );
      },
      loading: () => Text('Loading...'),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }
}
