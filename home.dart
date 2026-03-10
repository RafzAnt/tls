import 'package:flutter/material.dart';

void main() {
  runApp(const ToolHubApp());
}

class ToolHubApp extends StatelessWidget {
  const ToolHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ToolHubPage(),
    );
  }
}

class ToolHubPage extends StatefulWidget {
  const ToolHubPage({super.key});

  @override
  State<ToolHubPage> createState() => _ToolHubPageState();
}

class _ToolHubPageState extends State<ToolHubPage> {
  final deliveryFee = 50;

  List tools = [
    {"name": "Hammer", "price": 250, "qty": 0},
    {"name": "Bolt Set", "price": 80, "qty": 0},
    {"name": "Screwdriver", "price": 150, "qty": 0},
    {"name": "Measuring Tape", "price": 120, "qty": 0},
  ];

  double get subtotal {
    double total = 0;
    for (var tool in tools) {
      total += tool["price"] * tool["qty"];
    }
    return total;
  }

  double get vat => subtotal * 0.10;

  double get total => subtotal + vat + deliveryFee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ToolHub"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [

            Expanded(
              child: ListView.builder(
                itemCount: tools.length,
                itemBuilder: (context, index) {
                  return toolItem(index);
                },
              ),
            ),

            const Divider(),

            priceRow("Subtotal:", subtotal),
            priceRow("Delivery Fee:", deliveryFee.toDouble()),
            priceRow("VAT (10%):", vat),

            const Divider(),

            priceRow("Total:", total, isTotal: true),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.all(15),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Order Placed!")),
                  );
                },
                child: const Text("Place Order"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget toolItem(int index) {
    var tool = tools[index];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tool["name"],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("₱${tool["price"]}.00"),
              ],
            ),
          ),

          SizedBox(
            width: 70,
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Qty",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  tool["qty"] = int.tryParse(value) ?? 0;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget priceRow(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: isTotal ? 18 : 14,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text("₱${value.toStringAsFixed(2)}",
              style: TextStyle(
                  color: isTotal ? Colors.orange : Colors.black,
                  fontSize: isTotal ? 18 : 14,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}