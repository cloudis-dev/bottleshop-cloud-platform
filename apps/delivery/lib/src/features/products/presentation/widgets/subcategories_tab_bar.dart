import 'package:delivery/src/core/data/models/categories_tree_model.dart';
import 'package:flutter/material.dart';

class SubcategoriesTabBar extends TabBar {
  // ignore: use_key_in_widget_constructors
  SubcategoriesTabBar(
    CategoriesTreeModel category,
    Widget allTab,
    Widget Function(CategoriesTreeModel) tabBuilder, {
    TabController? controller,
    Color? indicatorColor,
    bool isScrollable = false,
    TextStyle? unselectedLabelStyle,
    Color? labelColor,
    Color? unselectedLabelColor,
    TabBarIndicatorSize? indicatorSize,
    double indicatorWeight = 2,
  }) : super(
          indicatorWeight: indicatorWeight,
          indicatorSize: indicatorSize,
          unselectedLabelColor: unselectedLabelColor,
          labelColor: labelColor,
          unselectedLabelStyle: unselectedLabelStyle,
          isScrollable: isScrollable,
          indicatorColor: indicatorColor,
          controller: controller,
          tabs: <Widget>[allTab]
              .followedBy(
                List.generate(
                  category.subCategories.length,
                  (index) {
                    final subCategory = category.subCategories.elementAt(index);
                    return tabBuilder(subCategory);
                  },
                ),
              )
              .toList(),
        );
}
