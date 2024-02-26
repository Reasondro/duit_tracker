import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';

// final formatter = DateFormat.yMMMd(); // or yMMMEd for extra day info

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpense();
  }
}

class _NewExpense extends State<NewExpense> {
  // var _enteredTitle = ""; //? solution#1 variable
  // void _saveTitleInput(String inputValue) //? solution#1  method
  // {
  //   _enteredTitle = inputValue;
  // }

  final _titleController =
      TextEditingController(); //? solution#2 variable cheatcode

  final _amountController = TextEditingController();

  DateTime? _selectedDate;
  Category _selectedCategory = Category.food;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = now;

    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate);
    // .then((value) => null); //? another method without using async await

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _selectCategory(Category? c) {
    if (c == null) {
      return;
    } else {
      setState(() {
        _selectedCategory = c;
      });
    }
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
            title: const Text("Invalid Input"),
            content: const Text(
                "Please make sure a valid title, amount, date, and category was entered."),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: const Text("Okay"))
            ]),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid Input"),
          content: const Text(
              "Please make sure a valid title, amount, date, and category was entered."),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text("Okay"))
          ],
        ),
      );
    }
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      _showDialog();
      return;
    } else {
      final freshExpense = Expense(
          //? adding the requirement parameter that is an Expense object in onAddExpense
          title: _titleController.text,
          amount: enteredAmount,
          date: _selectedDate!,
          category: _selectedCategory);

      widget.onAddExpense(freshExpense);
    }
    Navigator.pop(context);
  }

  @override
  void
      dispose() //? solution#2 dispose method REQUIRED TO DISPOSE var above when not needed
  {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context)
        .viewInsets
        .bottom; //? size of UI elements that are overlapping the app from bottom in this example the keyboard

    return LayoutBuilder(builder: (ctx, constraints) {
      // // TODO LAYOUT BUILDER IN ANOTHER PARENT TO SEE SAME LIMIT
      //TODO turns out it's flutter constarint/update/bug, profs expense does the bug too
      // print("Device Width :${MediaQuery.of(context).size.width}");

      // print("Max Width    : ${constraints.maxWidth}");
      // print("Min Width    : ${constraints.minWidth}");

      // print("Device Height:${MediaQuery.of(context).size.height}");

      // print("Max Height   :${constraints.maxHeight}");
      // print("Min Height   :${constraints.minHeight}");

      final width = constraints.maxWidth;
      return SizedBox(
        height: double.infinity,
        width:
            100000, //todo something is limiting the modal bottom sheet here, cant get proper width
        child: SingleChildScrollView(
          //? use this instead of listView if i know the excat amount of widget inside the column is
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          // onChanged: (AnyVariableName) //? alternative from solution#1 below
                          //     {
                          //   _saveTitleInput(AnyVariableName);
                          // },
                          // onChanged: _saveTitleInput, //? alternative from solution#1 above
                          controller: _titleController,
                          maxLength: 50, //? max character
                          // keyboardType: TextInputType.text, //? good to know formats here
                          decoration: InputDecoration(
                            label:
                                Text("Title", style: GoogleFonts.josefinSans()),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        //? expanded basically give the child the guranntee amount spacing it child needs
                        child: TextField(
                          controller: _amountController,
                          decoration: InputDecoration(
                            // prefix: Text("\$ "),
                            prefixText: "Rp",
                            label: Text("Amount",
                                style: GoogleFonts.josefinSans()),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    // onChanged: (AnyVariableName) //? alternative from solution#1 below
                    //     {
                    //   _saveTitleInput(AnyVariableName);
                    // },
                    // onChanged: _saveTitleInput, //? alternative from solution#1 above
                    controller: _titleController,
                    maxLength: 50, //? max character
                    // keyboardType: TextInputType.text, //? good to know formats here
                    decoration: InputDecoration(
                      label: Text("Title", style: GoogleFonts.josefinSans()),
                    ),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                  style: GoogleFonts.josefinSans(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          _selectCategory(value);
                        },
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        //? here theese two expanded widget (including above) share the row with equal amount , anti-spacer
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? "No date Selected"
                                  : formatter.format(_selectedDate!),
                              style: GoogleFonts.josefinSans(),
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        //? expanded basically give the child the guranntee amount spacing it child needs
                        child: TextField(
                          controller: _amountController,
                          decoration: InputDecoration(
                            // prefix: Text("\$ "),
                            prefixText: "Rp",
                            label: Text("Amount",
                                style: GoogleFonts.josefinSans()),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        //? here theese two expanded widget (including above) share the row with equal amount , anti-spacer
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? "No date Selected"
                                  : formatter.format(_selectedDate!),
                              style: GoogleFonts.josefinSans(),
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                const SizedBox(
                  height: 16,
                ),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.josefinSans(),
                        ),
                      ),
                      // const Spacer(),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: Text(
                          "Save Expense",
                          style: GoogleFonts.josefinSans(),
                        ),
                      )
                    ],
                  )
                else
                  Row(
                    children: [
                      DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                    style: GoogleFonts.josefinSans(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            _selectCategory(value);
                          }),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.josefinSans(),
                        ),
                      ),
                      // const Spacer(),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: Text(
                          "Save Expense",
                          style: GoogleFonts.josefinSans(),
                        ),
                      )
                    ],
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}
