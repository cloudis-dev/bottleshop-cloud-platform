import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/app_navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class UsersList {
  final key;
  final value;

  UsersList(this.key, this.value);
}

class HomeView extends HookWidget {
  const HomeView({Key? key}) : super(key: key);

  Future<void> getAccounts() async {
    await [
      Permission.location,
      Permission.storage,
    ].request();

    final list = <Map<String, dynamic>>[];
    var mapList = [];

    final getUsersDocs = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isNull: false)
        .get();

    final userDocumentsList = getUsersDocs.docs;

    // .forEach((element) {element.data()});

    for (var element in userDocumentsList) {
      mapList =
          element.data().entries.map((e) => UsersList(e.key, e.value)).toList();
    }

    print(mapList);

    final anotherList = <List>[];
    anotherList.add(mapList);

    final csv = ListToCsvConverter().convert(anotherList);

    final dir = '${(await getExternalStorageDirectory())!.path}/mycsv.csv';
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

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Domov'),
        ),
        drawer: const AppNavigationDrawer(),
        body: Center(
          child: ElevatedButton(
            onPressed: getAccounts,
            child: Text('Download'),
          ),
        ),
      ),
    );
  }
}
