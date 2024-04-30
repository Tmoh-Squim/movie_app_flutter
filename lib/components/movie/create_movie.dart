import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

class UploadDataScreen extends StatefulWidget {
  @override
  _UploadDataScreenState createState() => _UploadDataScreenState();
}

class _UploadDataScreenState extends State<UploadDataScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String posterImageUrl = '';
  List<int> seasons = [];
  List<Map<String, dynamic>> episodes = [];

  Future<void> _selectPosterImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = file.path.split('/').last;
      Reference ref = FirebaseStorage.instance.ref().child('posters/$fileName');
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      String imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        posterImageUrl = imageUrl;
      });
    }
  }

  Future<void> _uploadData() async {
    String name = nameController.text;
    String description = descriptionController.text;

    // Upload data to Firestore
    await FirebaseFirestore.instance.collection('series').doc().set({
      'name': name,
      'description': description,
      'posterUrl': posterImageUrl,
      'seasons': seasons,
      'episodes': episodes,
      'isSeries': true,
      'id': DateTime.now().millisecondsSinceEpoch
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Data')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              ElevatedButton(
                onPressed: _selectPosterImage,
                child: Text('Select Poster Image'),
              ),
              posterImageUrl.isNotEmpty
                  ? Column(
                      children: [
                        Image.network(
                          posterImageUrl,
                          width: 100,
                          height: 100,
                        ),
                        Text(
                          'Poster uploaded',
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    )
                  : SizedBox(),
              TextField(
                decoration:
                    InputDecoration(labelText: 'Seasons (Comma Separated)'),
                onChanged: (value) {
                  setState(() {
                    seasons = value
                        .split(',')
                        .map((e) => int.parse(e.trim()))
                        .toList();
                  });
                },
              ),
              SizedBox(height: 20),
              ...episodes
                  .asMap()
                  .entries
                  .map(
                      (entry) => _buildEpisodeTextField(entry.key, entry.value))
                  .toList(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    episodes.add({});
                  });
                },
                child: Text('Add Episode'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadData,
                child: Text('Upload Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEpisodeTextField(int index, Map<String, dynamic> episode) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'Episode Name'),
          onChanged: (value) {
            setState(() {
              episode['name'] = value;
            });
          },
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Season'),
          onChanged: (value) {
            setState(() {
              episode['season'] = value;
            });
          },
          keyboardType: TextInputType.number,
        ),
        ElevatedButton(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();
            if (result != null) {
              File file = File(result.files.single.path!);
              String fileName = file.path.split('/').last;
              Reference ref =
                  FirebaseStorage.instance.ref().child('videos/$fileName');
              UploadTask uploadTask = ref.putFile(file);
              TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
              String videoUrl = await snapshot.ref.getDownloadURL();
              setState(() {
                episode['videoUrl'] = videoUrl;
              });
            }
          },
          child: Text('Upload Video'),
        ),
        SizedBox(height: 10),
        if (episode.containsKey('video')) // Only show when video is uploaded
          Text(
            'Video uploaded',
            style: TextStyle(color: Colors.green),
          ),
        SizedBox(height: 20),
      ],
    );
  }
}
