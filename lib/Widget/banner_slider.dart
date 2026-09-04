import 'dart:async';

import 'package:flutter/material.dart';

import '../Utils/constants.dart';
import '../Views/view_all_items.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> _bannerData = [
    {
      "title": "Cook the best\nrecipes at home",
      "button": "Explore",
      "image": "https://pngimg.com/d/chef_PNG190.png",
      "color": kBannerColor,
    },
    {
      "title": "Healthy Meals\nMade Easy & Fast",
      "button": "Discover",
      "image": "https://cdn-icons-png.flaticon.com/512/3143/3143643.png",
      "color": kprimaryColor,
    },
    {
      "title": "Special Holiday\nDessert Ideas",
      "button": "View All",
      "image": "https://cdn-icons-png.flaticon.com/512/883/883514.png",
      "color": const Color(0xffD97706),
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % _bannerData.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _bannerData.length,
            itemBuilder: (context, index) {
              final data = _bannerData[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: data['color'] as Color,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 28,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['title'] as String,
                            style: const TextStyle(
                              height: 1.1,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                              ),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ViewAllItems(),
                                ),
                              );
                            },
                            child: Text(
                              data['button'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: -10,
                      child: Image.network(
                        data['image'] as String,
                        width: 140,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _bannerData.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == index ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: _currentPage == index
                    ? kprimaryColor
                    : Colors.grey.shade300,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
