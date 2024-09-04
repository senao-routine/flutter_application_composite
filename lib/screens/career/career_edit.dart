import 'package:flutter/material.dart';

class CareerEdit extends StatefulWidget {
  @override
  _CareerEditState createState() => _CareerEditState();
}

class _CareerEditState extends State<CareerEdit> {
  List<String> _careerItems = [];
  TextEditingController _controller = TextEditingController();

  void _addCareerItem() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        _careerItems.add(_controller.text);
        _controller.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Career')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _careerItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_careerItems[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _careerItems.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'New Career Item'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addCareerItem,
                ),
              ],
            ),
          ),
          ElevatedButton(
            child: Text('Save'),
            onPressed: () {
              // TODO: Save career data
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
