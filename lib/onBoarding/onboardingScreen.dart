import 'package:flutter/material.dart';
import 'package:provider_shopping/components/contents.dart';
import 'package:provider_shopping/screens/product_list.dart';

class Onboardingscreen extends StatefulWidget {
  const Onboardingscreen({super.key});

  @override
  State<Onboardingscreen> createState() => _OnboardingscreenState();
}

class _OnboardingscreenState extends State<Onboardingscreen> {
  int currentIndex = 0;
  PageController _controller = PageController();
  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: 3,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        height: 300,
                        image: AssetImage(
                          onboardingContent[i].imageAsset,
                        ),
                      ),
                      Text(
                        onboardingContent[i].title,
                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        onboardingContent[i].description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingContent.length,
                (index) => buildDot(index),
              ),
            ),
          ),
          Container(
            height: 55,
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orange.shade800,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 2,
                color: Colors.black,
              ),
            ),
            child: TextButton(
              onPressed: () {
                if (currentIndex == onboardingContent.length - 1) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProductList(),
                      ));
                }
                _controller.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear,
                );
              },
              child: Text(
                currentIndex == onboardingContent.length - 1
                    ? "Continue"
                    : "Next",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildDot(int index) {
    return Container(
      height: 10,
      width: currentIndex == index ? 20 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: Colors.orange.shade800,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
