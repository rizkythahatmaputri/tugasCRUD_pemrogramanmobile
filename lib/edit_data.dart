import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tugas_crud/list_data.dart';
import 'package:tugas_crud/side_menu.dart';

class EditData extends StatefulWidget {
  const EditData({Key? key, required this.nama, required this.jurusan, required this.id})
      : super(key: key);
  final String nama;
  final String jurusan;
  final String id;
  @override
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  final namaController = TextEditingController();
  final jurusanController = TextEditingController();

  Future updateData(String nama, String jurusan) async {
    String url = Platform.isAndroid
        ? 'http://192.168.1.18/api_flutter/index.php'
        : 'http://localhost/api_flutter/index.php';
    // String url = 'http://localhost/api-flutter/index.php';

    //String url = 'http://127.0.0.1/apiTrash/prosesLoginDriver.php';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody = '{"id": "${widget.id}","nama": "$nama", "jurusan": "$jurusan"}';
    var response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update data');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    namaController.text = widget.nama;
    jurusanController.text = widget.jurusan;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data Mahasiswa'),
      ),
      drawer: const SideMenu(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                hintText: 'Nama Mahasiswa',
              ),
            ),
            TextField(
              controller: jurusanController,
              decoration: const InputDecoration(
                hintText: 'Jurusan',
              ),
            ),
            ElevatedButton(
              child: const Text('Update Mahasiswa'),
              onPressed: () {
                String nama = namaController.text;
                String jurusan = jurusanController.text;
                // print(nama);
                updateData(nama, jurusan).then((result) {
                  //print(result['pesan']);
                  if (result['pesan'] == 'berhasil') {
                    showDialog(
                        context: context,
                        builder: (context) {
                          //var namauser2 = namauser;
                          return AlertDialog(
                            title: const Text('Data berhasil di update'),
                            content: const Text('ok'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ListData(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        });
                  }
                  setState(() {});
                });
              },
            ),
          ],
        ),

        //     ],
        //   ),
        // ),
      ),
    );
  }
}