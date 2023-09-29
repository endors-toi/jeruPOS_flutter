import 'package:flutter/material.dart';

class TableRowWidget extends StatelessWidget {
  final List<String> items;
  final bool header;

  TableRowWidget({
    required this.items,
    this.header = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(items[0])),
          Expanded(flex: 2, child: Text(items[1])),
          Expanded(flex: 2, child: Text(items[2])),
          Expanded(
            flex: 1,
            child: header
                ? Text(items[3])
                : IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Navigate to edit page
                    },
                  ),
          ),
          Expanded(
            flex: 1,
            child: header
                ? Text(items[4])
                : IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Delete the item
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
