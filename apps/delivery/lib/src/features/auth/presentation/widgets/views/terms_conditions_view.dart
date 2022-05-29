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
import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/config/environment.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:native_pdf_view/native_pdf_view.dart';

final _pdfUrlProvider = Provider<String>((ref) {
  var lang = ref.watch(currentLocaleProvider).languageCode;
  final url = '${Environment.tcsPdfUrl}tcs_$lang.pdf?alt=media';
  return url;
});

final _pdfDocProvider = FutureProvider<PdfDocument>((ref) {
  return http.Client()
      .get(Uri.parse(ref.watch(_pdfUrlProvider)))
      .then((value) => PdfDocument.openData(value.bodyBytes));
});

final _pdfCtrl = Provider.autoDispose.family<PdfController, PdfDocument>(
  (ref, doc) {
    final ctrl = PdfController(document: Future.value(doc));
    ref.onDispose(ctrl.dispose);

    return ctrl;
  },
);

class TermsConditionsPage extends HookConsumerWidget {
  static const String pagePathBase = 'terms-and-conditions';

  const TermsConditionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class _TermsConditionsView extends HookConsumerWidget {
  const _TermsConditionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(
          onPressed: () {},
        ),
        title: Text(
          context.l10n.generalCommercialTermsTitle,
        ),
      ),
      body: ref.watch(_pdfDocProvider).when(
            data: (pdfDoc) {
              return PdfView(
                pageSnapping: false,
                scrollDirection: Axis.vertical,
                controller: ref.watch(_pdfCtrl(pdfDoc)),
                renderer: (page) => page.render(
                  height: 1920,
                  width: 1080,
                  format: PdfPageImageFormat.png,
                ),
                pageLoader: const Loader(),
              );
            },
            loading: () => const Loader(),
            error: (_, __) => Center(child: Text(context.l10n.errorGeneric)),
          ),
    );
  }
}
