import 'package:flutter/material.dart';
import '../widgets/chartBar.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTrans;
  const Chart(this.recentTrans);
  List<Map<String, Object>> get displayTrans {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      var totalAmount = 0.00;
      for (var i = 0; i < recentTrans.length; i++) {
        if (recentTrans[i].date.day == weekday.day &&
            recentTrans[i].date.month == weekday.month &&
            recentTrans[i].date.year == weekday.year) {
          totalAmount += recentTrans[i].amount;
        }
      }
      
      return {
        'day': DateFormat.E().format(weekday).substring(0, 1),
        'amount': totalAmount
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return displayTrans.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
     print('build() chart()');
  
    return Card(
        elevation: 6,
        margin: const EdgeInsets.all(20),
        child: Container(
          padding:const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: displayTrans.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                    data['day'],
                    data['amount'],
                    totalSpending == 0
                        ? 0.0
                        : (data['amount'] as double) / totalSpending),
              );
            }).toList(),
          ),
        ));
  }

}
