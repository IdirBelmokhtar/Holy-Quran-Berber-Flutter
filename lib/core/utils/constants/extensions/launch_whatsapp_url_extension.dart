import 'package:url_launcher/url_launcher.dart';

extension LaunchWhatsappUrlExtension on void {
  Future<void> launchWhatsappUrl() async {
    String uri = 'https://wa.me/213556109446';
    if (await canLaunchUrl(Uri.parse(uri))) {
      await launchUrl(Uri.parse(uri));
    } else {
      print("No url client found");
    }
  }
}
