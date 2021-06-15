import 'package:flutter/material.dart';

const primary_bg_color = Color(0XFF141526);
const secondary_bg_color = Color(0XFF152238);

const primary_green = Color(0XFF31ff2e);
const secondary_green = Color(0XFF11FFBD);
const danger_color = Color(0XFFFF0800);

LinearGradient getGradient(charge) {
  var bg_gradient = LinearGradient(
    colors: getColors(charge),
    begin: const Alignment(-1.0, 1.0),
    end: getEndAlignment(charge),
    stops: [0.70, 0.95, 1.0],
  );

  return bg_gradient;
}


const formFields = InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: secondary_green, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
    ));

Alignment getEndAlignment(charge) {
  double start = -1;
  double end = 0;
  double value = (charge / 100).toDouble();
  switch ((value * 10).round()) {
    case 0:
      end = -1.5;
      break;
    case 1:
      end = 0.7;
      break;
    case 2:
      end = 0.5;
      break;
    case 3:
      end = 0.3;
      break;
    case 4:
      end = 0.1;
      break;
    case 5:
      end = -0.1;
      break;
    case 6:
      end = -0.3;
      break;
    case 7:
      end = -0.5;
      break;
    case 8:
      end = -0.7;
      break;
    case 9:
      end = -0.9;
      break;
    case 10:
      end = -1.2;
      break;
    default:
      end = 0.0;
      break;
  }
  return Alignment(start, end);
}

List<Color> getColors(charge) {
  if (charge < 10) {
    return [danger_color, danger_color, danger_color];
  } else if (charge > 10) {
    return [primary_green, secondary_green, primary_bg_color];
  }else{
    return [danger_color, danger_color, primary_bg_color];
  }
  
}

