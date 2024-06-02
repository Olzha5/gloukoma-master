import 'package:flutter/material.dart';

class QuizResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const QuizResultScreen({
    Key? key,
    required this.score,
    required this.totalQuestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://shkola43saratov-r64.gosweb.gosuslugi.ru/netcat_files/207/3211/bXbt_om8zFg.jpg',
                      height: 200,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Жинаған ұпайыңыз!',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ResultCard(
                          title: 'Ұпайлар',
                          value: '$score',
                          color: Colors.yellow,
                          icon: Icons.flash_on,
                        ),
                        SizedBox(width: 10),
                        ResultCard(
                          title: 'Дұрыс',
                          value: '${(score / totalQuestions * 100).toStringAsFixed(1)}%',
                          color: Colors.green,
                          icon: Icons.check_circle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.blue, // background
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Жалғастыру',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const ResultCard({
    Key? key,
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
