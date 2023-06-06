import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_application/repository/mesajlar_repository.dart';

import '../models/mesaj.dart';

class MesajlarSayfasi extends ConsumerStatefulWidget{
  const MesajlarSayfasi({super.key});

  @override
  _MesajlarSayfasiState createState() => _MesajlarSayfasiState();
}

class _MesajlarSayfasiState extends ConsumerState<MesajlarSayfasi> {

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) => ref.read(yeniMesajSayisiProvider.notifier).sifirla());

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final mesajlarRepository=ref.watch(mesajlarProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text("Mesajlar"),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: mesajlarRepository.mesajlar.length,
                itemBuilder: (context, index) {
                  return MesajGorunumu(mesajlarRepository.mesajlar[mesajlarRepository.mesajlar.length - index - 1]);
                },
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                        child: DecoratedBox(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(20.0))),
                          child: const Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                            ),
                          )
                        ),

                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: ElevatedButton(
                        onPressed: () {
                          print("gönder");
                        },
                        child: Text('Gönder')
                    ),
                  )
                ],
              ),
            )
          ],
        )
    );
  }
}

class MesajGorunumu extends StatelessWidget {
  final Mesaj mesaj;
  const MesajGorunumu(this.mesaj, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          mesaj.gonderen == 'Ali' ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 8.0, horizontal: 16.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              color: Colors.orange.shade100,
              borderRadius:
                  const BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
                mesaj.yazi
                ),
          ),
        ),
      ),
    );
  }
}