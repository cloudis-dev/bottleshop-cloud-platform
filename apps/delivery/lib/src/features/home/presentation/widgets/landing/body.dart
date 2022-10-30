import 'package:delivery/src/features/home/presentation/widgets/landing/body_sections/brand_section/brand_section.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/body_sections/favourite_brands_section.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/body_sections/feature_section/feature_section.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/body_sections/main_section.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/body_sections/mobile_app_section/mobile_app_section.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/body_sections/rum_section.dart';
import 'package:delivery/src/features/home/presentation/widgets/landing/body_sections/whiskey_section.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate.fixed([
      MainSection(),
      FeatureSection(),
      RumSection(),
      BrandSection(),
      WhiskeySection(),
      FavouriteBrandsSection(),
      MobileAppSection(),
    ]));
  }
}
