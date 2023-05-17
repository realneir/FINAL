import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'auth_provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _books = [];

  @override
  void initState() {
    super.initState();
    _getBooks();
  }

  Future<void> _getBooks() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/books/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _books = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to retrieve books');
    }
  }

  Future<void> _logout(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      await authProvider.logout();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to logout. Please try again.'),
      ));
    }
  }

  Future<void> _rentBook(BuildContext context, dynamic book) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final rentedBooksCount = authProvider.rentedBooksCount;

    if (rentedBooksCount >= 3) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Maximum Limit Reached'),
            content: Text('You have already rented 3 books. Cannot rent more.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final url =
        Uri.parse('http://127.0.0.1:8000/api/books/${book['id']}/rent/');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${authProvider.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book rented successfully'),
        ),
      );
      _getBooks();
      authProvider.incrementRentedBooksCount();
      // Show dialog after successful rental
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Book Rented'),
            content: Text('You have successfully rented the book.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to rent book. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final username = authProvider.username;

    return Scaffold(
      appBar: AppBar(
        title: Text('$username'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: Colors.grey[300],
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _books.length,
          itemBuilder: (context, index) {
            final book = _books[index];
            final isAvailable = book['available'];

            return Container(
              margin: EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: ListTile(
                title: Text(book['title']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(book['author']),
                    Text('Price: ${book['price']}'),
                    Text('Description: ${book['description']}'),
                  ],
                ),
                trailing: isAvailable
                    ? ElevatedButton(
                        onPressed: isAvailable
                            ? () async {
                                await _rentBook(context, book);
                              }
                            : null,
                        child: Text('Rent'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors
                              .green, // Set the desired color for the button
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      )
                    : Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 30,
                      ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/Rents'),
        child: Icon(Icons.bookmark_add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
