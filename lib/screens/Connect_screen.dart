import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Connect extends StatelessWidget {
  Connect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(

          'Орталықпен байланыс',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            contactRow('Admin Nurgali', 'address admin', 'nurgalishansharov@gmail.com', '+77474862501'),
            Divider(),
            contactRow('Admin Olzhas', 'address admin2', 'olzhasabukhan@gmial.com', '+77763625015'),
          ],
        ),
      ),
    );
  }

  Widget contactRow(String name, String address, String email, String phone) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(name),
            Text(address),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              icon: Icon(
                Icons.email,
                size: 30,
              ),
              onPressed: () async {
                await launchUrl(Uri(
                    scheme: 'mailto',
                    path: email,
                    query: {
                      'subject': 'hello',
                    }
                        .entries
                        .map((MapEntry<String, String> e) =>
                    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                        .join('&')));
              },
            ),
            IconButton(
              icon: Icon(
                Icons.call_rounded,
                size: 30,
              ),
              onPressed: () async {
                await launchUrl(Uri(
                  scheme: 'tel',
                  path: phone,
                ));
              },
            ),
          ],
        ),
      ],
    );
  }
}

