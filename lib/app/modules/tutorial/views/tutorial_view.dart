import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugasteori1/app/modules/tutorial/controllers/tutorial_controller.dart';

class TutorialView extends GetView<TutorialController> {
  @override
  Widget build(BuildContext context) {
    Get.put<TutorialController>(TutorialController());
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),
        backgroundColor: Colors.grey[200],
      ),
      body: Container(
        color: Colors.grey[200], // Menambahkan background abu-abu
        padding: EdgeInsets.all(10.0),
        child: Card(
          color: Colors.white, // Card dengan warna putih
          elevation: 4.0, // Memberikan efek bayangan pada card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Membuat card lebih rounded
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.tutorialList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(controller.tutorialList[index]),
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
