import 'package:expense_tracker/widgets/expanses_list/expense_item.dart';
import 'package:flutter/material.dart';
import "package:expense_tracker/models/expense.dart";

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.onRemoveExpense});

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        background: 
        Container( //? box that appears when swiping
          color: Theme.of(context).colorScheme.error.withOpacity(0.75),
          margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context)
                  .cardTheme
                  .margin!
                  .horizontal), //? recommended same with card margin
        ),
        key: ValueKey(expenses[index]),
        onDismissed: (direction) {
          onRemoveExpense(expenses[index]);
        },
        child: ExpenseItem(expense: expenses[index]),
      ),
    );
    //? ListView allows scrollable list/column by default, .builder add it so it only need to render what fit on the screen
    //? column which default renders all the widget we have, even if it's not visible (use only when known amount of list)
  }
}
