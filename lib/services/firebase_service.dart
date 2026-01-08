import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/scholarship_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Simpan data beasiswa
  Future<bool> saveScholarshipData(ScholarshipModel data) async {
    try {
      await _firestore.collection('penerima_beasiswa').add(data.toMap());
      return true;
    } catch (e) {
      print('Error saving data: $e');
      return false;
    }
  }

  // UPDATE data beasiswa
  Future<bool> updateScholarshipData(String id, ScholarshipModel data) async {
    try {
      await _firestore.collection('penerima_beasiswa').doc(id).update(data.toMap());
      return true;
    } catch (e) {
      print('Error updating data: $e');
      return false;
    }
  }

  // DELETE data beasiswa
  Future<bool> deleteScholarshipData(String id) async {
    try {
      await _firestore.collection('penerima_beasiswa').doc(id).delete();
      return true;
    } catch (e) {
      print('Error deleting data: $e');
      return false;
    }
  }

  // Ambil data beasiswa
  Stream<List<ScholarshipModel>> getScholarships() {
    return _firestore
        .collection('penerima_beasiswa')
        .orderBy('tanggalPengajuan', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ScholarshipModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  // Simpan gambar ke lokal storage
  Future<String> uploadImage(XFile image, String folder) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final folderDir = Directory('${appDir.path}/$folder');
      
      if (!await folderDir.exists()) {
        await folderDir.create(recursive: true);
      }
      
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_${image.name}';
      final savedImage = File('${folderDir.path}/$fileName');
      
      await File(image.path).copy(savedImage.path);
      
      print('Image saved to: ${savedImage.path}');
      return savedImage.path;
    } catch (e) {
      print('Error saving image locally: $e');
      throw Exception('Gagal menyimpan gambar: $e');
    }
  }
}