import 'package:flutter/material.dart';
import 'package:flutter_firebase/model/message_model.dart';
import 'package:flutter_firebase/themes/constant.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBox extends StatelessWidget {
  const ChatBox({
    super.key,
    required this.message,
    required this.onLongPress,
  });

  final Message message;
  final Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width / 1.3;
    bool isBot = message.userid == '0';

    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        padding: isBot
            ? const EdgeInsets.only(left: 6)
            : const EdgeInsets.only(right: 6),
        margin: const EdgeInsets.only(top: 12),
        child: Column(
          crossAxisAlignment:
              isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            isBot
                ? const Text(
                    'GPT',
                    style: TextStyle(
                        color: kGreyColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.4),
                  )
                : Container(),
            const SizedBox(height: 3),
            Container(
              constraints: BoxConstraints(maxWidth: size),
              padding: const EdgeInsets.symmetric(
                  vertical: 10, horizontal: kPadding),
              decoration: isBot
                  ? BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: kGreyColor.shade300,
                          offset: const Offset(0, 1),
                          blurRadius: 2.0,
                        ),
                      ],
                      color: kWhiteColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(5),
                      ),
                    )
                  : BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(kPadding),
                        bottomLeft: Radius.circular(kPadding),
                        topRight: Radius.circular(kPadding),
                      ),
                      color: kSecondaryColor.shade50),
              child: isBot
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: SelectableLinkify(
                            scrollPhysics: const NeverScrollableScrollPhysics(),
                            onOpen: (LinkableElement link) async {
                              await launchUrl(Uri.parse(link.url));
                            },
                            text: message.message,
                            style: TextStyle(color: kGreyColor.shade800),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      message.message,
                      style: const TextStyle(color: kBlackColor),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                DateFormat.jm().format(message.createdAt),
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
