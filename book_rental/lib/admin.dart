// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class AdminScreen extends StatefulWidget {
//   static const routeName = '/admin';

//   @override
//   _AdminScreenState createState() => _AdminScreenState();
// }

// class _AdminScreenState extends State<AdminScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _authorController = TextEditingController();
//   final _priceController = TextEditingController();
//   final _descriptionController = TextEditingController();

//   String _errorMessage = '';

//   void _addBook() async {
//     final title = _titleController.text.trim();
//     final author = _authorController.text.trim();
//     final price = double.parse(_priceController.text.trim());
//     final description = _descriptionController.text.trim();

//     try {
//       final response = await http.post(
//         Uri.parse('http://127.0.0.1:8000/api/books/'),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(<String, dynamic>{
//           'title': title,
//           'author': author,
//           'price': price,
//           'description': description,
//         }),
//       );

//       if (response.statusCode == 201) {
//         // Book added successfully
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Book added successfully'),
//           ),
//         );
//         _resetForm();
//       } else {
//         setState(() {
//           _errorMessage = 'Failed to add book';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Failed to add book';
//       });
//     }
//   }

//   void _resetForm() {
//     _formKey.currentState!.reset();
//     _errorMessage = '';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin'),
//         backgroundColor: Colors.green,
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   if (_errorMessage.isNotEmpty)
//                     Text(
//                       _errorMessage,
//                       style: TextStyle(
//                         color: Colors.red,
//                       ),
//                     ),
//                   TextFormField(
//                     controller: _titleController,
//                     decoration: InputDecoration(
//                       labelText: 'Title',
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter the title';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 16.0),
//                   TextFormField(
//                     controller: _authorController,
//                     decoration: InputDecoration(
//                       labelText: 'Author',
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter the author';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 16.0),
//                   TextFormField(
//                     controller: _priceController,
//                     decoration: InputDecoration(
//                       labelText: 'Price',
//                     ),
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter the price';
//                       }
//                       if (double.tryParse(value) == null) {
//                         return 'Please enter a valid price';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 16.0),
//                   TextFormField(
//                     controller: _descriptionController,
//                     decoration: InputDecoration(
//                       labelText: 'Description',
//                     ),
//                     maxLines: 3,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter the description';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 32.0),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         _addBook();
//                       }
//                     },
//                     child: Text('Add Book'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
