import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:sampleapp/src/models/card_item.dart';

final Logger logger = Logger('app');

Future<void> addCardItemToServer(CardItem cardItem) async {
  final String apiUrl = 'https://localhost:8000/api/news/notes/';

  try {
    logger.warning('IM here #########################');
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': cardItem.title,
        'description': cardItem.description,
        'amount': cardItem.amount,
        'dateTime':
            cardItem.dateTime.toUtc().toIso8601String(), // Use UTC format
      }),
    );

    if (response.statusCode == 200) {
      print('CardItem added successfully!');
    } else {
      print('Failed to add CardItem. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print(error);
    logger.warning(error);
  }
}
