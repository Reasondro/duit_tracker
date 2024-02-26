import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expanses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import "package:expense_tracker/models/expense.dart";
import 'package:google_fonts/google_fonts.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _Expenses();
  }
}

class _Expenses extends State<Expenses> {
  final List<Expense> _registedExpenses = [
    //? dummy data
    Expense(
        title: "ESP-32",
        amount: 57000,
        date: DateTime(2024, 02, 16), // Set the date to October 31, 2022
        category: Category.work),
    Expense(
        title: "Shit-bag",
        amount: 100000,
        date: DateTime(2024, 02, 14), // Set the date to October 31, 2022
        category: Category.food),
  ];

  void _addExpense(
      Expense expense) //parameter must be same as NewExpsense's parameter
  {
    setState(() {
      //? file fondasi/controller butuh fungsi add list-ny diksih ke file pembuat expense, supaya bisa make objek dari file pembuat expense
      _registedExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registedExpenses.indexOf(expense);
    setState(() {
      _registedExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text("Expense deleted."),
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              setState(() {
                _registedExpenses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea:
          true, //? makes sure we stay away from devices features like camera that might affect our ui
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    ); //? builder keyword always need a function as a value
  }

  // var activeScreen = "start-screen";

  // some function to call activeScreen

  @override
  Widget build(BuildContext context) {
    // som if statements to call active screen
    final width = MediaQuery.of(context).size.width;
    // final length = MediaQuery.of(context).size.height;

    Widget mainContent = Center(
      child: Text("No expenses found. Start adding some!",
          style: GoogleFonts.josefinSans()),
    );
    if (_registedExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registedExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "DUIT TRACKER",
          style: GoogleFonts.josefinSans(),
        ),
        actions: [
          IconButton(
            // onPressed: () {
            //   _openAddExpenseOverlay();
            // },
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add_box_outlined),
          )
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                // Toolbar with the add button => row()
                Chart(expenses: _registedExpenses),
                Expanded(
                  //? need to use expanded when using column list inside of column stuff
                  child: mainContent,
                )
              ],
            )
          : Row(
              children: [
                Expanded(
                  //* GOOD practice to use expanded when dealing with multiple rows/columsn besides each other
                  //* OR in a nested row and columns
                  //? Expanded constraints the child (here the chart) to only take
                  //? as much width as avaible in the Row(parent) after sizing the other Row children
                  child: Chart(expenses: _registedExpenses),
                ),
                Expanded(
                  //? need to use expanded when using column list inside of column stuff
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
