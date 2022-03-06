import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/constants/constants.dart';
import 'package:crud/models/item.dart';
import 'package:crud/themes/colors.dart';
import 'package:crud/widgets/add_item.dart';
import 'package:crud/widgets/edit_item.dart';
import 'package:crud/widgets/item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loader = false;

  late String phone;
  var itemsRef = FirebaseFirestore.instance.collection('items');
  List<Item> items = [];
  var bottomSheetShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('ITEMS'), centerTitle: true),
        body: Center(
          child: StreamBuilder(
            stream: getItems(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) items = snapshot.data;

              if (snapshot.hasError || items.isEmpty) {
                return const Text('No items');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  Item item = items[index];
                  return ItemWidget(
                    item: item,
                    onPress: () => deleteItem(item),
                    onPressEdit: () => _modalBottomSheetUpdateItem(item),
                  );
                },
              );
            },
          ),
        ),
        floatingActionButton: GestureDetector(
          onTap: _modalBottomSheetAddItem,
          child: Container(
            height: 69,
            width: 69,
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey[400]!,
                blurRadius: 5.0,
              ),
            ], borderRadius: BorderRadius.circular(16), color: colorSecondary),
            child: SvgPicture.asset(icAdd, color: colorFont),
          ),
        ),
      ),
    );
  }

  Stream<List<Item>> getItems() {
    var snapshots = itemsRef.orderBy('createdAt', descending: true).snapshots();

    return snapshots.map((snapshot) => snapshot.docs.map((doc) {
          Item item = Item.fromJson(doc.data());
          item.id = doc.id;
          return item;
        }).toList());
  }

  deleteItem(Item item) async => await itemsRef.doc(item.id).delete();

  void _modalBottomSheetAddItem() {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: bottomSheetShape,
      backgroundColor: colorWhite,
      context: context,
      builder: (builder) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Wrap(children: const [AddItem()]),
      ),
    );
  }

  void _modalBottomSheetUpdateItem(Item item) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: bottomSheetShape,
      backgroundColor: colorWhite,
      context: context,
      builder: (builder) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Wrap(children: [EditItem(item: item)]),
      ),
    );
  }
}
