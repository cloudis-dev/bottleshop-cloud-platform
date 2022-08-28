import 'package:delivery/src/core/data/res/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

final isAppVersionCompatible = StreamProvider.autoDispose<bool>(
  (ref) {
    if (kIsWeb) {
      return Stream.value(true);
    }

    return FirebaseFirestore.instance
        .collection(FirestoreCollections.versionConstraintsCollection)
        .doc('main_app')
        .snapshots()
        .map((event) => event.get('min_version'))
        .asyncMap((minBuildNum) async {
      final packageInfo = await PackageInfo.fromPlatform();
      return Version.parse(packageInfo.version) >= Version.parse(minBuildNum);
    });
  },
);

final appDownloadRedirectUrlProvider = FutureProvider.autoDispose<String>(
  (_) {
    return FirebaseFirestore.instance
        .collection(FirestoreCollections.versionConstraintsCollection)
        .doc('main_app')
        .get()
        .then(
          (value) => value.data()![
              defaultTargetPlatform == TargetPlatform.android
                  ? 'download_url_android'
                  : 'download_url_ios'],
        );
  },
);
