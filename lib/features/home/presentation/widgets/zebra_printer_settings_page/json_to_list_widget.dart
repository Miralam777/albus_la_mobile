import 'package:flutter/material.dart';

// TODO: remove or use
class JsonToListWidget extends StatelessWidget {
  const JsonToListWidget({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final key = data.keys.elementAt(index);
        final value = data[key];
        return ListTile(
          title: Text('$key:'),
          subtitle: Text(value.toString()),
        );
      },
    );
  }
}
