import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GitHubIcon extends StatelessWidget {
  final String gitHubUrl =
      'https://github.com/ZephaniahQ'; // Replace with your GitHub URL

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const FaIcon(FontAwesomeIcons.github), // GitHub logo
      onPressed: () async {
        if (await canLaunchUrlString(gitHubUrl)) {
          await launchUrlString(gitHubUrl);
        } else {
          throw 'Could not launch $gitHubUrl';
        }
      },
      tooltip: 'GitHub',
    );
  }
}
