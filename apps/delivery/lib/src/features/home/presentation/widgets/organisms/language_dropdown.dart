import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/core/data/services/shared_preferences_service.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/widgets/dropdown.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LanguageDropdown extends HookConsumerWidget {
  const LanguageDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropDown<LanguageMode>(
      showUnderline: false,
      items: LanguageMode.values,
      customWidgets: [
        Align(
          alignment: Alignment.center,
          child: SvgPicture.asset(
            kLanguageFlagsMap[LanguageMode.en]!,
            height: 16,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: SvgPicture.asset(
            kLanguageFlagsMap[LanguageMode.sk]!,
            height: 16,
          ),
        ),
      ],
      initialValue: ref.watch(
        sharedPreferencesProvider.select((value) => value.getAppLanguage()),
      ),
      onChanged: (value) async {
        await ref.read(sharedPreferencesProvider).setAppLocale(value!);
        await ref
            .read(userRepositoryProvider)
            .onUserChangedPreferredLanguage(value);
        ref.refresh(sharedPreferencesProvider);
      },
    );
  }
}
