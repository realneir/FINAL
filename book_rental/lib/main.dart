import 'package:book_rental/auth_provider.dart';
import 'package:book_rental/bookList.dart';
import 'package:book_rental/login_page.dart';
import 'package:book_rental/rentedBooks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'signup_page.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => AuthProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Signup Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/signup': (context) => SignupPage(),
        '/login': (context) => LoginScreen(),
        '/Home': (context) => HomeScreen(),
        '/Rents': (context) => UserRentedBooksScreen(
              userId: 5,
            ),
      },
    );
  }
}
