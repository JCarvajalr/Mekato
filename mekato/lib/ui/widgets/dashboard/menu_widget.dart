import 'package:flutter/material.dart';
import 'package:mekato/ui/core/mekato_styles.dart';
import 'package:mekato/ui/widgets/cards/item_card_m.dart';

class MenuWidget extends StatefulWidget {
  final double xpadding;
  const MenuWidget({super.key, required this.xpadding});

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: widget.xpadding),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Text("Menu", style: MekatoStyles.textTitle1),
              SizedBox(width: 20),
              Icon(Icons.arrow_right_alt_rounded, color: Colors.black),
            ],
          ),
          SizedBox(height: 15),
          SizedBox(
            height: 145,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 9,
              itemBuilder: (context, index) {
                // final item = items[index];
                return Row(
                  children: [
                    ItemCardM(
                      imagePath: "assets/images/hamb.jpg",
                      title: "Hamburguesa especial",
                    ),
                    SizedBox(
                      width: 14,
                    ), // Espaciado entre tarjetas, excepto después de la última
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
