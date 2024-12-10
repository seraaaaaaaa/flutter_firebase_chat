import 'package:flutter/material.dart';
import 'package:flutter_firebase/themes/constant.dart';

class ScreenTitle extends StatelessWidget {
  const ScreenTitle({
    super.key,
    this.icon,
    this.title = '',
    this.desc = '',
    this.canPop = true,
  });

  final IconData? icon;
  final String title;
  final String desc;
  final bool canPop;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          canPop
              ? Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.keyboard_backspace),
                    ),
                  ],
                )
              : SizedBox(
                  height: AppBar().preferredSize.height,
                ),
          icon == null
              ? Container()
              : Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: kGreyColor.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 30,
                    color: kPrimaryColor,
                  ),
                ),
          const SizedBox(
            height: kPadding,
          ),
          title.isEmpty
              ? Container()
              : Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
          desc.isEmpty
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                    bottom: kPadding,
                  ),
                  child: Text(
                    desc,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: kGreyColor),
                  ),
                ),
        ],
      ),
    );
  }
}
