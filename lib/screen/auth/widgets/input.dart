import 'package:flutter/material.dart';
import 'package:flutter_firebase/themes/constant.dart';

class Input extends StatefulWidget {
  final String labelText;
  final String initialValue;
  final Function(String)? onSaved;
  final Function(String)? onChanged;
  final String? inputType; // 'password', 'email'
  final Widget? suffixIcon;
  final bool readonly;
  final bool obscureText;
  final bool autofocus;

  const Input({
    super.key,
    required this.labelText,
    this.initialValue = '',
    this.onSaved,
    this.onChanged,
    this.inputType,
    this.suffixIcon,
    this.readonly = false,
    this.obscureText = false,
    this.autofocus = false,
  });

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 6),
          TextFormField(
            autofocus: widget.autofocus,
            readOnly: widget.readonly,
            initialValue: widget.initialValue,
            obscureText: widget.obscureText,
            keyboardType: TextInputType.emailAddress,
            textCapitalization:
                widget.inputType == 'email' || widget.inputType == 'password'
                    ? TextCapitalization.none
                    : TextCapitalization.words,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }

              return null;
            },
            textAlignVertical: TextAlignVertical.center,
            textInputAction: TextInputAction.next,
            style: const TextStyle(letterSpacing: .6),
            textAlign: TextAlign.start,
            onSaved: (newValue) {
              if (widget.onSaved != null) {
                widget.onSaved!(newValue ?? '');
              }
            },
            onChanged: (value) {
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor:
                  widget.readonly ? kGreyColor.withOpacity(.1) : kWhiteColor,
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: kGreyColor.shade300, width: 1),
              ),
              suffixIcon: widget.suffixIcon,
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: kGreyColor.shade200, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                borderSide:
                    BorderSide(color: kSecondaryColor.shade200, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
