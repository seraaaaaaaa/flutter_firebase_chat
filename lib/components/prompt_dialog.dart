import 'package:flutter/material.dart';
import 'package:flutter_firebase/themes/constant.dart';

class PromptDialog extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const PromptDialog({
    super.key,
    this.icon,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    Widget cancelButton = TextButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: kGreyColor.shade200,
        foregroundColor: kSecondaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      ),
      onPressed: onCancel,
      child: const Text("No"),
    );

    Widget confirmButton = TextButton(
      style: TextButton.styleFrom(
        backgroundColor: kRedColor,
        foregroundColor: kWhiteColor,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      ),
      onPressed: onConfirm,
      child: const Text("Yes"),
    );

    return AlertDialog(
      icon: Icon(
        icon ?? Icons.auto_delete_outlined,
        color: kRedColor,
        size: 40,
      ),
      iconPadding: const EdgeInsets.only(top: 34, bottom: 10),
      title: Text(title),
      content: Text(
        content,
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        cancelButton,
        const SizedBox(width: 10),
        confirmButton,
      ],
    );
  }
}
