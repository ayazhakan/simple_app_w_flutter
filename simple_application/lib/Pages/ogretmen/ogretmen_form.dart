import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/ogretmen.dart';
import '../../services/DataService.dart';

class OgretmenForm extends ConsumerStatefulWidget {
  const OgretmenForm({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ogretmenFormState();
}

class _ogretmenFormState extends ConsumerState<OgretmenForm> {
  final Map<String, dynamic> girilen = {};
  final _formKey = GlobalKey<FormState>();

  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yeni Öğretmen'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.person,size: 200),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Ad"),
                  ),
                  validator: (value) {
                    if (value?.isNotEmpty != true) {
                      return "Ad girmeniz gerekli";
                    }
                  },
                  onSaved: (newValue) {
                    girilen['ad'] = newValue;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Soyad"),
                  ),
                  validator: (value) {
                    if (value?.isNotEmpty != true) {
                      return "Soyad girmeniz gerekli";
                    }
                  },
                  onSaved: (newValue) {
                    girilen['soyad'] = newValue;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Yaş"),
                  ),
                  validator: (value) {
                    if (value == null || value.isNotEmpty != true) {
                      return "Yaş girmeniz gerekli";
                    }
                    if (int.tryParse(value) == null) {
                      return "Rakamlarla yaş girmeniz gerekli";
                    }
                  },
                  keyboardType: TextInputType.number,
                  onSaved: (newValue) {
                    girilen['yas'] = int.parse(newValue!);
                  },
                ),
                DropdownButtonFormField(
                  items: const [
                    DropdownMenuItem(child: Text("Erkek"), value: "Erkek"),
                    DropdownMenuItem(child: Text("Kadın"), value: "Kadın")
                  ],
                  onChanged: (value) {
                    setState(() {
                      girilen['cinsiyet'] = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Lütfen cinsiyet giriniz";
                    }
                  },
                ),
                isSaving
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () async {
                          final formState = _formKey.currentState;
                          if (formState == null) return;
                          if (formState.validate() == true) {
                            formState.save();
                            print(girilen);
                          }

                          _kaydet();
                        },
                        child: const Text("Kaydet"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _kaydet() async {
    bool bitti=false;
    while(!bitti){
      try {
        setState(() {
          isSaving = true;
        });
        await gercektenKaydet();
        bitti=true;
        Navigator.of(context).pop(true);
      } catch (e) {
        final snackBar = ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
        await snackBar.closed;
      } finally {
        setState(() {
          isSaving = false;
        });
      }
    }

  }

  Future<void> gercektenKaydet() async {
    await ref.read(dataServiceProvider).ogretmenEkle(Ogretmen.fromMap(girilen));
  }
}
