import 'package:flutter/material.dart';
import 'package:mekato/ui/core/mekato_styles.dart';

class OffersWidget extends StatefulWidget {
  final double xpadding;
  // final verPadding;
  const OffersWidget({super.key, required this.xpadding});

  @override
  State<OffersWidget> createState() => _OffersWidgetState();
}

class _OffersWidgetState extends State<OffersWidget> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int _length = 3;

    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: widget.xpadding),
          child: Row(
            children: [
              Text("¡Promociones!", style: MekatoStyles.textTitle1),
              SizedBox(width: 20),
              Icon(Icons.arrow_right_alt_rounded, color: Colors.black),
              SizedBox(width: 12),
            ],
          ),
        ),
        SizedBox(height: 15),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              double scale = _currentPage == index ? 1.0 : 0.8;
              double opacity = _currentPage == index ? 1.0 : 0.6;
              return AnimatedScale(
                scale: scale,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Opacity(
                  opacity: opacity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      "assets/images/publicidad.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? Colors.blueGrey[500]
                    : Colors.blueGrey[100],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
