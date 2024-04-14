import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

class MovieUploadScreen extends StatefulWidget {
  @override
  _MovieUploadScreenState createState() => _MovieUploadScreenState();
}

class _MovieUploadScreenState extends State<MovieUploadScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String videoUrl = '';
  String posterUrl = '';

  Future<void> _selectVideoFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = file.path.split('/').last;
      Reference ref = FirebaseStorage.instance.ref().child('videos/$fileName');
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      String url = await snapshot.ref.getDownloadURL();
      setState(() {
        videoUrl = url;
      });
    }
  }

  Future<void> _uploadMovie() async {
    String name = nameController.text;
    String category = categoryController.text;
    String description = descriptionController.text;

    // Generate a unique string ID using FirebaseFirestore
    String id = FirebaseFirestore.instance.collection('series').doc().id;

    await FirebaseFirestore.instance.collection('series').doc(id).set({
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'videoUrl': videoUrl,
      'posterUrl': posterUrl,
      'isSeries': false,
    });

    // Reset the form after uploading
    nameController.clear();
    categoryController.clear();
    descriptionController.clear();
    setState(() {
      videoUrl = '';
      posterUrl = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Movie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Movie Name'),
              ),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              ElevatedButton(
                onPressed: _selectVideoFile,
                child: Text('Select Video File'),
              ),
              if (videoUrl.isNotEmpty)
                Text(
                  'Video Uploaded',
                  style: TextStyle(color: Colors.green),
                ),
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.image,
                  );
                  if (result != null) {
                    File file = File(result.files.single.path!);
                    String fileName = file.path.split('/').last;
                    Reference ref = FirebaseStorage.instance
                        .ref()
                        .child('posters/$fileName');
                    UploadTask uploadTask = ref.putFile(file);
                    TaskSnapshot snapshot =
                        await uploadTask.whenComplete(() {});
                    String url = await snapshot.ref.getDownloadURL();
                    setState(() {
                      posterUrl = url;
                    });
                  }
                },
                child: Text('Select Poster Image'),
              ),
              if (posterUrl.isNotEmpty)
                Text(
                  'Poster Image Uploaded',
                  style: TextStyle(color: Colors.green),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadMovie,
                child: Text('Upload Movie'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
