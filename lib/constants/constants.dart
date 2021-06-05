import 'package:flutter/material.dart';

const primary_bg_color = Color(0XFF141526);
const secondary_bg_color = Color(0XFF152238);

const primary_green = Color(0XFF31ff2e);
const secondary_green = Color(0XFF11FFBD);
const danger_color = Color(0XFFFF0800);

LinearGradient getGradient(status, charge) {
  print(charge);
  const bg_gradient = LinearGradient(
    colors: [primary_green, secondary_green, primary_bg_color],
    begin: const Alignment(0.0, 0.0),
    end: const Alignment(0.0, -1.0),
    tileMode: TileMode.clamp,
    stops: [0.2, 0.8, 1.0],
  );

  return bg_gradient;
}
