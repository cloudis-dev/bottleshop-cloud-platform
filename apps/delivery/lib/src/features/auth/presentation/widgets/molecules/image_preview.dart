import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ImgPreview extends HookConsumerWidget {
  final XFile file;
  Function callback;
  int index;
  ImgPreview(this.file, this.callback, this.index, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(file.path);
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Stack(
        children: [
          Container(
            height: 100,
            width: 100,
            child: Image.network(file.path, fit: BoxFit.cover),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: InkWell(
              onTap: () {
                callback(index);
              },
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.clear,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
