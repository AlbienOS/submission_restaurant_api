import 'package:flutter/widgets.dart';

class PlatformWidget extends StatelessWidget{
  final WidgetBuilder androidBuilder;

  PlatformWidget({
    required this.androidBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return androidBuilder(context);
  }
}