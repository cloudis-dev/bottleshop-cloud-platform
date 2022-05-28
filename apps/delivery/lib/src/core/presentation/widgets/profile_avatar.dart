// Copyright 2020 cloudis.dev
//
// info@cloudis.dev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//

import 'package:delivery/src/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:octo_image/octo_image.dart';

class ProfileAvatar extends HookConsumerWidget {
  final String? imageUrl;

  const ProfileAvatar({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (imageUrl != null && Uri.parse(imageUrl!l10n.isAbsolute) {
      return OctoImage(
        image: NetworkImage(imageUrl!),
        fit: BoxFit.cover,
        imageBuilder: (context, imageProvider) => SizedBox(
          width: 80.0,
          height: 80.0,
          child: ClipOval(
            child: imageProvider,
          ),
        ),
        placeholderBuilder: (context) => const CircularProgressIndicator(),
        errorBuilder: (context, url, error) => const CircleAvatar(
          backgroundImage: AssetImage(kDefaultAvatar),
        ),
      );
    }
    return const CircleAvatar(
      backgroundImage: AssetImage(kDefaultAvatar),
    );
  }
}
