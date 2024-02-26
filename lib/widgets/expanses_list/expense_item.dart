import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({required this.expense, super.key});
  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Colors.white,
      // margin: EdgeInsetsDirectional.only(bottom: 90), //? add gap between cards
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expense.title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 21),
              // textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Rp${expense.amount.toStringAsFixed(2)}",
                    style: GoogleFonts.josefinSans()),
                const Spacer(),
                Row(children: [
                  Icon(
                    categoryIcons[expense.category],
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(expense.formattedDate, style: GoogleFonts.josefinSans()),
                ])
              ],
            )
          ],
        ),
      ),
    );
  }
}
