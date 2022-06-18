import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingAmountpercent;

  ChartBar(this.label, this.spendingAmount, this.spendingAmountpercent);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 22,
            child: FittedBox(
                child: Text('\u20B9${spendingAmount.toStringAsFixed(0)}'))),
        SizedBox(
          height: 4,
        ),
        Container(
          height: 60,
          width: 10,
          child: Stack(children: [
            Container(
                decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.0),
              color: Color.fromRGBO(220, 220, 220, 1),
              borderRadius: BorderRadius.circular(10),
            )),
            FractionallySizedBox(
              heightFactor: spendingAmountpercent,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.brown,
                      borderRadius: BorderRadius.circular(10))),
            )
          ]),
        ),
        SizedBox(
          height: 4,
        ),
        Text(label),
      ],
    );
  }
}