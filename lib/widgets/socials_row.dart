import 'package:flutter/material.dart';
import 'package:webapp/widgets/github_icon.dart';
import 'package:webapp/widgets/mail_icon.dart';

class SocialsRow extends StatelessWidget {
  const SocialsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [GitHubIcon(), EmailIcon()],
    );
  }
}
