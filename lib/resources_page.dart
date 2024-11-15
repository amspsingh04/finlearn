import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(MaterialApp(
    home: ResourcesPage(),
  ));
}

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resources'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Card for Portfolio Manager
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PortfolioManagerPage()),
                );
              },
              child: Card(
                color: Colors.blueAccent,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  height: 200,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white,
                        size: 40,
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Portfolio Manager',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50), // Spacer between cards

            // Card for Budget Calculator
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BudgetCalculatorPage()),
                );
              },
              child: Card(
                color: Colors.greenAccent,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  height: 200,
                  width: double.infinity,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.calculate,
                        color: Colors.white,
                        size: 40,
                      ),
                      const SizedBox(width: 30),
                      Text(
                        'Budget Calculator',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class StockData {
  final DateTime date;
  final double price;

  StockData(this.date, this.price);
}

class PortfolioManagerPage extends StatelessWidget {
  const PortfolioManagerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy portfolio data
    final portfolioData = [
      {'name': 'Apple', 'quantity': 50, 'price': 145.30},
      {'name': 'Tesla', 'quantity': 30, 'price': 279.50},
      {'name': 'Bitcoin', 'quantity': 1, 'price': 46000.00},
    ];

    // Dummy time series data for each stock
    final Map<String, List<StockData>> stockTimeSeries = {
      'Apple': [
        StockData(DateTime(2024, 1, 1), 145.30),
        StockData(DateTime(2024, 1, 2), 140.50),
        StockData(DateTime(2024, 1, 3), 138.00),
        StockData(DateTime(2024, 1, 4), 129.20),
        StockData(DateTime(2024, 1, 5), 150.50),
      ],
      'Tesla': [
        StockData(DateTime(2024, 1, 1), 279.50),
        StockData(DateTime(2024, 1, 2), 299.30),
        StockData(DateTime(2024, 1, 3), 385.00),
        StockData(DateTime(2024, 1, 4), 390.00),
        StockData(DateTime(2024, 1, 5), 425.50),
      ],
      'Bitcoin': [
        StockData(DateTime(2024, 1, 1), 46000),
        StockData(DateTime(2024, 1, 2), 43500),
        StockData(DateTime(2024, 1, 3), 49000),
        StockData(DateTime(2024, 1, 4), 57500),
        StockData(DateTime(2024, 1, 5), 58000),
      ],
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Portfolio Manager')),
      body: ListView.builder(
        itemCount: portfolioData.length,
        itemBuilder: (context, index) {
          final item = portfolioData[index];
          final stockName = item['name'];
          final stockPrice = item['price'];
          final stockTimeSeriesData = stockTimeSeries[stockName];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(stockName as String), // Casting to String
                  subtitle: Text('Price: \$${stockPrice}'),
                  trailing: Text(
                      'Total: \$${(item['quantity'] as num).toDouble() * (item['price'] as double)}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SfCartesianChart(
                    primaryXAxis: DateTimeCategoryAxis(),
                    primaryYAxis: NumericAxis(),
                    series: <CartesianSeries<StockData, DateTime>>[
                      LineSeries<StockData, DateTime>(
                        dataSource: stockTimeSeriesData!,
                        xValueMapper: (StockData data, _) => data.date,
                        yValueMapper: (StockData data, _) => data.price,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
class BudgetCalculatorPage extends StatefulWidget {
  const BudgetCalculatorPage({Key? key}) : super(key: key);

  @override
  _BudgetCalculatorPageState createState() => _BudgetCalculatorPageState();
}

class _BudgetCalculatorPageState extends State<BudgetCalculatorPage> {
  // Dummy budget data
  final Map<String, double> budgetData = {
    'Rent': 1200.0,
    'Groceries': 300.0,
    'Entertainment': 150.0,
    'Savings': 500.0,
  };

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double totalBudget = budgetData.values.fold(0.0, (sum, item) => sum + item);

    // Prepare data for the pie chart
    List<PieChartData> pieData = budgetData.entries.map((entry) {
      return PieChartData(
        category: entry.key,
        amount: entry.value,
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Budget Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form to edit the budget
            Form(
              key: _formKey,
              child: Expanded(
                child: ListView(
                  children: budgetData.keys.map((category) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(category),
                          SizedBox(
                            width: 100,
                            child: TextFormField(
                              initialValue: budgetData[category]!.toString(),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Amount',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  // Update the budget value when it changes
                                  if (value.isNotEmpty) {
                                    budgetData[category] =
                                        double.tryParse(value) ?? 0.0;
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Total Budget: \$${totalBudget.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // Pie chart showing the budget breakdown
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: SfCircularChart(
                legend: Legend(isVisible: true),
                series: <CircularSeries>[
                  PieSeries<PieChartData, String>(
                    dataSource: pieData,
                    xValueMapper: (PieChartData data, _) => data.category,
                    yValueMapper: (PieChartData data, _) => data.amount,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pie chart data model
class PieChartData {
  final String category;
  final double amount;

  PieChartData({required this.category, required this.amount});
}