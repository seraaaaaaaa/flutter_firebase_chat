import 'package:flutter/material.dart';
import 'package:flutter_firebase/themes/constant.dart';

class NoData extends StatelessWidget {
  const NoData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: width / 1.5,
              padding: const EdgeInsets.symmetric(
                  horizontal: kPadding, vertical: 12),
              decoration: BoxDecoration(
                  color: kGreyColor.shade50,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: kGreyColor.shade300,
                      offset: const Offset(1, 2),
                      blurRadius: 3,
                    ),
                  ]),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: Icon(
                      Icons.chat,
                      color: kPrimaryColor.withOpacity(.4),
                      size: 28,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: kGreyColor.shade200,
                          ),
                          height: 14,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: kGreyColor.shade200,
                          ),
                          height: 14,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: kPadding),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: width / 1.5,
              padding: const EdgeInsets.symmetric(
                  horizontal: kPadding, vertical: 12),
              decoration: BoxDecoration(
                  color: kGreyColor.shade50,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: kGreyColor.shade300,
                      offset: const Offset(1, 2),
                      blurRadius: 3,
                    ),
                  ]),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: Icon(
                      Icons.chat,
                      color: Colors.cyan.withOpacity(.4),
                      size: 28,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: kGreyColor.shade200,
                          ),
                          height: 14,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: kGreyColor.shade200,
                          ),
                          height: 14,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              'No Chat History',
              style:
                  TextStyle(letterSpacing: .4, color: kGreyColor, height: 1.4),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
