import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gloukoma/screens/home_screen.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({Key? key}) : super(key: key);

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  late Future<List<Course>> futureCourses;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureCourses = apiService.fetchAddCourses();
  }

  Future<void> _refreshCourses() async {
    setState(() {
      futureCourses = apiService.fetchAddCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = (user?.email == null) ? 'Кіру' : '${user?.email}';

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Курстар"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshCourses,
          ),
        ],
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
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          try {
                            await apiService.deleteCourseToUser(email, course.id);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Курс өшірілді')));
                            _refreshCourses();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Қате: $e')));
                          }
                        },
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LessonScreen(
                              courseId: course.id,
                              lessonIds: course.lessons,
                              quizId: course.quizzes.isNotEmpty ? course.quizzes[0] : 0,
                            )));
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),

    );
  }
}
