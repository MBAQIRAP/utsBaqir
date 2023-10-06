import 'package:flutter/material.dart';
import 'package:pekerja/ui/pekerja_tambah.dart';
import 'package:pekerja/ui/pekerja_update.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
class PekerjaList extends StatefulWidget{
  const PekerjaList({Key? key}) : super(key: key);
  @override
  _PekerjaListState createState() => _PekerjaListState();
}

class _PekerjaListState extends State<PekerjaList>{
  String url = Platform.isAndroid  ? 'http://192.168.1.130/uts_pemmob/index.php' : 'http://localhost/uts_pemmob/index.php';
  List<Map<String, dynamic>> dataPekerjaan = [];

  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        dataPekerjaan = List<Map<String, dynamic>>.from(data.map((item) {
          return {
            'nama_pekerjaan': item['nama_pekerjaan'] as String,
            'status_pekerjaan': item['status_pekerjaan'] as String,
            'id': item['id'] as String,
          };
        }));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future deleteData(int id) async {
    final response = await http.delete(Uri.parse('$url?id=$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete data');
    }
  }


  lihatPekerjaan(String nama_pekerjaan, String status_pekerjaan){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Nama Pekerjaan : $nama_pekerjaan"),
              content: Text("Status Pekerjaan : $status_pekerjaan")
          );
        }
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Pekerjaan"),
      ),
      body: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => PekerjaanTambah(url: url),
                ),);
              },
              child: const Text('Tambah Data Pekerjaan'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: dataPekerjaan.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(dataPekerjaan[index]['nama_pekerjaan']!),
                    subtitle: Text('status Pekerjaan: ${dataPekerjaan[index]['status_pekerjaan']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.visibility),
                          onPressed: () {
                            lihatPekerjaan(dataPekerjaan[index]['nama_pekerjaan']!,dataPekerjaan[index]['status_pekerjaan']!);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (context) => PekerjaUpdate(id : dataPekerjaan[index]['id'],nama_pekerjaan : dataPekerjaan[index]['nama_pekerjaan'],status_pekerjaan : dataPekerjaan[index]['status_pekerjaan'],url: url),
                            ),);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteData(int.parse(dataPekerjaan[index]['id'])).then((result) {
                              if (result['pesan'] == 'berhasil') {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Data berhasil di hapus'),
                                        content: const Text('ok'),
                                        actions: [
                                          TextButton(
                                            child: const Text('OK'),
                                            onPressed: () {
                                              Navigator.pushReplacement(context, MaterialPageRoute(
                                                builder: (context) => const PekerjaList(),
                                              ),);
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ]
      ),
    );
  }
}