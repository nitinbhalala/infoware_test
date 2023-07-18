// import 'package:dna/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:infoware_test/features/wiki/bloc/SplashBloc/splash_State.dart';
import 'package:infoware_test/utils/color.dart';
import 'package:infoware_test/utils/imageurl.dart';
import 'package:infoware_test/utils/string.dart';
import 'package:infoware_test/widgets/widget.dart';

import '../bloc/SplashBloc/splash_Bloc.dart';
import '../bloc/SplashBloc/splash_Event.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashBloc splashBloc = SplashBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BlocProvider<SplashBloc>(
        create: (context) => splashBloc..add(NavigateToHomeScreenEvent()),
        child: BlocConsumer<SplashBloc, SplashState>(
          listener: (context, state) {
            if (state is LoadedState) {
              context.go('/homepage');
            }
          },
          builder: (context, state) {
            return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.primary,
                      AppColor.black,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppImage.wikilogo,
                            height: 20.h,
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          appText(
                            title: AppSatring.appName,
                            fontWeight: FontWeight.w700,
                            color: AppColor.whiteColor,
                            fontSize: 3.h,
                          )
                        ],
                      ),
                    ),
                  ],
                ));
          },
        ),
      ),
    );
  }
}
