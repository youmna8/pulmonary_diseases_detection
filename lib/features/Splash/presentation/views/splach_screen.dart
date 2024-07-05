import 'package:flutter/material.dart';
import 'package:pulmunary_diseases_detection/features/Splash/presentation/views/widget/SlidingText.dart';
import 'package:pulmunary_diseases_detection/features/on_boarding/presentation/views/on_boarding_screen.dart';

class SplachScreen extends StatefulWidget {
  const SplachScreen({Key? key}) : super(key: key);

  @override
  State<SplachScreen> createState() => _SplachScreenState();
}

class _SplachScreenState extends State<SplachScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slidingAnimation;
  @override
  void initState() {
    initSlidingAnimation();
    navigate();
    super.initState();
  }

  void navigate() {
    Future.delayed(
      const Duration(seconds: 5),
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return OnBoardingScreen();
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(color: Color(0xff39D2C0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
              'assets/images/beam-registration-of-medical-insurance.gif'),
          SlidingText(slidingAnimation: slidingAnimation)
        ],
      ),
    )));
  }

  void initSlidingAnimation() {
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    slidingAnimation = Tween<Offset>(begin: Offset(0, 10), end: Offset.zero)
        .animate(animationController);
    animationController.forward();
  }
}
