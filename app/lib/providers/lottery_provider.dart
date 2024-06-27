import 'package:app/models/lottery.dart';
import 'package:flutter/material.dart';

class LotteryProvider extends ChangeNotifier {
  final List<Lottery> lotteries = [];

  String messageOfAllLoteries() {
    String message = '';

    for (var lottery in lotteries) {
      message += 'Nombre: ${lottery.name}\n';
      message += 'Número: ${lottery.number}\n';
      message += 'Serie: ${lottery.series}\n';
      message += '----------------------\n';
    }

    return message;
  }

  void addLottery(Lottery lottery) {
    lotteries.add(lottery);
  }

  void reset() {
    lotteries.clear();
  }
}
