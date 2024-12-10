import 'package:flutter/material.dart';
import 'package:flutter_firebase/themes/constant.dart';

class ErrorBox extends StatelessWidget {
  const ErrorBox({
    super.key,
    required this.errorMsg,
  });

  final String errorMsg;

  @override
  Widget build(BuildContext context) {
    return errorMsg.isEmpty
        ? Container()
        : Container(
            width: double.infinity,
            margin:
                const EdgeInsets.symmetric(vertical: kPadding, horizontal: 8),
            padding: const EdgeInsets.all(kPadding),
            color: Colors.pink.shade50,
            child:
                Text(errorMsg, style: Theme.of(context).textTheme.bodyMedium!),
          );
  }
}
