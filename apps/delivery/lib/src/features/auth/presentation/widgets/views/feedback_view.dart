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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/data/res/app_environment.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pdfx/pdfx.dart';
import 'package:routeborn/routeborn.dart';

class FeedbackPage extends RoutebornPage {
  static const String pagePathBase = 'feedback';

  FeedbackPage() : super.builder(pagePathBase, (_) => const _FeedbackView());

  @override
  Either<ValueListenable<String?>, String> getPageName(BuildContext context) =>
      Right(context.l10n.cart);

  @override
  String getPagePath() => pagePathBase;

  @override
  String getPagePathBase() => pagePathBase;
}

class _FeedbackView extends HookConsumerWidget {
  const _FeedbackView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typE = useState<String>("problem");
    final name = useState<String>("");
    final email = useState<String>("");
    final message = useState<String>("");
    return Scaffold(
        appBar: AppBar(
          leading: CloseButton(
            onPressed: () => ref.read(navigationProvider).popPage(context),
          ),
          title: Text(
            "Feedback",
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(500, 50, 500, 0),
                child: TextFormField(
                  onChanged: (value) {
                    name.value = value;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter your name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(500, 50, 500, 0),
                child: TextFormField(
                  onChanged: (value) {
                    email.value = value;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter your email',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(500, 50, 500, 25),
                child: TextField(
                  maxLines: 5,
                  onChanged: (value) {
                    name.value = value;
                  },
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Type your message',
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
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(500, 50, 500, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200,
                        child: RadioListTile(
                            title: Text("Problem"),
                            value: "problem",
                            groupValue: typE.value,
                            onChanged: (value) {
                              typE.value = value as String;
                            }),
                      ),
                      SizedBox(
                        width: 200,
                        child: RadioListTile(
                            title: Text("Suggestion"),
                            value: "suggestion",
                            groupValue: typE.value,
                            onChanged: (value) {
                              typE.value = value as String;
                            }),
                      )
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(500, 50, 500, 0),
                child: SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: ()async {
                      await ref.read(cloudFunctionsProvider).postFeedback();
                    },
                    child: Text('Send'),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
