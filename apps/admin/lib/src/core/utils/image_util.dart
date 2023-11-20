import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:bottleshop_admin/src/core/utils/files_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img_util;
import 'package:image_picker/image_picker.dart';
import 'package:tuple/tuple.dart';

class ImageUtil {
  ImageUtil._();

  static double getImgSizeRatio(Tuple2<int, int> imgSize) =>
      imgSize.item1 / imgSize.item2;

  static Future<Tuple2<int, int>> getImageSize(XFile file) async {
    final bytes = await file.readAsBytes();
    final img = await decodeImageFromList(bytes);
    return Tuple2(img.width, img.height);
  }

  /// Create image file with the data from url image and cache the url image.
  static Future<File> createImgFileInCacheFromNetwork(
    String imgUrl,
    String fileName,
  ) async {
    final completer = Completer<File>();
    final stream = NetworkImage(imgUrl).resolve(ImageConfiguration());

    final callback = ImageStreamListener(
      (imgInfo, _) async {
        try {
          final byteData = await imgInfo.image.toByteData(
            format: ImageByteFormat.png,
          );

          if (byteData == null) {
            throw Exception('Could not load');
          }

          final filePath = await FilesUtil.getPathToFileInCache(fileName);
          // This is to clear the cache for the given file
          // The file is cached when used in Image.file() widget
          await FileImage(File(filePath)).evict();

          final resultFile =
              await File(filePath).writeAsBytes(byteData.buffer.asUint8List());
          completer.complete(resultFile);
        } catch (err, stack) {
          completer.completeError(err, stack);
        }
      },
    );

    stream.addListener(callback);

    return completer.future.then(
      (value) {
        stream.removeListener(callback);
        return value;
      },
    );
  }

  static Future<List<Uint8List>> createResizedJpgWithWatermark({
    required Uint8List imgBytes,
    required int maxWidth,
    double watermarkSizeMultiplier = .9,
    String watermarkRelativePath = 'assets/images/watermark.png',
  }) async {
    final watermarkBytes =
        (await rootBundle.load(watermarkRelativePath)).buffer.asUint8List();

    final basePayload = [
      maxWidth,
      imgBytes.length,
      (watermarkSizeMultiplier * 100).round(),
    ].followedBy(imgBytes).toList();

    return Future.wait(
      [
        compute<List<int>, Uint8List>(
          _createResizedJpg,
          basePayload,
        ),
        compute<List<int>, Uint8List>(
          _createResizedJpgWithWatermarkProcess,
          basePayload.followedBy(watermarkBytes).toList(),
        ),
      ],
    );
  }
}

Uint8List _createResizedJpg(List<int> params) {
  const headerLength = 3;

  final maxWidth = params[0];

  final bytes = params.skip(headerLength).toList() as Uint8List;

  var img = img_util.decodeImage(bytes)!;

  if (img.width > maxWidth) {
    img = img_util.copyResize(img, width: maxWidth);
  }

  return img_util.encodeJpg(img, quality: 70);
}

Uint8List _createResizedJpgWithWatermarkProcess(List<int> params) {
  const headerLength = 3;

  final maxWidth = params[0];
  final imgBytesLength = params[1];
  final watermarkSizeMultiplier = params[2] / 100.0;
  final bytes = params.skip(headerLength).toList() as Uint8List;
  final watermarkBytes =
      params.skip(headerLength + imgBytesLength).toList() as Uint8List;

  var img = img_util.decodeImage(bytes)!;

  if (img.width > maxWidth) {
    img = img_util.copyResize(img, width: maxWidth);
  }

  final watermarkImg = img_util.decodeImage(watermarkBytes)!;
  final newWatermarkSize = (img.width * watermarkSizeMultiplier).round();

  img_util.compositeImage(
    img,
    watermarkImg,
    dstX: (img.width * (1 - watermarkSizeMultiplier) / 2).round(),
    dstY: ((img.height - newWatermarkSize) / 2).round(),
    dstW: newWatermarkSize,
    dstH: newWatermarkSize,
  );

  return img_util.encodeJpg(img, quality: 70);
}
