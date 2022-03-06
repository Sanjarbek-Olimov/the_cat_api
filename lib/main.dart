import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_cat_api/pages/home_page.dart';
import 'package:the_cat_api/pages/search_page.dart';
import 'package:the_cat_api/pages/upload_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Cat Api',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: const HomePage(),
      routes: {
        HomePage.id: (context) => const HomePage(),
        SearchPage.id: (context) => const SearchPage(),
        UploadPage.id: (context) => UploadPage()
      },
    );
  }
}
