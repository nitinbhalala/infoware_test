// ignore_for_file: file_names, camel_case_types, must_be_immutable, non_constant_identifier_names, avoid_print, prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:infoware_test/features/wiki/view/viewarticle/view_article_desktop.dart';
import 'package:infoware_test/features/wiki/view/viewarticle/view_article_mobile.dart';
import 'package:infoware_test/features/wiki/view/viewarticle/view_article_tablet.dart';

class ViewArticlePage extends StatefulWidget {
  var articleData;

  ViewArticlePage({super.key, required this.articleData});

  @override
  State<ViewArticlePage> createState() => _ViewArticlePageState();
}

class _ViewArticlePageState extends State<ViewArticlePage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        // Check the sizing information here and return your UI
        if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
          return ViewArticleDesktop(articleData: widget.articleData);
        }

        if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
          return ViewArticleTablet(articleData: widget.articleData);
        }

        return ViewArticleMobile(articleData: widget.articleData);
      },
    );
  }
}
