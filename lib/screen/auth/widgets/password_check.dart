import 'package:flutter/material.dart';
import 'package:flutter_firebase/themes/constant.dart';

class PasswordCheck extends StatelessWidget {
  const PasswordCheck({
    super.key,
    required bool isPasswordCharacters,
    required bool hasPasswordOneNumber,
  })  : _isPasswordCharacters = isPasswordCharacters,
        _hasPasswordOneNumber = hasPasswordOneNumber;

  final bool _isPasswordCharacters;
  final bool _hasPasswordOneNumber;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 12, top: 4),
      child: Column(
        children: [
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    color:
                        _isPasswordCharacters ? kGreenColor : kTransparentColor,
                    border: _isPasswordCharacters
                        ? Border.all(color: kTransparentColor)
                        : Border.all(color: kGreyColor.shade400),
                    borderRadius: BorderRadius.circular(50)),
                child: const Center(
                  child: Icon(
                    Icons.check,
                    color: kWhiteColor,
                    size: 15,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "Contains at least 6 characters",
                style: TextStyle(
                  color: _isPasswordCharacters ? kGreenColor : kGreyColor,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    color:
                        _hasPasswordOneNumber ? kGreenColor : kTransparentColor,
                    border: _hasPasswordOneNumber
                        ? Border.all(color: kTransparentColor)
                        : Border.all(color: kGreyColor.shade400),
                    borderRadius: BorderRadius.circular(50)),
                child: const Center(
                  child: Icon(
                    Icons.check,
                    color: kWhiteColor,
                    size: 15,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "Contains at least 1 number",
                style: TextStyle(
                  color: _hasPasswordOneNumber ? kGreenColor : kGreyColor,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
