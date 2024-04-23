import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
// import 'package:flutter_config/flutter_config.dart';

void main() {
  // await FlutterConfig.loadEnvVariables();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true, // false
      title: 'Card List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: CardListScreen(),
    );
  }
}

class CardListScreen extends StatefulWidget {
  @override
  _CardListScreenState createState() => _CardListScreenState();
}

class _CardListScreenState extends State<CardListScreen> {
  final List<CardItem> _cardItems = [];

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card List'),
      ),
      body: ListView.builder(
        itemCount: _cardItems.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(_cardItems[index].title),
              subtitle: Text(_cardItems[index].description),
              trailing: Text('\$ ${_cardItems[index].amount.toString()}'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCardDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddCardDialog(BuildContext context) {
    DateTime? selectedDate = DateTime.now(); // Update: Making DateTime nullable

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Card'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
              ),
              ListTile(
                title: Text(
                  'Date: ${selectedDate?.year}-${selectedDate?.month}-${selectedDate?.day}',
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            FloatingActionButton(
              onPressed: () {
                if (selectedDate != null) {
                  // Check for nullability
                  _addCard(selectedDate);
                }
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _addCard(DateTime? selectedDate) {
    // Update: Making DateTime nullable
    setState(() {
      String title = _titleController.text;
      String description = _descriptionController.text;
      double amount = double.tryParse(_amountController.text) ?? 0.0;
      DateTime dateTime = DateTime.now();

      if (title.isNotEmpty &&
          description.isNotEmpty &&
          amount > 0 &&
          selectedDate != null) {
        final newCardItem = CardItem(title, description, amount, dateTime);
        _cardItems.add(newCardItem);
        addCardItemToServer(newCardItem);
      }

      _titleController.clear();
      _descriptionController.clear();
      _amountController.clear();
      _timeController.clear();
    });
  }
}

class CardItem {
  final String title;
  final String description;
  final double amount;
  final DateTime dateTime;

  CardItem(this.title, this.description, this.amount, this.dateTime);
}

// final Logger _logger = Logger();
var logger = Logger('app');

Future<void> addCardItemToServer(CardItem cardItem) async {
  final String apiUrl = 'http://localhost:8000/api/news/notes/';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': cardItem.title,
        'description': cardItem.description,
        'amount': cardItem.amount,
        'dateTime': cardItem.dateTime.toString(),
      }),
    );

    if (response.statusCode == 200) {
      // Request was successful (status code 200)
      print('CardItem added successfully!');
    } else {
      // Request failed with an error status code
      print('Failed to add CardItem. Status code: ${response.statusCode}');
    }
  } catch (error) {
    // Catch any errors during the API request
    // print('Error adding CardItem: $error');
    print(error); //('Error adding CardItem: $error');
    logger.warning(error); //('Error adding CardItem: $error');
  }
}
