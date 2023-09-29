import 'package:flutter/material.dart';

class CajaPage extends StatefulWidget {
  @override
  _CajaPageState createState() => _CajaPageState();
}

class _CajaPageState extends State<CajaPage> {
  List<Map<String, dynamic>> orders = [
    {'id': 1, 'status': 'PENDING', 'table': 3},
    {'id': 2, 'status': 'SERVED', 'table': 1},
    {'id': 3, 'status': 'PAID', 'table': 2},
    // Add more orders for demonstration
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Caja Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                title: Text('Order ID: ${orders[index]['id']}'),
                subtitle: Text('Table: ${orders[index]['table']}'),
                trailing: Text('Status: ${orders[index]['status']}'),
                onTap: () {
                  // Handle onTap, e.g., navigate to order details
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle new orders or other actions
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
