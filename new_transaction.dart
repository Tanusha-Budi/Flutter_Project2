import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  final Function addNewTransaction;

  NewTransaction(this.addNewTransaction);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void submitData() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount < 0) {
      return;
    }

    widget.addNewTransaction(enteredTitle, enteredAmount, _selectedDate);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 7,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                    labelText: 'Title', labelStyle: TextStyle(fontSize: 20)),
                controller: titleController,
                keyboardType: TextInputType.text,
                onSubmitted: (_) => submitData(),
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Amount', labelStyle: TextStyle(fontSize: 20)),
                controller: amountController,
                keyboardType: TextInputType.numberWithOptions(),
                onSubmitted: (_) => submitData(),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                        'Picked Date: ${_selectedDate.year}/${_selectedDate.month}/${_selectedDate.day}',
                        style: TextStyle(fontSize: 18)),
                  ),
                  TextButton(
                    onPressed: () async {
                      DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));

                      if (newDate == null) return;

                      setState(() {
                        _selectedDate = newDate;
                      });
                    },
                    child: Text('Choose Date', style: TextStyle(fontSize: 18)),
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor)),
                  )
                ],
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).primaryColor),
                ),
                onPressed: submitData,
                child: Text(
                  'Add Transaction',
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          ),
        ));
  }
}
