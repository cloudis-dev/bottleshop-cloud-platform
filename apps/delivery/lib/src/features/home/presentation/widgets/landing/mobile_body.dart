import 'package:delivery/src/features/home/presentation/widgets/landing/body_sections/brand_section/brand_mobile_section.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/body_sections/download_app_section/download_app_mobile_section.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/body_sections/favourite_brands/favourite_brands_mobile_section.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/body_sections/feature_section/feature_mobile_section.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/body_sections/main_section/main_mobile_section.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/body_sections/rum_section/rum_mobile_section.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/body_sections/whiskey_section/whiskey_section_mobile.dart';
import 'package:flutter/material.dart';

class MobileBody extends StatelessWidget {
  const MobileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate([
      MainMobileSection(),
      FeatureMobileSection(),
      RumMobileSection(),
      BrandMobileSection(),
      WhiskeyMobileSection(),
      FavouriteBrandsMobileSection(),
      DownloadAppMobileSection(),
    ]));
  }
}
