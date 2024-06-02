import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gloukoma/screens/quiz_result_screen.dart';
import 'package:gloukoma/services/upload_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';




class Course {
  final int id;
  final String title;
  final String imageUrl;
  final String information;
  final int authorId;
  final List<int> lessons;
  final List<int> quizzes;

  Course({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.information,
    required this.authorId,
    required this.lessons,
    required this.quizzes,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? 0,
      title: json['name'] ?? '',
      imageUrl: json['image'] ?? 'https://buffer.com/library/content/images/2023/10/free-images.jpg',
      information: json['information'] ?? '',
      authorId: json['author'] ?? 0,
      lessons: List<int>.from(json['lessons'] ?? []),
      quizzes: List<int>.from(json['quizzes'] ?? []),
    );
  }
}

class Lesson {
  final int id;
  final String? video;
  final String documents;
  final String text;

  Lesson({required this.id, this.video, required this.documents, required this.text});

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] ?? 0,
      video: json['video'],
      documents: json['documents'] ?? '',
      text: json['text'] ?? '',
    );
  }
}

class Quiz {
  final int id;
  final String title;
  final List<int> questionIds;

  Quiz({
    required this.id,
    required this.title,
    required this.questionIds,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      questionIds: List<int>.from(json['questions'] ?? []),
    );
  }
}

class Question {
  final int id;
  final String questionText;
  final Map<String, String> options;

  final String rightOption;


  Question({
    required this.id,
    required this.questionText,
    required this.options,
    required this.rightOption,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? 0,
      questionText: json['text'] ?? '',
      options: Map<String, String>.from(json['options'] ?? {}),

      rightOption: json['right_option']?.toString() ?? '', // Ensure right_option is treated as a string

    );
  }
}



class ApiService {
  static const String coursesUrl = 'http://olzhasna.beget.tech/courses/';
  static const String lessonsUrl = 'http://olzhasna.beget.tech/lessons/';
  static const String quizzesUrl = 'http://olzhasna.beget.tech/quizzes/';
  static const String questionsUrl = 'http://olzhasna.beget.tech/questions/';
  static const String usersUrl = 'http://olzhasna.beget.tech/users/';

