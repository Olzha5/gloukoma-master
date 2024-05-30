import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gloukoma/firebase.dart';

class Mydata extends StatelessWidget {
  Mydata({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Мои данные',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // FutureBuilder(
            //
            //   future:user,
            //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            //     return SingleChildScrollView(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Text(
            //           snapshot.data,
            //           style: const TextStyle(
            //             fontWeight: FontWeight.bold,
            //             fontSize: 19.0,
            //           ),
            //         ));
            //   },
            //
            // ),
          ],
        ),
      ),
    );
  }
}