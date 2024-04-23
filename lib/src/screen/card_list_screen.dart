// lib/src/screens/card_list_screen.dart
import 'package:flutter/material.dart';
import '../models/card_item.dart';
import '../widgets/add_card_dialog.dart';
import 'package:sampleapp/service/api_service.dart';

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
    DateTime? selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddCardDialog(
          onAddCard: (selectedDate) => _addCard(selectedDate),
        );
      },
    );
  }

  void _addCard(DateTime? selectedDate) {
    setState(() {
      String title = _titleController.text;
      String description = _descriptionController.text;
      double amount = double.tryParse(_amountController.text) ?? 0.0;
      DateTime dateTime =
          selectedDate ?? DateTime.now(); // Use selectedDate directly

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
//   void _addCard(DateTime? selectedDate) {
//     setState(() {
//       String title = _titleController.text;
//       String description = _descriptionController.text;
//       double amount = double.tryParse(_amountController.text) ?? 0.0;
//       DateTime dateTime = DateTime.now();

//       if (title.isNotEmpty &&
//           description.isNotEmpty &&
//           amount > 0 &&
//           selectedDate != null) {
//         final newCardItem = CardItem(title, description, amount, dateTime);
//         _cardItems.add(newCardItem);
//         addCardItemToServer(newCardItem);
//       }

//       _titleController.clear();
//       _descriptionController.clear();
//       _amountController.clear();
//       _timeController.clear();
//     });
//   }
// }
