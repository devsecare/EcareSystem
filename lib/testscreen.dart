import 'package:ecaresystem/services/database/database.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    await DataBase("").testData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Screen"),
      ),
      body: Container(
        child: Center(
          child: TextButton(
            onPressed: () async {
              getData();
            },
            child: Text("run"),
          ),
        ),
      ),
    );
  }
}
