import 'package:flutter/material.dart';
import 'package:kresadmin/constants.dart';
import 'package:kresadmin/models/student.dart';

class ImageWidget extends StatelessWidget {
  final Student student;

  ImageWidget(this.student);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
          decoration: BoxDecoration(
            color: student.fotoUrl != null ? Colors.white : backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),

          /// space from white container

          height: 350,
          width: 350,
          child: Stack(
            children: [
              buildImage(),
              buildTopText(),
              Positioned(
                bottom: 40,
                left: 5,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: student.veliAdiSoyadi!,
                        style: TextStyle(color: changeTextColor())),
                    const TextSpan(
                        text: ' (Veli)',
                        style: TextStyle(color: Colors.grey, fontSize: 12))
                  ])),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 5,
                child: Text(
                  student.dogumTarihi!,
                  style: TextStyle(color: changeTextColor(), fontSize: 22),
                ),
              ),
              Positioned(
                right: 5,
                bottom: 10,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    student.cinsiyet!,
                    style: TextStyle(color: changeTextColor(), fontSize: 20),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Color changeTextColor() {
    return student.fotoUrl != null ? Colors.white : Colors.black45;
  }

  Widget buildAddressRating({
    required Student student,
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [],
      );

  Widget buildImage() => SizedBox.expand(
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: student.fotoUrl != null
              ? Image.network(student.fotoUrl!, fit: BoxFit.cover)
              : Center(
                  child: Icon(
                  Icons.person,
                  size: 250,
                  color: Colors.black45,
                )),
        ),
      );

  Widget buildTopText() => Positioned(
        top: 10,
        left: 5,
        child: Text(
          student.adiSoyadi,
          style: TextStyle(
            color: changeTextColor(),
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
      );
}
