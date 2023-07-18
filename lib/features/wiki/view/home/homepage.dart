import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:infoware_test/features/wiki/view/home/home_page_desktop.dart';
import 'package:infoware_test/features/wiki/view/home/home_page_mobile.dart';
import 'package:infoware_test/features/wiki/view/home/home_page_tablet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
          return const HomePageDesktop();
        }

        if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
          return const HomePageTablet();
        }

        return const HomePageMobile();
      },
    );
  }
}
