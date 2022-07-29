import 'dart:io';

import 'package:bottleshop_admin/core/data/services/firebase_storage_service.dart';
import 'package:bottleshop_admin/utils/image_util.dart';
import 'package:bottleshop_admin/utils/math_util.dart';
import 'package:tuple/tuple.dart';

enum LoadingState { none, loading, done }

class ProductImageViewModel {
  // TODO: refactoring - handling of this is too error prone

  static const double ratioX = 12;
  static const double ratioY = 16;
  static const double targetImgAspect = ratioX / ratioY;

  final Function onNotifyListeners;
  final String? productImagePath;

  bool _hasInitialFile;
  File? _imageFile;
  Tuple2<int, int>? _imageSizeXY;
  bool _isFileChanged = false;
  LoadingState _imageLoadingState = LoadingState.none;

  Tuple2<int, int>? get imageSize => _imageSizeXY;
  File? get imageFile => _imageFile;

  bool get isModelChanged =>
      _isFileChanged || _hasInitialFile && _imageFile == null;
  bool get isModelValid =>
      _imageFile == null ||
      MathUtil.approximately(
        targetImgAspect,
        ImageUtil.getImgSizeRatio(_imageSizeXY!),
        epsilon: 0.01,
      );

  Tuple2<LoadingState, File?> get imageFileWithState =>
      Tuple2(_imageLoadingState, _imageFile);

  ProductImageViewModel(this.onNotifyListeners, this.productImagePath)
      : _hasInitialFile = false;

  void loadData() {
    if (_imageLoadingState != LoadingState.none) return;

    if (productImagePath != null) {
      // TODO: this future is running and tries to notifyListeners after screen closed - results in error
      FirebaseStorageService.getDownloadUrlFromPath(productImagePath!).then(
        (url) async {
          final file = await ImageUtil.createImgFileInCacheFromNetwork(
            url,
            'product_img_temp.png',
          );
          final imgSize = await ImageUtil.getImageSize(file);
          _imageLoadingState = LoadingState.done;
          _hasInitialFile = true;
          setImageFile(
            file: file,
            imageSize: imgSize,
            isChanged: false,
          );
        },
      ).catchError(
        (err) async {
          _imageLoadingState = LoadingState.done;
          _hasInitialFile = false;
          setImageFile(file: null, imageSize: null, isChanged: false);
        },
      );

      _imageLoadingState = LoadingState.loading;
      _imageFile = null;
    } else {
      _imageLoadingState = LoadingState.done;
      _imageFile = null;
    }
  }

  Future<void> dispose() async {
    if (_imageFile != null) {
      await _imageFile!.delete();
    }
  }

  void setImageFile({
    required File? file,
    required Tuple2? imageSize,
    required bool isChanged,
  }) {
    assert(_imageFile == null);
    _isFileChanged = isChanged;
    _imageSizeXY = imageSize as Tuple2<int, int>?;
    _imageFile = file;
    onNotifyListeners();
  }

  Future<void> removeImageFile() async {
    assert(_imageFile != null);
    await _imageFile!.delete();
    _imageFile = null;
    _imageSizeXY = null;
    onNotifyListeners();
  }
}
