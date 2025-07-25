import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  const PasswordInput({super.key});

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool isShowPwd = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isShowPwd,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "密码",
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              isShowPwd = !isShowPwd;
            });
          },
          icon: Icon(isShowPwd ? Icons.visibility_off : Icons.visibility),
        ),
      ),
    );
  }
}
