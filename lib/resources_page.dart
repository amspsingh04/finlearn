import 'package:flutter/material.dart';

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

class PortfolioManagerPage extends StatelessWidget {
  const PortfolioManagerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy portfolio data
    final portfolioData = [
      {'name': 'Apple', 'quantity': 50, 'price': 145.30},
      {'name': 'Tesla', 'quantity': 30, 'price': 279.50},
      {'name': 'Bitcoin', 'quantity': 1, 'price': 46000},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Portfolio Manager')),
      body: ListView.builder(
        itemCount: portfolioData.length,
        itemBuilder: (context, index) {
          final item = portfolioData[index];
          return ListTile(
            title: Text('${item['name']}'),
            subtitle: Text(
                'Quantity: ${item['quantity']} - Price: \$${item['price']}'),
            trailing: Text(
                'Total: \$${(item['quantity'] as double) * (item['price'] as double)}'),  // Cast both values to double
          );
        },
      ),
    );
  }
}

class BudgetCalculatorPage extends StatelessWidget {
  const BudgetCalculatorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy budget data
    final budgetData = [
      {'category': 'Rent', 'amount': 1200.0},
      {'category': 'Groceries', 'amount': 300.0},
      {'category': 'Entertainment', 'amount': 150.0},
      {'category': 'Savings', 'amount': 500.0},
    ];

    double totalBudget = budgetData.fold(0.0, (sum, item) => sum + (item['amount'] as double));

    return Scaffold(
      appBar: AppBar(title: const Text('Budget Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: budgetData.length,
                itemBuilder: (context, index) {
                  final item = budgetData[index];
                  return ListTile(
                    title: Text(item['category'] as String),  // Type cast to String
                    trailing: Text('\$${item['amount'] as double}'),  // Type cast to double
                  );
                },
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
          ],
        ),
      ),
    );
  }
}
