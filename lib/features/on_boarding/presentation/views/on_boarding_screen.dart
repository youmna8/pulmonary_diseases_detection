import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pulmunary_diseases_detection/core/commons/commons.dart';

import 'package:pulmunary_diseases_detection/core/widget/elevated_button.dart';
import 'package:pulmunary_diseases_detection/core/widget/text_button.dart';
import 'package:pulmunary_diseases_detection/features/on_boarding/data/on_boarding_model.dart';
import 'package:pulmunary_diseases_detection/features/doctor/presentation/views/login_screen.dart';
import 'package:pulmunary_diseases_detection/features/home/presentation/screens/docoradmin.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ignore: must_be_immutable
class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({super.key});
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Color(0xff39D2C0)),
          child: PageView.builder(
            controller: controller,
            itemCount: OnBoardingModel.OnBoardingScreens.length,
            itemBuilder: ((context, index) {
              return Column(
                children: [
                  Image.asset(
                    OnBoardingModel.OnBoardingScreens[index].img,
                    fit: BoxFit.fill,
                    height: 280,
                    width: double.infinity,
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  SmoothPageIndicator(
                    controller: controller,
                    count: 3,
                    effect: ExpandingDotsEffect(
                        dotColor: Colors.white,
                        activeDotColor: Color.fromARGB(255, 78, 220, 198),
                        dotHeight: 10,
                        spacing: 8),
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          OnBoardingModel.OnBoardingScreens[index].title,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontFamily: 'GT Sectra Fine'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 90.h,
                  ),
                  Row(children: [
                    index != 2
                        ? Align(
                            alignment: Alignment.topLeft,
                            child: MyTextButton(
                              text: ('Skip'),
                              onPressed: () {
                                controller.jumpToPage(2);
                              },
                            ),
                          )
                        : SizedBox(
                            height: 50.h,
                          ),
                    const Spacer(),
                    index != 2
                        ? Padding(
                            padding: EdgeInsets.all(24),
                            child: MyElevatedButton(
                              text: ('Next'),
                              onPressed: () {
                                controller.nextPage(
                                    duration:
                                        const Duration(microseconds: 1000),
                                    curve: Curves.fastLinearToSlowEaseIn);
                              },
                            ),
                          )
                        : MyElevatedButton(
                            text: ('Start'),
                            onPressed: () {
                              navigate(
                                  context: context, screen: AdminORDoctor());
                            },
                          )
                  ])
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
