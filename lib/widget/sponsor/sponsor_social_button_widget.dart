import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SponsorSocialButton extends StatefulWidget {
  FaIcon icon;
  VoidCallback launchUrl;

  SponsorSocialButton({@required this.icon, @required this.launchUrl});
  @override
  _SponsorSocialButtonState createState() => _SponsorSocialButtonState();
}

class _SponsorSocialButtonState extends State<SponsorSocialButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(icon: widget.icon, onPressed: () => widget.launchUrl),
    );
  }
}