  Future<List<Course>> fetchCourses() async {
    final response = await http.get(Uri.parse(coursesUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Course.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }

  Future<List<Lesson>> fetchLessons(List<int> lessonIds) async {
    final response = await http.get(Uri.parse(lessonsUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Lesson> allLessons = body.map((dynamic item) => Lesson.fromJson(item)).toList();
      return allLessons.where((lesson) => lessonIds.contains(lesson.id)).toList();
    } else {
      throw Exception('Failed to load lessons');
    }
  }

  Future<Quiz> fetchQuiz(int quizId) async {
    final response = await http.get(Uri.parse('$quizzesUrl$quizId/'));

    if (response.statusCode == 200) {
      return Quiz.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load quiz');
    }
  }

  Future<List<Question>> fetchQuestions(List<int> questionIds) async {
    final response = await http.get(Uri.parse(questionsUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Question> allQuestions = body.map((dynamic item) => Question.fromJson(item)).toList();
      return allQuestions.where((question) => questionIds.contains(question.id)).toList();
    } else {
      throw Exception('Failed to load questions${response.body}');
    }
  }

  Future<String> fetchAuthorName(int authorId) async {
    final response = await http.get(Uri.parse('$usersUrl$authorId/'));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return body['username'] ?? 'Unknown';
    } else {
      throw Exception('Failed to load author');
    }
  }

  Future<void> addCourseToUser(String email, int courseId) async {
    final response = await http.get(Uri.parse('http://olzhasna.beget.tech/api/course/${email}/${courseId}'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> user = jsonDecode(response.body);
      final userId = user['id'];
      final List<int> courses = List<int>.from(user['courses'] ?? []);
      courses.add(courseId);


    } else {

      throw Exception('Failed to fetch user');
    }
  }
}





class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Course>> futureCourses;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureCourses = apiService.fetchCourses();
  }

  Future<void> _refreshCourses() async {
    setState(() {
      futureCourses = apiService.fetchCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = (user?.email == null) ? 'Кіру' : '${user?.email}';
    const double letter = 50;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Басты бет"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshCourses,
          ),
        ],
      ),
      drawer: Drawer(
        width: 300,
        backgroundColor: Colors.white,
        child: Column(
          children: [
            SizedBox(
              width: 300,
              height: 220,
              child: DrawerHeader(
                decoration: const BoxDecoration(color: Colors.blue),
                child: Center(
                  child: ListTile(
                    title: Center(
                        child: Text(
                          email,
                          style: const TextStyle(color: Colors.white),
                        )),
                    onTap: () {
                      (email == "Кіру")
                          ? Navigator.of(context).pushNamed('/login')
                          : Navigator.of(context).pushNamed('/account');
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Column(
                children: [
                  SizedBox(
                    width: 300,
                    height: letter,
                    child: ListTile(
                      title: const Text('Глаукома туралы'),
                      onTap: () {
                        Navigator.of(context).pushNamed('/about_glaucoma');
                      },
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    height: letter,
                    child: ListTile(
                      title: const Text('Менің деректерім'),
                      onTap: () async {
                        Navigator.of(context).pushNamed('/my_data');
                      },
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    height: letter,
                    child: ListTile(
                      title: const Text('Менің режимім'),
                      onTap: () async {
                        final picker = ImagePicker();
                        final pickedFile =
                        await picker.getImage(source: ImageSource.gallery);

                        if (pickedFile != null) {
                          File imageFile = File(pickedFile.path);
                          await uploadImage(imageFile);
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    height: letter,
                    child: ListTile(
                      title: const Text('Офтальмологпен байланыс'),
                      onTap: () {
                        Navigator.of(context).pushNamed('/connect');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: FutureBuilder<List<Course>>(
          future: futureCourses,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Қате: ${snapshot.error}');
            } else {
              final courses = snapshot.data!;
              return ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return Card(
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(course.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                      ),
                      title: Text(course.title, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: FutureBuilder<String>(
                        future: apiService.fetchAuthorName(course.authorId),
                        builder: (context, authorSnapshot) {
                          if (authorSnapshot.connectionState == ConnectionState.waiting) {
                            return Text(course.information);
                          } else if (authorSnapshot.hasError) {
                            return Text(course.information);
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(course.information),
                                Text('Автор: ${authorSnapshot.data}', style: TextStyle(fontStyle: FontStyle.italic)),
                              ],
                            );
                          }
                        },
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () async {
                          try {
                            await apiService.addCourseToUser(email, course.id);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Курс қосылды')));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Қате: $e')));
                          }
                        },
                      ),
                      // onTap: () {
                      //   Navigator.of(context).push(MaterialPageRoute(
                      //       builder: (context) => LessonScreen(
                      //         courseId: course.id,
                      //         lessonIds: course.lessons,
                      //         quizId: course.quizzes.isNotEmpty ? course.quizzes[0] : 0,
                      //       )));
                      // },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Камера',
        child: const Icon(Icons.camera_alt_sharp),
      ),
    );
  }
}




class LessonScreen extends StatefulWidget {
  final int courseId;
  final List<int> lessonIds;
  final int quizId;

  const LessonScreen({Key? key, required this.courseId, required this.lessonIds, required this.quizId}) : super(key: key);

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late Future<List<Lesson>> futureLessons;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureLessons = apiService.fetchLessons(widget.lessonIds);
  }

  Future<void> _refreshLessons() async {
    setState(() {
      futureLessons = apiService.fetchLessons(widget.lessonIds);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Сабақтар'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshLessons,
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<Lesson>>(
          future: futureLessons,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Қате: ${snapshot.error}');
            } else {
              final lessons = snapshot.data!;
              return ListView.builder(
                itemCount: lessons.length,
                itemBuilder: (context, index) {
                  final lesson = lessons[index];
                  return Card(
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Сабақ ${index + 1}',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          if (lesson.video != null) ...[
                            YoutubePlayerWidget(videoUrl: lesson.video!),
                          ],
                          SizedBox(height: 10),
                          Text(
                            lesson.text,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final url = lesson.documents;
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            icon: Icon(Icons.download),
                            label: Text('Құжатты жүктеу'),
                            style: ElevatedButton.styleFrom(

                              foregroundColor: Colors.white, backgroundColor: Colors.blue,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => QuizScreen(quizId: widget.quizId),
          ));
        },
        label: Text('Тест тапсыру'),
        icon: Icon(Icons.quiz),
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final int quizId;

  const QuizScreen({Key? key, required this.quizId}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<Quiz> futureQuiz;
  late Future<List<Question>> futureQuestions;
  final ApiService apiService = ApiService();
  Map<int, String> selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    futureQuiz = apiService.fetchQuiz(widget.quizId);
  }


  void _submitQuiz(List<Question> questions) {
    int score = 0;
    for (var question in questions) {
      if (selectedAnswers[question.id] == question.rightOption) {
        score += 1;
      }
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(score: score, totalQuestions: questions.length),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Тест тапсыру'),
      ),
      body: FutureBuilder<Quiz>(
        future: futureQuiz,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Қате: ${snapshot.error}'));
          } else {
            final quiz = snapshot.data!;
            futureQuestions = apiService.fetchQuestions(quiz.questionIds);
            return FutureBuilder<List<Question>>(
              future: futureQuestions,
              builder: (context, questionSnapshot) {
                if (questionSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (questionSnapshot.hasError) {
                  return Center(child: Text('Қате: ${questionSnapshot.error}'));
                } else {
                  final questions = questionSnapshot.data!;

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: questions.length,
                          itemBuilder: (context, index) {
                            final question = questions[index];
                            return Card(
                              margin: EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Сұрақ ${index + 1}',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      question.questionText,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: 10),
                                    ...question.options.entries.map((entry) => ListTile(
                                      title: Text(entry.value),
                                      leading: Radio<String>(
                                        value: entry.key,
                                        groupValue: selectedAnswers[question.id],
                                        onChanged: (value) {
                                          setState(() {
                                            selectedAnswers[question.id] = value!;
                                          });
                                        },
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () => _submitQuiz(questions),
                          child: Text('Тестті аяқтау'),
                        ),
                      ),
                    ],

                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}




class YoutubePlayerWidget extends StatefulWidget {
  final String videoUrl;

  const YoutubePlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _YoutubePlayerWidgetState createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.blueAccent,
    );
  }
}
