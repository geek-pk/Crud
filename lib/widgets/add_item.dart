import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/models/item.dart';
import 'package:crud/themes/colors.dart';
import 'package:crud/utils.dart';
import 'package:crud/widgets/theme_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  CollectionReference itemsRef = FirebaseFirestore.instance.collection('items');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  File? image;
  bool loader = false;
  late TextEditingController _controllerTitle, _controllerDescription;

  @override
  void initState() {
    super.initState();
    _controllerTitle = TextEditingController();
    _controllerDescription = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text('Add Item',
                style: Theme.of(context).textTheme.headlineLarge),
          ),
          GestureDetector(
            onTap: pickImage,
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  color: colorSecondary,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: image == null
                        ? FileImage(File('')) as ImageProvider
                        : FileImage(image!),
                  ),
                  borderRadius: BorderRadius.circular(16)),
              child: image == null ? const Icon(Icons.add) : Container(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controllerTitle,
            // onChanged: (onChanged) => title = onChanged,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Title',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controllerDescription,
            // onChanged: (onChanged) => description = onChanged,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Description',
            ),
          ),
          ThemeButton(title: 'SAVE', loader: loader, onPress: _addItem),
        ],
      ),
    );
  }

  _addItem() async {
    if (loader) return;
    if (_controllerTitle.text.isEmpty ||
        _controllerDescription.text.isEmpty ||
        image == null) {
      showToast('Please fill all the fields');
      return;
    }
    var imageUrl = await _uploadImage();
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    Item item = Item(
        title: _controllerTitle.text,
        description: _controllerDescription.text,
        image: imageUrl.toString(),
        createdAt: timestamp);

    await itemsRef.add(item.toJson()).then((value) {
      setState(() => loader = false);
      showToast('item added');
      Navigator.pop(context);
    }).catchError((onError) {
      setState(() => loader = false);
      showToast('something went wrong');
      Navigator.pop(context);
    });
  }

  _uploadImage() async {
    if (image == null) return;
    setState(() => loader = true);

    Reference reference = _storage
        .ref()
        .child("images/" + DateTime.now().millisecondsSinceEpoch.toString());
    var uploadTask = reference
        .putFile(image!)
        .then((p0) async => Uri.parse(await reference.getDownloadURL()));

    return uploadTask;
  }

  pickImage() async {
    XFile? _imageFile =
        (await ImagePicker().pickImage(source: ImageSource.gallery));
    if (_imageFile == null) return;

    File image = File(_imageFile.path);

    setState(() => this.image = image);
  }
}
