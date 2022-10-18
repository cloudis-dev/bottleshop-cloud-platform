import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bottleshop_admin/src/core/data/services/firebase_storage_service.dart';
import 'package:bottleshop_admin/src/core/utils/image_util.dart';
import 'package:bottleshop_admin/src/core/utils/math_util.dart';
import 'package:bottleshop_admin/src/features/products/data/models/product_model.dart';
import 'package:bottleshop_admin/src/features/products/data/services/services.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

enum ProductAction { creating, editing }

final initialProductProvider =
    StateProvider.autoDispose<ProductModel>((_) => ProductModel.empty());

final editedProductProvider = StateProvider.autoDispose<ProductModel>(
  (ref) => ref.watch(initialProductProvider).state,
);

final isCreatingNewProductProvider = Provider.autoDispose<bool>(
    (ref) => ref.watch(initialProductProvider).state == ProductModel.empty());

final isProductModelChangedProvider = Provider.autoDispose<bool>(
  (ref) =>
      ref.watch(initialProductProvider).state !=
          ref.watch(editedProductProvider).state ||
      ref.watch(isImgChangedProvider).state,
);

final productFormStateKeyProvider = Provider.autoDispose<GlobalKey<FormState>>(
  (_) => GlobalKey<FormState>(),
);

final productToEditStreamProvider =
    StreamProvider.autoDispose.family<ProductModel, String?>(
  (ref, uid) => (uid == null
          ? Stream.value(ProductModel.empty())
          : productsDbService.streamSingle(uid))
      .map(
    (event) {
      ref.read(initialProductProvider).state = event;
      return event;
    },
  ),
);

/// This is providing file from the server of the product.
final _productImgFileFutureProvider = FutureProvider.autoDispose<String?>(
  (ref) {
    final imagePath = ref.watch(initialProductProvider).state.imagePath;

    if (imagePath == null) {
      return Future.value(null);
    } else {
      return FirebaseStorageService.getDownloadUrlFromPath(imagePath);
    }
  },
);

final isImgChangedProvider = StateProvider.autoDispose<bool>((ref) => false);

/// Tells if the image from server is already loaded.
final isImgLoadedProvider = Provider.autoDispose<bool>(
  (ref) => ref.watch(_productImgFileFutureProvider).when(
        data: (_) => true,
        loading: () => false,
        error: (err, stacktrace) {
          FirebaseCrashlytics.instance.recordError(err, stacktrace);
          return false;
        },
      ),
);

final productImgProvider = Provider.autoDispose<String?>(
  (ref) {
    return ref.watch(blopProvider).state;
  },
);

const double imgRatioX = 12;
const double imgRatioY = 16;
const double targetImgAspect = imgRatioX / imgRatioY;

final isProductImageValid = FutureProvider.autoDispose<bool>(
  (ref) {
    final currentImg = ref.watch(blopProvider).state;
    if (currentImg == null) {
      return Future.value(true);
    } else {
      return ImageUtil.getImageSize(XFile(currentImg))
          .then(
        (value) => MathUtil.approximately(
          targetImgAspect,
          ImageUtil.getImgSizeRatio(value),
          epsilon: 0.01,
        ),
      )
          .then((value) async {
        await Future<void>.delayed(Duration(seconds: 1));
        return value;
      });
    }
  },
);

final blopProvider  = StateProvider.autoDispose<String?>(
  (ref) => ref.watch(_productImgFileFutureProvider).when(
        data: (file) => file,
        loading: () => null,
        error: (err, stacktrace) {
          FirebaseCrashlytics.instance.recordError(err, stacktrace);
          return null;
        },
      ),
);

void deleteImage(BuildContext context) {
  context.read(blopProvider).state = null;
}

void setImage(BuildContext context, String url) {
  context.read(blopProvider).state = url;
}
