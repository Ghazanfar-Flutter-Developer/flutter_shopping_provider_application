class OnboardingContent {
  final String title;
  final String description;
  final String imageAsset;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.imageAsset,
  });
}

List<OnboardingContent> onboardingContent = [
  OnboardingContent(
    title: 'Welcome Quality',
    description:
        'Quality fruits are those that are ripe, juicy, and have a vibrant color. They should be free from blemishes and have a firm texture. Good fruits are also packed with essential nutrients and vitamins, making them a healthy and delicious addition to your diet.',
    imageAsset: 'assets/images/onboarding-1.png',
  ),
  OnboardingContent(
    title: 'Explore Fresh Fruits',
    description:
        "Fresh fruits are nature's candy, bursting with vibrant colors and sweet flavors. They are packed with essential vitamins, minerals, and antioxidants that promote good health. From juicy berries to exotic tropical fruits, there's a world of delicious and nutritious options to explore.",
    imageAsset: 'assets/images/onboarding-2.png',
  ),
  OnboardingContent(
    title: 'Join Our Latin Fruit',
    description:
        'Discover a world of fresh and delicious fruits at your fingertips. Our app offers a convenient way to shop for the finest produce, delivered right to your doorstep. Enjoy hassle-free shopping, competitive prices, and the freshest fruits available. Join our community today and experience the joy of healthy eating!',
    imageAsset: 'assets/images/onboarding.png',
  ),
];
