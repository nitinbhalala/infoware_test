import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:infoware_test/features/wiki/bloc/MainBloc/main_bloc.dart';
import 'package:infoware_test/features/wiki/view/addarticle/add_article.dart';
import 'package:infoware_test/models/databaseModel.dart';
import 'package:infoware_test/utils/color.dart';
import 'package:infoware_test/utils/string.dart';
import 'package:infoware_test/features/wiki/view/home/homepage.dart';
import 'package:infoware_test/features/wiki/view/splashscreen.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  WidgetsFlutterBinding.ensureInitialized();

  /// Open box using Hive & Initializ
  await Hive.initFlutter();
  Hive.registerAdapter<Articlemodel>(ArticlemodelAdapter());
  await Hive.openBox<Articlemodel>("WikiBox");

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loginstatus = false;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InternetBloc(),
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: AppSatring.appName,
            theme: ThemeData(
              canvasColor: AppColor.whiteColor,
              primaryColor: AppColor.primary,
            ),
            routerConfig: _router,
          );
        },
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: "/homepage",
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: "/addarticlepage",
      builder: (context, state) => AddArticlePage(),
    ),
  ],
);
