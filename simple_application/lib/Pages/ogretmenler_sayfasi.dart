import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_application/Pages/ogretmen/ogretmen_form.dart';
import 'package:simple_application/models/ogretmen.dart';

import '../repository/ogretmenler_repository.dart';

class OgretmenlerSayfasi extends ConsumerWidget {
  const OgretmenlerSayfasi({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ogretmenlerRepository = ref.watch(ogretmenlerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Öğretmenler"),
      ),
      body: Column(
        children: [
          PhysicalModel(
            color: Colors.white,
            elevation: 10,
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 32.0, horizontal: 32.0),
                    child: Hero(
                        tag: 'ogretmen',
                        child: Material(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            color: Colors.grey.shade300,
                            child: Text(
                                "${ogretmenlerRepository.ogretmenler.length} Öğretmen"),
                          ),
                        )),
                  ),
                ),
                const Align(
                    alignment: Alignment.centerRight,
                    child: OgretmenIndirmeButonu())
              ],
            ),
          ),
          Expanded(
              child: RefreshIndicator(
                onRefresh:
                () async {
                  ref.refresh(ogretmenListesiProvider);
                },
                child: ref.watch(ogretmenListesiProvider).when(
                      data: (data) => ListView.separated(
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) =>
                            OgretmenSatiri(data[index]),
                        itemCount: data.length,
                      ),
                      error: (error, stackTrace) {
                        return const SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Text('error'),
                            );


                      },
                      loading: () {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.of(context)
              .push(MaterialPageRoute<bool>(builder: (context) {
            return const OgretmenForm();
          }));
          if (created == true) {
            print("Öğretmenleri yenile");
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class OgretmenIndirmeButonu extends StatefulWidget {
  const OgretmenIndirmeButonu({
    super.key,
  });

  @override
  State<OgretmenIndirmeButonu> createState() => _OgretmenIndirmeButonuState();
}

class _OgretmenIndirmeButonuState extends State<OgretmenIndirmeButonu> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return isLoading
          ? const CircularProgressIndicator()
          : IconButton(
              icon: const Icon(Icons.download),
              onPressed: () async {
                try {
                  setState(() {
                    isLoading = true;
                  });
                  await ref.read(ogretmenlerProvider).indir();
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                } finally {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
            );
    });
  }
}

class OgretmenSatiri extends StatelessWidget {
  final Ogretmen ogretmen;

  const OgretmenSatiri(
    this.ogretmen, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(ogretmen.ad + ' ' + ogretmen.soyad),
      leading: IntrinsicWidth(
          child:
              Center(child: Text(ogretmen.cinsiyet == 'Kadın' ? '👩' : '👨'))),
    );
  }
}
