import 'package:flutter/material.dart';
import 'package:mekato/data/utils/menu.dart';
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
          SizedBox(height: 8),
          SizedBox(
            height: 145,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: menu.length,
              itemBuilder: (context, index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ItemCardM(
                      imagePath: "assets/images/${menu[index].imagePath}",
                      title: menu[index].name,
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
