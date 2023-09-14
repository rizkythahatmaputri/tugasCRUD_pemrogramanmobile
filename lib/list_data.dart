import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tugas_crud/side_menu.dart';
import 'package:tugas_crud/tambah_data.dart';
import 'package:http/http.dart' as http;
import 'package:universal_platform/universal_platform.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListData(),
    );
  }
}

class ListData extends StatefulWidget {
  const ListData({Key? key}) : super(key: key);

  @override
  _ListDataState createState() => _ListDataState();
}


class _ListDataState extends State<ListData> {
  List<Map<String, String>> dataMahasiswa = [];
String url = UniversalPlatform.isWeb
    ? 'http://localhost/api_flutter/index.php'
    : 'http://192.168.1.18/api_flutter/index.php';
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        dataMahasiswa = List<Map<String, String>>.from(data.map((item) {
          return {
            'nama': item['nama'] as String,
            'jurusan': item['jurusan'] as String,
            'id': item['id'] as String,
          };
        }));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

deleteData(int id) async {
  final response = await http.delete(Uri.parse('$url?id=$id'));
  if (response.statusCode == 200) {
    final responseBody = response.body;
    try {
      return json.decode(responseBody);
    } catch (e) {
      throw Exception('Failed to decode response body');
    }
  } else {
    throw Exception('Failed to delete data');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Data Mahasiswa'),
      ),
      drawer: const SideMenu(),
      body: Column(children: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TambahData(),
              ),
            );
          },
          child: const Text('Tambah Data Mahasiswa'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: dataMahasiswa.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(dataMahasiswa[index]['nama']!),
                subtitle: Text('Jurusan: ${dataMahasiswa[index]['jurusan']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.visibility),
                      onPressed: () {
                        //lihatMahasiswa(index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        //editMahasiswa(index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteData(int.parse(dataMahasiswa[index]['id']!))
                            .then((result) {
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
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ListData(),
                                            ),
                                          );
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
        )
      ]),
    );
  }
}
