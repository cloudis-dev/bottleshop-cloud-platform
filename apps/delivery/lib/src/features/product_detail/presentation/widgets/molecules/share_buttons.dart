import 'package:delivery/src/core/data/services/analytics_service.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class ProductShareButton extends StatelessWidget {
  final ProductModel product;
  @literal
  const ProductShareButton({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.share),
      onPressed: () => showDialog<void>(
        context: context,
        builder: (context) {
          return ShareProductDialog(product: product);
        },
      ),
    );
  }
}

class ShareProductDialog extends HookConsumerWidget {
  final ProductModel product;

  const ShareProductDialog({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    icon: const Icon(Icons.close),
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
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                            ),
                            onPressed: () {
                              // TODO: Uri.base is usable only on the web
                              // on mobile the url base needs to be fetched from elsewhere

                              Clipboard.setData(
                                ClipboardData(
                                    text:
                                        'http://localhost:61122/home/products/product-detail/${product.uniqueId}'),
                              );

                              isCopied.value = true;
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
                  Column(
                    children: [
                      Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(
                                  255, 24, 119, 242), // Facebook blue color
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                            ),
                            onPressed: () async {
                              // TODO: Uri.base is usable only on the web
                              // on mobile, the url base needs to be fetched from elsewhere
                              await logShare(ref, 'facebook', product.name);
                              await launchUrl(Uri.parse(
                                  'https://www.facebook.com/sharer/sharer.php?u=http://localhost:61122/home/products/product-detail/${product.uniqueId}'));
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  FontAwesomeIcons.facebookF,
                                  color: Colors
                                      .white, // You can change the icon color as needed
                                ),
                              ),
                            ),
                          ),
                          Text(
                            ' ',
                            style: Theme.of(context).textTheme.bodyText2,
                          )
                        ],
                      ),
                    ],
                  ),
                  // Column(
                  //   children: [
                  //     Column(
                  //       children: [
                  //         ElevatedButton(
                  //           style: ElevatedButton.styleFrom(
                  //             primary: Colors
                  //                 .transparent, // Make the button background transparent
                  //             shape: const CircleBorder(),
                  //             padding: const EdgeInsets.all(0), // No padding
                  //           ),
                  //           onPressed: () {
                  //             // TODO: Uri.base is usable only on the web
                  //             // on mobile, the url base needs to be fetched from elsewhere

                  //             Share.share('text');

                  //           },
                  //           child: Ink(
                  //             width: 48, // Adjust the width as needed
                  //             height: 48, // Adjust the height as needed
                  //             decoration: BoxDecoration(
                  //               shape: BoxShape.circle,
                  //               gradient: LinearGradient(
                  //                 colors: [
                  //                   Color.fromARGB(
                  //                       255, 131, 58, 180), // Instagram purple
                  //                   Color.fromARGB(
                  //                       255, 253, 29, 29), // Instagram pink
                  //                   Color.fromARGB(
                  //                       255, 252, 176, 69), // Instagram orange
                  //                 ],
                  //                 begin: Alignment.topLeft,
                  //                 end: Alignment.bottomRight,
                  //               ),
                  //             ),
                  //             child: Center(
                  //               child: Icon(
                  //                 FontAwesomeIcons.instagram,
                  //                 color: Colors
                  //                     .white, // You can change the icon color as needed
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //         Text(
                  //           ' ',
                  //           style: Theme.of(context).textTheme.bodyText2,
                  //         )
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  Column(
                    children: [
                      Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(
                                  255, 29, 161, 242), // Facebook blue color
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                            ),
                            onPressed: () async {
                              // TODO: Uri.base is usable only on the web
                              // on mobile, the url base needs to be fetched from elsewhere
                              await logShare(ref, 'twitter', product.name);
                              await launchUrl(Uri.parse(
                                  'https://twitter.com/share?url=http://localhost:61122/home/products/product-detail/${product.uniqueId}'));
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  FontAwesomeIcons.twitter,
                                  color: Colors
                                      .white, // You can change the icon color as needed
                                ),
                              ),
                            ),
                          ),
                          Text(
                            ' ',
                            style: Theme.of(context).textTheme.bodyText2,
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(
                                  255, 14, 118, 168), // Facebook blue color
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                            ),
                            onPressed: () async {
                              // TODO: Uri.base is usable only on the web
                              // on mobile, the url base needs to be fetched from elsewhere
                              await logShare(ref, 'linkedin', product.name);
                              await launchUrl(Uri.parse(
                                  'https://www.linkedin.com/shareArticle?url=http://localhost:61122/home/products/product-detail/${product.uniqueId}'));
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  FontAwesomeIcons.linkedin,
                                  color: Colors
                                      .white, // You can change the icon color as needed
                                ),
                              ),
                            ),
                          ),
                          Text(
                            ' ',
                            style: Theme.of(context).textTheme.bodyText2,
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(
                                  255, 43, 183, 65), // Facebook blue color
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                            ),
                            onPressed: () async {
                              // TODO: Uri.base is usable only on the web
                              // on mobile, the url base needs to be fetched from elsewhere
                              await logShare(ref, 'whatsapp', product.name);
                              await launchUrl(Uri.parse(
                                  'https://api.whatsapp.com/send?text=http://localhost:61122/home/products/product-detail/${product.uniqueId}'));
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  FontAwesomeIcons.whatsapp,
                                  color: Colors
                                      .white, // You can change the icon color as needed
                                ),
                              ),
                            ),
                          ),
                          Text(
                            ' ',
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
