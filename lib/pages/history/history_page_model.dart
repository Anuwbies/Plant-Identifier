import 'package:flutter/material.dart';
import 'package:flutter_projects/api/history_plants_api.dart';

class HistoryPageModel extends ChangeNotifier {
  late Future<List<dynamic>> futureHistory;

  HistoryPageModel() {
    fetchHistory();
  }

  void fetchHistory() {
    futureHistory = HistoryPlantsApi.fetchHistory();
    notifyListeners();
  }

  Future<void> refreshHistory() async {
    fetchHistory();
  }

  Future<void> deletePlant(int id) async {
    await HistoryPlantsApi.deleteHistory(id);
    fetchHistory();
  }
}
