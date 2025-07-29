import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_dashcam/data/repositories/emailCode/email_code_repository.dart';
import 'package:my_dashcam/ui/core/themes/catppuccin.dart';
import 'package:toastification/toastification.dart';

class EmailCodeInput extends StatefulWidget {
  EmailCodeInput({
    super.key,
    required this.controller,
    required this.validator,
    required this.getEmail,
  }) : emailCodeRepository = EmailCodeRepository();

  final TextEditingController controller;
  final String? Function(String?) validator;
  final EmailCodeRepository emailCodeRepository;
  // 获取邮箱函数
  final String Function() getEmail;

  @override
  State<EmailCodeInput> createState() => _EmailCodeInputState();
}

class _EmailCodeInputState extends State<EmailCodeInput> {
  int _count = 60;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
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
                    final email = widget.getEmail();
                    if (email == "" || email.isEmpty || !RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(email)) {
                      toastification.show(
                        context: context,
                        type: ToastificationType.warning,
                        title: Text('邮箱不合法'),
                        autoCloseDuration: const Duration(seconds: 3),
                      );
                      return;
                    }
                    widget.emailCodeRepository.getEmailCode(email);
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
      validator: widget.validator,
    );
  }
}
