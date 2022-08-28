import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:meta/meta.dart';

class ProductShareButton extends StatelessWidget {
  @literal
  const ProductShareButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.share),
      onPressed: () => showDialog<void>(
        context: context,
        builder: (context) {
          return ShareProductDialog();
        },
      ),
    );
  }
}

class ShareProductDialog extends HookWidget {
  const ShareProductDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCopied = useState(false);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Share',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Column(
                    children: [
                      Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).colorScheme.secondary,
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(20),
                            ),
                            onPressed: () {
                              // TODO: Uri.base is usable only on the web
                              // on mobile the url base needs to be fetched from elsewhere

                              if (kIsWeb) {
                                Clipboard.setData(
                                  ClipboardData(text: Uri.base.toString()),
                                );

                                isCopied.value = true;
                              }
                            },
                            child:
                                Icon(isCopied.value ? Icons.check : Icons.link),
                          ),
                          Text(
                            'Copy URL',
                            style: Theme.of(context).textTheme.bodyText2,
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
