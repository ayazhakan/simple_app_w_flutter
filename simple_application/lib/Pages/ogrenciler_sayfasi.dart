import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ogrenci.dart';
import '../repository/ogrenciler_repository.dart';

class OgrencilerSayfasi extends ConsumerWidget {
  const OgrencilerSayfasi({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var ogrencilerRepository = ref.watch(ogrencilerProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text("Öğrenciler"),
        ),
        body: Column(
          children: [
            PhysicalModel(
              color: Colors.white,
              elevation: 10,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 32.0, horizontal: 32.0),
                  child: Text(
                      '${ogrencilerRepository.ogrenciler.length} Öğrenci'),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) =>
                    OgrenciSatiri(
                        ogrencilerRepository.ogrenciler[index]),
                itemCount: ogrencilerRepository.ogrenciler.length,
              ),
            ),
          ],
        ));
  }
}

class OgrenciSatiri extends ConsumerWidget {
  final Ogrenci ogrenci;


  const OgrenciSatiri(this.ogrenci, {
    super.key,
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var seviyorMuyum = ref.watch(ogrencilerProvider).seviyorMuyum(ogrenci);

    return ListTile(
        title: AnimatedPadding(
          duration: const Duration(seconds:1),
          padding: seviyorMuyum ? const EdgeInsets.only(left:60) : const EdgeInsets.only(),
          child: Text('${ogrenci.ad} ${ogrenci.soyad}'),
          curve: Curves.bounceOut,
        ),
      leading: IntrinsicWidth(
        child: Center(
         child: Text(ogrenci.cinsiyet == 'Kadın' ? '👩' : '👨'))),
          trailing: IconButton(
          onPressed: () {

          ref.read(ogrencilerProvider).sev(ogrenci, !seviyorMuyum);

            },icon: AnimatedCrossFade(
               firstChild: const Icon(Icons.favorite),
               secondChild: const Icon(Icons.favorite_border),
              crossFadeState: seviyorMuyum ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: const Duration(seconds: 2),

    ),

    ));
  }
}
