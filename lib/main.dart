import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_shopping/onBoarding/onboardingScreen.dart';
import 'package:provider_shopping/provider/cart_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: Builder(
        builder: (BuildContext context) {
          return const MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            home: Onboardingscreen(),
          );
        },
      ),
    );
  }
}
