import 'package:url_launcher/url_launcher.dart';

extension LaunchLinkedinUrlExtension on void {
  Future<void> launchLinkedinUrl() async {
    String uri = 'https://www.linkedin.com/in/idir-belmokhtar-888399232';
    if (await canLaunchUrl(Uri.parse(uri))) {
      await launchUrl(Uri.parse(uri));
    } else {
      print("No url client found");
    }
  }
}
