import 'package:flutter/material.dart';

class AddCardDialog extends StatelessWidget {
  final Function(DateTime?) onAddCard;

  const AddCardDialog({required this.onAddCard});

  @override
  Widget build(BuildContext context) {
    DateTime? selectedDate = DateTime.now(); // Update: Making DateTime nullable
    TextEditingController _titleController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();
    TextEditingController _amountController = TextEditingController();

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
                selectedDate = picked;
              }
            },
          ),
        ],
      ),
      actions: [
        FloatingActionButton(
          onPressed: () {
            onAddCard(selectedDate);
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
  }
}
