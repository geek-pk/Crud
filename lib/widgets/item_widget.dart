import 'package:crud/constants/constants.dart';
import 'package:crud/models/item.dart';
import 'package:crud/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget(
      {Key? key, required this.item, required this.onPress, this.onPressEdit})
      : super(key: key);
  final Item item;
  final dynamic onPress;
  final dynamic onPressEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey[400]!,
          blurRadius: 5.0,
        ),
      ], color: colorRed, borderRadius: BorderRadius.circular(12)),
      child: Slidable(
        key: const ValueKey(0),
        startActionPane: ActionPane(
          extentRatio: 0.2,
          motion: const BehindMotion(),
          children: [
            Expanded(
              child: InkWell(
                onTap: onPress,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorRed,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(icDelete),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        child: Container(
          // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
              color: colorCard, borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(item.image!),
                    ),
                    color: colorCard,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12))),
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title ?? "Title",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(item.description ?? 'Description',
                      style: const TextStyle(color: Colors.black)),
                ],
              ),
              Expanded(child: Container()),
              InkWell(
                onTap: onPressEdit,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorIconBackground,
                  ),
                  child: SvgPicture.asset(icEdit, color: colorPrimary),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
