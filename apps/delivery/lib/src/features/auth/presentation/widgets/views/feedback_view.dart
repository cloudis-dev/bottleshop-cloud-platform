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
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:dartz/dartz.dart';
import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:routeborn/routeborn.dart';
import '../molecules/image_preview.dart';

class FeedbackPage extends RoutebornPage {
  static const String pagePathBase = 'feedback';

  FeedbackPage() : super.builder(pagePathBase, (_) => _FeedbackView());

  @override
  Either<ValueListenable<String?>, String> getPageName(BuildContext context) =>
      Right(context.l10n.cart);

  @override
  String getPagePath() => pagePathBase;

  @override
  String getPagePathBase() => pagePathBase;
}

class _FeedbackView extends HookConsumerWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  _FeedbackView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typE = useState<String>("problem");
    final name = useState<String>("");
    final email = useState<String>("");
    final message = useState<String>("");
    final images = useState<List<XFile>>([]);
    final disableButton = useState<bool>(false);
    return ResponsiveWrapper.builder(
      Form(
        key: _formKey,
        child: Scaffold(
            appBar: AppBar(
              leading: CloseButton(
                onPressed: () => ref.read(navigationProvider).popPage(context),
              ),
              title: Text(
                context.l10n.feedback,
              ),
            ),
            body: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(500, 15, 500, 0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.l10n.enterSomeText;
                        }
                        if (value.length >= 50) return context.l10n.tooLong;
                        return null;
                      },
                      onChanged: (value) {
                        name.value = value;
                      },
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: context.l10n.enterName.toString(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(500, 50, 500, 0),
                    child: TextFormField(
                      onChanged: (value) {
                        email.value = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.l10n.enterSomeText;
                        }
                        if (!RegExp(
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                            .hasMatch(value)) {
                          return context.l10n.invalidEmail;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: context.l10n.enterEmail,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(500, 50, 500, 25),
                    child: TextFormField(
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.l10n.enterSomeText;
                        }
                        if (value.length >= 250) {
                          return context.l10n.tooLong;
                        }
                        return null;
                      },
                      onChanged: (value) {
                        message.value = value;
                      },
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: context.l10n.enterMsg,
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(500, 0, 500, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 65,
                          height: 65,
                          child: ElevatedButton(
                            child: Icon(Icons.add),
                            onPressed: () async {
                              if (images.value.length < 3) {
                                final ImagePicker _picker = ImagePicker();
                                final img = await _picker.pickImage(
                                    source: ImageSource.gallery);
                                if (await img!.length() >= 3000000) {
                                  return;
                                }
                                final bytes = await img.readAsBytes();
                                final oldItems = images.value;
                                final newItem = base64Encode(bytes);
                                images.value = [...oldItems, img];
                              }
                            },
                          ),
                        ),
                        if (images.value.length > 0)
                          Expanded(
                            child: Container(
                              height: 50,
                              width: 200,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: images.value.length,
                                  itemBuilder: (context, index) {
                                    return ImgPreview(
                                        images.value.elementAt(index), (int i) {
                                      images.value.removeWhere((image) =>
                                          image.path ==
                                          images.value.elementAt(i).path);
                                      var tmp = List<XFile>.from(images.value);
                                      images.value = tmp;
                                    }, index);
                                  }),
                            ),
                          )
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(500, 40, 500, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200,
                            child: RadioListTile(
                                title: Text(context.l10n.problem),
                                value: "problem",
                                groupValue: typE.value,
                                onChanged: (value) {
                                  typE.value = value as String;
                                }),
                          ),
                          SizedBox(
                            width: 200,
                            child: RadioListTile(
                                title: Text(context.l10n.suggestion),
                                value: "suggestion",
                                groupValue: typE.value,
                                onChanged: (value) {
                                  typE.value = value as String;
                                }),
                          )
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(500, 30, 500, 0),
                    child: SizedBox(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: !disableButton.value?() async {
                          if (_formKey.currentState!.validate()) {
                            disableButton.value = true;
                            List<Map<String, String>> paths = [];
                            for (int i = 0; i < images.value.length; i++) {
                              var bytes =
                                  await images.value.elementAt(i).readAsBytes();
                              var bs64 = base64Encode(bytes);
                              Map<String, String> imgObj = {};
                              imgObj["path"] = 'data:text/plain;base64,$bs64';
                              paths.add(imgObj);
                            }
                            final mail = {
                              'to': typE.value == 'problem'
                                  ? 'info@ave-z.com'
                                  : 'info@bottleshop3veze.sk',
                              'html': '.',
                              'subject':
                                  '${typE.value == 'problem' ? 'problem' : 'suggestion'} from ${name.value}',
                              'text':
                                  'Name: ${name.value}\nEmail: ${email.value}\n\n\n${message.value}',
                              'path': paths
                            };

                            await ref
                                .read(cloudFunctionsProvider)
                                .postFeedback(mail);
                            ref.read(navigationProvider).popPage(context);
                            showSimpleNotification(
                                Text(
                                context.l10n.wasSent),
                                background: Colors.black,
                                foreground: Colors.white 
                                );
                          }
                        } : null,
                        child: Text(context.l10n.send),
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
      maxWidth: 1920,
      minWidth: 200,
      defaultScale: false,
      breakpoints: [
        ResponsiveBreakpoint.resize(200, name: MOBILE, scaleFactor: 0.2),
        ResponsiveBreakpoint.resize(600, name: MOBILE, scaleFactor: 0.6),
        ResponsiveBreakpoint.autoScaleDown(900,
            name: TABLET, scaleFactor: 0.63),
        ResponsiveBreakpoint.autoScale(1440, name: DESKTOP),
      ],
    );
  }
}
