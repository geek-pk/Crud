import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/models/item.dart';
import 'package:crud/utils.dart';
import 'package:crud/widgets/theme_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../themes/colors.dart';

class EditItem extends StatefulWidget {
  const EditItem({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  CollectionReference itemsRef = FirebaseFirestore.instance.collection('items');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  File? image;
  bool loader = false;
  late TextEditingController _controllerTitle, _controllerDescription;
  late Item item;

  @override
  void initState() {
    super.initState();
    item = widget.item;
    _controllerTitle = TextEditingController(text: item.title);
    _controllerDescription = TextEditingController(text: item.description);
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
            child: Text('Edit Item',
                style: Theme.of(context).textTheme.headlineLarge),
          ),
          GestureDetector(
            onTap: pickImage,
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  color: colorCard,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: image == null
                        ? NetworkImage(item.image!) as ImageProvider
                        : FileImage(image!),
                  ),
                  borderRadius: BorderRadius.circular(16)),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controllerTitle,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Title',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controllerDescription,
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
    if (_controllerTitle.text.isEmpty || _controllerDescription.text.isEmpty) {
      showToast('Please fill all the fields');
      return;
    }
    setState(() => loader = true);
    var imageUrl = await uploadImage();

    item.title = _controllerTitle.text;
    item.description = _controllerDescription.text;
    item.image = imageUrl.toString();

    await itemsRef.doc(item.id).update(item.toJson()).then((value) {
      showToast('item updated');
      Navigator.pop(context);
    }).catchError((onError) {
      showToast('Something went wrong');
      Navigator.pop(context);
    });
  }

  uploadImage() async {
    if (image == null) return item.image;

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
