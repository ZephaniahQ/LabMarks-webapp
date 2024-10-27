import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class EmailIcon extends StatelessWidget {
  final String email = 'mailto:zeph.qamar4@gmail.com';

  const EmailIcon({super.key}); // Replace with your email

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const FaIcon(FontAwesomeIcons.envelope), // Email icon
      onPressed: () async {
        if (await canLaunchUrlString(email)) {
          await launchUrlString(email);
        } else {
          throw 'Could not launch $email';
        }
      },
      tooltip: 'Email',
    );
  }
}
