import 'dart:io';
import 'dart:typed_data';

import 'package:bottleshop_admin/src/core/utils/files_util.dart';
import 'package:bottleshop_admin/src/core/utils/image_util.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

@immutable
class ImageUploadResult {
  final String? thumbnailPath;
  final String? imagePath;

  const ImageUploadResult({
    this.thumbnailPath,
    this.imagePath,
  });
}

class FirebaseStorageService {
  static const String warehouseDirectory = 'warehouse';
  static const String cleanWarehouseImagesDirectory = 'warehouse_clean';
  static const String thumbnailsDirectory = 'thumbnails';

  static const int maxImageWidth = 1080;

  FirebaseStorageService._();

  static String getCleanImagePath(String? productUniqueId) =>
      '$cleanWarehouseImagesDirectory/$productUniqueId.jpeg';

  static String getImagePath(String? productUniqueId) =>
      '$warehouseDirectory/$productUniqueId.jpeg';

  static String getThumbnailPath(String? productUniqueId) =>
      '$warehouseDirectory/$thumbnailsDirectory/${productUniqueId}_400x400.jpeg';

  static Future<String> getDownloadUrlFromPath(String path) async {
    try {
      return await FirebaseStorage.instance.ref().child(path).getDownloadURL();
    } catch (e) {
      return Future.error('File on path doesn\'t exist.');
    }
  }

  static Future<List<void>> deleteImgAndThumbnail(String? productUniqueId) {
    return Future.wait(
      [
        FirebaseStorage.instance
            .ref()
            .child(getCleanImagePath(productUniqueId))
            .delete()
            .then((value) {}, onError: (_, __) {}),
        FirebaseStorage.instance
            .ref()
            .child(getImagePath(productUniqueId))
            .delete()
            .then((value) {}, onError: (_, __) {}),
        FirebaseStorage.instance
            .ref()
            .child(getThumbnailPath(productUniqueId))
            .delete()
            .then((value) {}, onError: (_, __) {}),
      ],
    );
  }

  // static Future<ImageUploadResult> uploadImgData(
  //   File imageFile,
  //   String? productUniqueId,
  // ) async {
  //   final resultData = await ImageUtil.createResizedJpgWithWatermark(
  //     file: await imageFile.readAsBytes(),
  //     maxWidth: maxImageWidth,
  //   );

  //   final cleanImgData = resultData[0];
  //   final watermarkedImgData = resultData[1];

  //   final cleanImgFilePath =
  //       await FilesUtil.getPathToFileInCache('clean_upload_img.temp');
  //   final cleanImgFile =
  //       await File(cleanImgFilePath).writeAsBytes(cleanImgData);

  //   final watermarkedImgFilePath =
  //       await FilesUtil.getPathToFileInCache('watermarked_upload_img.temp');
  //   final watermarkedImgFile =
  //       await File(watermarkedImgFilePath).writeAsBytes(watermarkedImgData);

  //   final cleanImagePath = getCleanImagePath(productUniqueId);
  //   final watermarkedImagePath = getImagePath(productUniqueId);
  //   final thumbnailPath = getThumbnailPath(productUniqueId);

  //   await Future.wait(
  //     [
  //       FirebaseStorage.instance.ref().child(cleanImagePath).putFile(
  //             cleanImgFile,
  //             SettableMetadata(contentType: 'image/jpeg'),
  //           ),
  //       FirebaseStorage.instance.ref().child(watermarkedImagePath).putFile(
  //             watermarkedImgFile,
  //             SettableMetadata(contentType: 'image/jpeg'),
  //           ),
  //     ],
  //   );

  //   return ImageUploadResult(
  //     imagePath: watermarkedImagePath,
  //     thumbnailPath: thumbnailPath,
  //   );
  // }

  static Future<ImageUploadResult> uploadImgBytes(
    Uint8List imageFile,
    String? productUniqueId,
  ) async {
    final resultData = await ImageUtil.createResizedJpgWithWatermark(
      imgBytes:  imageFile,
      maxWidth: maxImageWidth,
    );

    final cleanImgData = resultData[0];
    final watermarkedImgData = resultData[1];
    final cleanImagePath = getCleanImagePath(productUniqueId);
    final watermarkedImagePath = getImagePath(productUniqueId);
    await FirebaseStorage.instance.ref().child(cleanImagePath).putData(
          cleanImgData,
          
        );
    await FirebaseStorage.instance.ref().child(watermarkedImagePath).putData(
       watermarkedImgData,
       
    );
    return ImageUploadResult(
      imagePath: cleanImagePath,
      thumbnailPath: watermarkedImagePath,
    );
  }
}
