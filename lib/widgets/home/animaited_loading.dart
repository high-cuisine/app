import 'package:flutter/material.dart';

import '../../pages/home/search_cocktail_page.dart';

class AnimatedProgressBarPage extends StatefulWidget {
  const AnimatedProgressBarPage({super.key});

  @override
  AnimatedProgressBarPageState createState() => AnimatedProgressBarPageState();
}

class AnimatedProgressBarPageState extends State<AnimatedProgressBarPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2), // Changed to 2 seconds
      vsync: this,
    )..addListener(() {
        if (_animationController.isCompleted) {
          Future.delayed(const Duration(seconds: 2), () {
            // Переход на CocktailListPage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchCocktailPage(),
              ),
            );
          });
        }
      });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade800,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: LinearProgressIndicator(
                              value: _animationController.value,
                              backgroundColor: Colors.transparent,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.transparent),
                              minHeight: 24,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width *
                              0.85 *
                              _animationController.value,
                          height: 24,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFDD66A9),
                                Color(0xFFF8C82C),
                                Color(0xFFEF7F31),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        Positioned(
                          top: -30,
                          // Adjust the position of the text above the bar
                          left: MediaQuery.of(context).size.width *
                                  0.85 *
                                  _animationController.value -
                              30,
                          // Adjust to align text with the progress
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${(_animationController.value * 100).toInt()}%',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
