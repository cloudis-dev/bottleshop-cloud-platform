import 'dart:io';

import 'package:bottleshop_admin/src/core/utils/snackbar_utils.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/dialogs/product_image_delete_dialog.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/pages/product_edit_page.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/view_models/product_image_view_model.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/widgets/product_images_view/action_buttons_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProductImagesView extends HookWidget {
  static const String routeName = '/images';

  const ProductImagesView({Key? key}) : super(key: key);

  Future<void> _onPickImage(BuildContext context, ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      final imgFile = File(pickedFile.path);

      await setProductImgFile(context, imgFile);
    }
  }

  Future<void> _onCropImage(BuildContext context) async {
    final currentImgFile = context.read(productImgProvider);
    if (currentImgFile == null) return;

    final croppedImg = await ImageCropper().cropImage(
      sourcePath: currentImgFile.path,
      aspectRatio: CropAspectRatio(
        ratioX: ProductImageViewModel.ratioX,
        ratioY: ProductImageViewModel.ratioY,
      ),
      uiSettings: [
        AndroidUiSettings(
          hideBottomControls: true,
        ),
        IOSUiSettings(
          rotateButtonsHidden: true,
          resetButtonHidden: true,
        ),
      ],
    );

    if (croppedImg != null) {
      final imgFile = File(croppedImg.path);
      await setProductImgFile(context, imgFile);
    }
  }

  Future<void> _onImageDelete(BuildContext context) async {
    final res = await showDialog<ProductImageDeleteResult>(
        context: context, builder: (_) => ProductImageDeleteDialog());

    if (res != null) {
      SnackBarUtils.showSnackBar(
        ProductEditPage.scaffoldMessengerKey.currentState!,
        SnackBarDuration.short,
        res.message,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      children: <Widget>[
        AspectRatio(
          aspectRatio: ProductImageViewModel.targetImgAspect,
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: const _ImageFrameContent(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            '*Pomer strán obrázka musí byť ${ProductImageViewModel.ratioX.toInt()}:${ProductImageViewModel.ratioY.toInt()}.',
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
              '*Ak Vám nejde potvrdiť zmeny, tak orežte obrázok cez možnosť orezať obrázok.'),
        ),
        ActionButtonsColumn(
          onImageDelete: _onImageDelete,
          onPickImage: _onPickImage,
          onCropImage: _onCropImage,
        ),
      ],
    );
  }
}

class _ImageFrameContent extends HookWidget {
  const _ImageFrameContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (useProvider(isImgLoadedProvider)) {
      final imgFile = useProvider(productImgProvider);

      if (imgFile == null) {
        return Image.asset('assets/images/placeholder.png');
      }
      return Image.file(imgFile);
    } else {
      return const Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
