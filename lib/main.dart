import 'package:flutter/material.dart';
import 'package:pekerja/ui/pekerja_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Pekerjaan",
      home: PekerjaList(),
    );
  }
}