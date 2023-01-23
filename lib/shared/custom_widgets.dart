import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  final String? errorText;
  final VoidCallback? onPressed;

  const AppErrorWidget({this.errorText, this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(errorText ?? 'Something went wrong'),
        onPressed != null ? TextButton(onPressed: onPressed, child: Text('Retry')) : Container(),
      ],
    );
  }
}
