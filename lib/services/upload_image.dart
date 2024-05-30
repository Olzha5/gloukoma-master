import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> uploadImage(File imageFile) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('https://7773-176-64-3-114.jp.ngrok.io/api/image/'),
  );

  // Создаем MultipartFile из файла изображения
  var multipartFile = await http.MultipartFile.fromPath('image', imageFile.path);

  // Добавляем файл в запрос
  request.files.add(multipartFile);
  // Отправляем запрос на сервер
  var response = await request.send();
  if (response.statusCode == 201) {
    var jsonResponse = json.decode(await response.stream.bytesToString());
    // Access the values in the JSON response using standard Dart syntax
    print(jsonResponse['filename']);
    print('Image uploaded successfully');
  } else {
    print('Failed to upload image');
  }
}