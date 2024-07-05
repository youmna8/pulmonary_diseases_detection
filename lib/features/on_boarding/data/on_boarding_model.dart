class OnBoardingModel {
  final String img;
  final String title;

  OnBoardingModel({
    required this.img,
    required this.title,
  });
  static List<OnBoardingModel> OnBoardingScreens = [
    OnBoardingModel(
        img: 'assets/images/Frame 170 (2).png',
        title:
            'Using modern technology,can be developed for the early detection.'),
    OnBoardingModel(
        img: 'assets/images/Frame 170 (1).png',
        title:
            'Early detection is crucial for intervention and effective treatment. '),
    OnBoardingModel(
        img: 'assets/images/Frame 170.png',
        title:
            'Learning a lot about the disease and using respiratory medications.'),
  ];
}
