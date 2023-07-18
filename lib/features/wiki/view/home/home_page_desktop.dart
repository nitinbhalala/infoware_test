// ignore_for_file: avoid_print, non_constant_identifier_names, must_be_immutable, no_leading_underscores_for_local_identifiers

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:sizer/sizer.dart';
import 'package:infoware_test/features/wiki/bloc/HomeBloc/home_bloc.dart';
import 'package:infoware_test/features/wiki/bloc/HomeBloc/home_event.dart';
import 'package:infoware_test/features/wiki/bloc/HomeBloc/home_state.dart';
import 'package:infoware_test/features/wiki/view/addarticle/add_article.dart';
import 'package:infoware_test/features/wiki/view/viewarticle/view_article_page.dart';
import 'package:infoware_test/repos/article_repository.dart';
import 'package:infoware_test/utils/color.dart';
import 'package:infoware_test/utils/imageurl.dart';
import 'package:infoware_test/utils/string.dart';
import 'package:infoware_test/widgets/widget.dart';

class HomePageDesktop extends StatefulWidget {
  const HomePageDesktop({
    super.key,
  });

  @override
  State<HomePageDesktop> createState() => _HomePageDesktopState();
}

class _HomePageDesktopState extends State<HomePageDesktop> {
  bool isOpened = false;

  HomeBloc homeBloc = HomeBloc(ArticleRepository());
  final GlobalKey<SideMenuState> sideMenuKey = GlobalKey<SideMenuState>();
  final GlobalKey<SideMenuState> endSideMenuKey = GlobalKey<SideMenuState>();
  TextEditingController searchArticle = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => homeBloc..add(LoadApiEvent()),
      child: SideMenu(
        maxMenuWidth: 60.w,
        background: AppColor.primary,
        type: SideMenuType.shrinkNSlide,
        key: endSideMenuKey,
        onChange: (_isOpened) {
          setState(() {
            isOpened = _isOpened;
          });
        },
        menu: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UserAccountsDrawerHeader(
              currentAccountPictureSize: const Size.square(50),
              currentAccountPicture: CircleAvatar(
                  backgroundColor: AppColor.whiteColor,
                  child: Icon(
                    Icons.person,
                    color: AppColor.primary,
                    size: 4.h,
                  )), //circleAvatar
              decoration: BoxDecoration(color: AppColor.primary),
              accountName: appText(title: "Test App", fontSize: 3.h),
              accountEmail: appText(title: "testapp@gmail.com", fontSize: 2.h),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 2.h, left: 3.w),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: appText(
                    title: "version: 1.0.0",
                    color: AppColor.whiteColor,
                    fontSize: 2.h),
              ),
            ),
          ],
        ),
        child: Scaffold(
          backgroundColor: AppColor.whiteColor,
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: InkWell(
                onTap: () {
                  final _state = endSideMenuKey.currentState!;
                  if (_state.isOpened) {
                    _state.closeSideMenu();
                  } else {
                    _state.openSideMenu();
                  }
                },
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 0.7.w, vertical: 0.6.h),
                  child: ImageIcon(
                    const AssetImage(AppImage.menu),
                    color: AppColor.whiteColor,
                    size: 4.h,
                  ),
                )),
            title:
                appText(title: AppSatring.wikilist, color: AppColor.whiteColor),
            backgroundColor: AppColor.primary,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddArticlePage(type: false)));
                  },
                  child: const ImageIcon(
                    AssetImage(AppImage.createnewicon),
                  ),
                ),
              ),
            ],
          ),
          body: BlocConsumer<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is HomeErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is HomeLoadedState) {
                if (state.articlelist.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 3.h),
                        child: SizedBox(
                          height: 7.h,
                          child: CupertinoSearchTextField(
                            controller: searchArticle,
                            onChanged: (String value) {
                              homeBloc.add(LoadSearchArticleEvent(value));
                            },
                          ),
                        ),
                      ),
                      Center(
                        child:
                            appText(title: "No Article", color: AppColor.grey),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 3.h),
                        child: SizedBox(
                          height: 7.h,
                          child: CupertinoSearchTextField(
                            controller: searchArticle,
                            onChanged: (String value) {
                              homeBloc.add(LoadSearchArticleEvent(value));
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: ListView.builder(
                              shrinkWrap: true,
                              reverse: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.articlelist.length,
                              itemBuilder: (BuildContext context, int index) {
                                var articleData = state.articlelist[index];
                                print("articleData : $articleData");
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => ViewArticlePage(
                                              articleData: articleData),
                                        ));
                                  },
                                  child: AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 400),
                                    child: SlideAnimation(
                                      verticalOffset: 44,
                                      child: FadeInAnimation(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 1.5.w, vertical: 2.h),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5.w, vertical: 2.h),
                                          decoration: BoxDecoration(
                                            color: AppColor.whiteColor,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: AppColor.grey
                                                      .withOpacity(0.6),
                                                  blurRadius: 15,
                                                  offset: const Offset(1, 2))
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(1.w),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              DefaultTextStyle(
                                                style: TextStyle(
                                                    fontSize: 3.3.h,
                                                    color: AppColor.whiteColor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                child: AnimatedTextKit(
                                                  animatedTexts: [
                                                    WavyAnimatedText(
                                                        articleData.title),
                                                  ],
                                                  isRepeatingAnimation: true,
                                                ),
                                              ),
                                              SizedBox(height: 1.5.h),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 0.2.w),
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                      child: appText(
                                                        title: articleData
                                                            .shortdescription,
                                                        fontSize: 2.h,
                                                        color: AppColor
                                                            .whiteColor
                                                            .withOpacity(0.7),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 1.5.h),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AddArticlePage(
                                                                      type:
                                                                          true,
                                                                      index:
                                                                          index,
                                                                      articleData:
                                                                          articleData)));
                                                    },
                                                    child: ImageIcon(
                                                      const AssetImage(
                                                          AppImage.editicon),
                                                      size: 2.7.h,
                                                      color:
                                                          AppColor.whiteColor,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 2.w,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      homeBloc.add(
                                                          LoadDeleteArticleEvent(
                                                              index));
                                                    },
                                                    child: ImageIcon(
                                                      const AssetImage(
                                                          AppImage.deleticon),
                                                      size: 2.7.h,
                                                      color:
                                                          AppColor.whiteColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  );
                }
              }
              if (state is HomeLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Center(
                child: appText(title: "No Article", color: AppColor.grey),
              );
            },
          ),
        ),
      ),
    );
  }
}
