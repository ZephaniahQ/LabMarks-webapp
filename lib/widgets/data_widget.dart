import 'package:flutter/material.dart';

class DataCard extends StatelessWidget {
  final Map<String, String>? rollData;
  final String heading;

  const DataCard({super.key, required this.rollData, required this.heading});

  @override
  Widget build(BuildContext context) {
    // Use a null check to handle potential null values in data
    if (rollData == null) {
      return _buildEmptyCard();
    }

    return Center(
      child: Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: SizedBox(
          width: 320.0, // Set a fixed width for the table
          child: Table(
            border: TableBorder.all(
              color: Colors.grey.withOpacity(0.5),
              width: 1,
            ),
            columnWidths: const {
              0: FixedColumnWidth(150.0), // First column width
              1: FixedColumnWidth(
                  150.0), // Second column width, same as the first
            },
            children: [
              // Table header
              TableRow(
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                ),
                children: [
                  _buildCell(heading),
                  _buildCell('Marks'),
                ],
              ),
              // Table rollData rows
              ...rollData!.entries.map((entry) {
                return TableRow(
                  children: [
                    _buildCell(entry.key),
                    _buildCell(entry.value),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCell(String content) {
    bool isError = content.startsWith("Error");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        content,
        style: TextStyle(
          fontSize: 16,
          color: isError ? Colors.red : null,
          fontWeight: isError ? FontWeight.bold : null,
        ),
      ),
    );
  }

  Widget _buildEmptyCard() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'No Data Available',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
