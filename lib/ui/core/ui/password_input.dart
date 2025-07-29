import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  const PasswordInput({
    super.key,
    this.labelText = "密码",
    required this.controller,
    required this.validator,
  });

  final String labelText;
  final TextEditingController controller;
  final String? Function(String?) validator;

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool isShowPwd = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: isShowPwd,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: widget.labelText,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              isShowPwd = !isShowPwd;
            });
          },
          icon: Icon(isShowPwd ? Icons.visibility_off : Icons.visibility),
        ),
      ),
      validator: widget.validator,
    );
  }
}
