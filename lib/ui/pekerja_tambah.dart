import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pekerja/ui/pekerja_list.dart';

class PekerjaanTambah extends StatefulWidget{
  String url;
  PekerjaanTambah({super.key,required this.url});
  @override
  _PekerjaanTambahState createState() => _PekerjaanTambahState(url: url);
}

class _PekerjaanTambahState extends State<PekerjaanTambah>{
  String url;
  _PekerjaanTambahState({required this.url});
  final _namaPekerjaanController = TextEditingController();
  final _statusPekerjaanController = TextEditingController();

  _buatInput(namacontroller, String hint) {
    return TextField(
      controller: namacontroller,
      decoration: InputDecoration(
        hintText: hint,
      ),
    );
  }

  Future<void> insertData(String nama_pekerjaan, String status_pekerjaan) async {
    final response = await http.post(Uri.parse(url),
      body: jsonEncode(<String, String>{
        'nama_pekerjaan': nama_pekerjaan,
        'status_pekerjaan' : status_pekerjaan
      }),
    );
    if(response.statusCode == 200){
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => const PekerjaList(),
      ),
      );
    }else{
      throw Exception('Failed to Insert Data');
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tambah Pekerjaan'),
        ),
        body : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.all(20),
                  child : Column(
                    children: [
                      _buatInput(_namaPekerjaanController, 'Masukkan Nama Pekerjaan'),
                      _buatInput(_statusPekerjaanController, 'Masukkan Status Pekerjaan'),
                    ],
                  )
              ),
              ElevatedButton(
                  child: const Text('Tambah Pekerjaan'),
                  onPressed: () {
                    insertData(_namaPekerjaanController.text,_statusPekerjaanController.text);
                  }
              )
            ]
        )
    );
  }
}

