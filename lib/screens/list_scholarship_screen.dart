import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../models/scholarship_model.dart';
import '../services/firebase_service.dart';
import 'edit_scholarship_screen.dart';
import 'scholarship_form_screen.dart';

class ListScholarshipScreen extends StatefulWidget {
  const ListScholarshipScreen({Key? key}) : super(key: key);

  @override
  State<ListScholarshipScreen> createState() => _ListScholarshipScreenState();
}

class _ListScholarshipScreenState extends State<ListScholarshipScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Data Penerima Beasiswa',
          style: TextStyle(
            color: Colors.blue[900],
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blue[700]),
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ScholarshipFormScreen(),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 112, 178, 253),
        icon: const Icon(Icons.add),
        label: const Text(
          'Tambah Data',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ScholarshipModel>>(
              stream: FirebaseService().getScholarships(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                        const SizedBox(height: 16),
                        Text(
                          'Terjadi kesalahan',
                          style: TextStyle(fontSize: 16, color: Colors.red[700]),
                        ),
                        Text(
                          '${snapshot.error}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.blue[700]),
                        const SizedBox(height: 16),
                        Text(
                          'Memuat data...',
                          style: TextStyle(color: Colors.blue[700]),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_outlined, size: 80, color: Colors.blue[200]),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada data penerima beasiswa',
                          style: TextStyle(fontSize: 16, color: Colors.blue[700]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tekan + untuk menambahkan data',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    ScholarshipModel data = snapshot.data![index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // FOTO KTP
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue.shade200),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(data.fotoKtpUrl),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.image, color: Colors.blue[300]);
                                  },
                                ),
                              ),
                            ),
                            
                            const SizedBox(width: 12),
                            
                            // INFO MAHASISWA
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.namaPenerima,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  
                                  // NIM
                                  Row(
                                    children: [
                                      Icon(Icons.badge, size: 14, color: Colors.blue[600]),
                                      const SizedBox(width: 6),
                                      Text(
                                        'NIM: ${data.nim}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.blue[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  
                                  // JURUSAN
                                  Row(
                                    children: [
                                      Icon(Icons.school, size: 14, color: Colors.blue[600]),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          data.jurusan,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.blue[700],
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  
                                  // TANGGAL
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today, size: 12, color: Colors.grey[600]),
                                      const SizedBox(width: 6),
                                      Text(
                                        DateFormat('dd MMM yyyy, HH:mm').format(data.tanggalPengajuan),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            
                            Column(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue[600]),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditScholarshipScreen(scholarship: data),
                                      ),
                                    );
                                  },
                                  tooltip: 'Edit Data',
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red[600]),
                                  onPressed: () async {
                                    bool confirm = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        title: const Text('Hapus Data'),
                                        content: Text(
                                          'Yakin hapus ${data.namaPenerima}?',
                                          style: TextStyle(color: Colors.blue[700]),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: Text(
                                              'Batal',
                                              style: TextStyle(color: Colors.blue[700]),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red[600],
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: const Text('Hapus'),
                                          ),
                                        ],
                                      ),
                                    );
                                    
                                    if (confirm == true) {
                                      await FirebaseService().deleteScholarshipData(data.id);
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text('Data berhasil dihapus!'),
                                          backgroundColor: Colors.green,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  tooltip: 'Hapus Data',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}