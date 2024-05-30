import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Connect extends StatelessWidget {
  Connect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Связь с Офтальматологом',
        ),
      ),
      body: Center(
        child:

          Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Doctor Dias',
                          ),
                          Text(
                            'address dotors',
                          ),
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
                                  path: 'Dificonfig@gmail.com',
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
                                path: '+77765228256',
                              ));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),


      ),
    );
  }
}