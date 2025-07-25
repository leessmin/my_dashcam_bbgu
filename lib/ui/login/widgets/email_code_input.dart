import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_dashcam/ui/core/themes/catppuccin.dart';

class EmailCodeInput extends StatefulWidget {
  const EmailCodeInput({super.key});

  @override
  State<EmailCodeInput> createState() => _EmailCodeInputState();
}

class _EmailCodeInputState extends State<EmailCodeInput> {
  int _count = 60;
  Timer? _timer;

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "验证码",
        suffixIcon: _count != 60
            ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "${_count}s后重新发送",
                  style: TextStyle(
                    color: getCatppuccinByCtx(context).lavender,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : TextButton(
                onPressed: () {
                  if (_count == 60) {
                    debugPrint("TODO:发送验证码请求");
                    setState(() {
                      _count--;
                    });
                    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
                      setState(() {
                        _count--;
                        if (_count <= 0) {
                          _count = 60;
                          _timer?.cancel();
                        }
                      });
                    });
                  }
                },
                child: Text(
                  "获取验证码",
                  style: TextStyle(color: getCatppuccinByCtx(context).lavender),
                ),
              ),
      ),
    );
  }
}
