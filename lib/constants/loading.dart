import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'constants.dart';

class Loading extends StatelessWidget {
  //const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primary_bg_color,
      child: Center(
        child: SpinKitChasingDots(
          color: primary_green,
          size: 50.0,
        ),
      ),
    );
  }
}
