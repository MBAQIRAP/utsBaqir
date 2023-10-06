import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pekerja/ui/pekerja_list.dart';

class PekerjaUpdate extends StatefulWidget{
  String id;
  String nama_pekerjaan;
  String status_pekerjaan;
  String url;
  PekerjaUpdate({super.key, required this.id, required this.nama_pekerjaan, required this.status_pekerjaan,required this.url});
  @override
  _PekerjaUpdateState createState() => _PekerjaUpdateState(url : url);
}

class _PekerjaUpdateState extends State<PekerjaUpdate>{
  String url;
  _PekerjaUpdateState({required this.url});
  final _namaPekerjaController = TextEditingController();
  final _statusPekerjaController = TextEditingController();

  _buatInput(namacontroller, String hint,String data) {
    namacontroller.text=data;
    return TextField(
      controller: namacontroller,
      decoration: InputDecoration(
        hintText: hint,
      ),
    );
  }

  Future<void> updateData(String nama_pekerjaan, String status_pekerjaan,String id) async {
    final response = await http.put(Uri.parse(url),
      body: jsonEncode(<String, String>{
        'id' : id,
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
      throw Exception('Failed to Update Data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Pekerjaan'),
        ),
        body : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.all(20),
                  child : Column(
                    children: [
                      _buatInput(_namaPekerjaController, 'Masukkan Nama Pekerjaan',widget.nama_pekerjaan),
                      _buatInput(_statusPekerjaController, 'Masukkan Status Pekerjaan',widget.status_pekerjaan),
                    ],
                  )
              ),
              ElevatedButton(
                  child: const Text('Edit Mahasiswa'),
                  onPressed: () {
                    updateData(_namaPekerjaController.text,_statusPekerjaController.text,widget.id);
                  }
              )
            ]
        )
    );
  }
}