import 'package:flutter/material.dart';
import 'package:monline/pages/landing.dart';

class Beranda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.width * 0.60,
                width: MediaQuery.of(context).size.width * 0.60,
                child: Image.asset("assets/monline.png")),
            Padding(padding: EdgeInsets.only(bottom: 0.80)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Monline adalah aplikasi yang bisa memudahkan seseorang untuk berinteraksi " +
                    "langsung dengan bengkel terdekat yang ada di sekitarnya, " +
                    "Monline merupakan solusi saat anda berpergian jauh.\nSaat menggunakan aplikasi Monline,pengguna  sudah disiaplkan fiktur maps untuk mempermudah " +
                    "pengguna mendeteksi bengkel terdekat yang ada di sekitarnya. " +
                    "\nSaat menjalankan Aplikasini ini, aplikasi akan otonatis memberikan data bengkel terdekat y" +
                    "ang berada sejauh 5 km dari tempat kita berada. \nAplikasi akan otomatis memberikan semua " +
                    "data bengkel yang berada di area sekitar 5 km dari tempat kita berada.\n" +
                    "cara menggunakan aplikasi ini : \n" +
                    "1. setelah  membuka  aplikasi ini pusatkan  maps yang \n    sudah tersedia pada tombol button yang disediakan.\n\n" +
                    "2. Lalu  pilih   tombol  yang  berada  di tengah   untuk \n    mencari bengkel yang diinginkan. \n\n" +
                    "3. Lalu pilih bengkel mana saja yang diinginkan \n\n" +
                    "4. Kemudian  anda  bisa  langsung  memesan  bengkel\n    yang   diinginkan   dengan   cara   memencet   tombol \n    whatshapp yang sudah disediakan. \n\n" +
                    "5. Aplikasi akan otomatis memberikan lokasi dan data \n    yang sudah kita isi pada saat registrasi.\n  ",
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
