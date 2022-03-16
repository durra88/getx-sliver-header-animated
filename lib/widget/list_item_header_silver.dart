import 'package:challengesrollitemheader/controller/silver_controller.dart';
import 'package:challengesrollitemheader/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListItemHeaderSliver extends StatelessWidget {
  ListItemHeaderSliver({Key? key, required this.controller}) : super(key: key);
  final SliverScrollController controller;
//  final controller = Get.put(SliverScrollController());

  @override
  Widget build(BuildContext context) {
    final itemsOffsets = controller.listOffsetItemHeader;
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: NotificationListener<ScrollNotification>(
        onNotification: ((notification) => true),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              right: size.width -
                  (itemsOffsets[itemsOffsets.length - 1] -
                      itemsOffsets[itemsOffsets.length - 2])),
          controller: controller.scrollControllerItemHeader,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: GetX<SliverScrollController>(builder: (controller) {
           
            return Row(
              children: List.generate(controller.listCategory.length, (index) {
                return GetBoxOffset(
                  offset: ((offset) {
                    itemsOffsets[index] = offset.dx;
                  }),
                  child: Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: index == controller.headerNotifier.value.index
                          ? Colors.white
                          : null,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      controller.listCategory[index].category,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: index == controller.headerNotifier.value.index
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ),
      ),
    );
  }
}
