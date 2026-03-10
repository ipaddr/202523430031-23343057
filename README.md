# Tugas Minggu 4

## Ringkasan Materi & Implementasi

Pada minggu keempat, tugas yang telah dilakukan meliputi:

- **Pengenalan BLoC**: Mengimplementasikan pola _Business Logic Component_ untuk manajemen state yang lebih terstruktur.
- **Konversi Autentikasi ke BLoC**: Mengubah seluruh alur proses autentikasi (Login, Register, Forget Password) menggunakan BLoC.
- **Penanganan Exception**: Mengelola berbagai pengecualian dan error selama proses login melalui state BLoC.
- **Routing & Dialog dengan BLoC**: Mengintegrasikan sistem navigasi dan tampilan dialog ke dalam logika BLoC.
- **Loading Screens**: Menambahkan layar pemuatan yang responsif selama proses asinkron berlangsung.
- **Ikon & Nama Aplikasi**: Mengonfigurasi branding aplikasi dengan mengubah ikon peluncur dan nama aplikasi.
- **Splash Screen**: Mengimplementasikan layar splash untuk meningkatkan kualitas visual saat aplikasi dimulai.
  - _Catatan Kendala_: Terdapat kendala pada implementasi Splash Screen di mana metode tutorial (mengganti `mipmap`) sudah tidak berfungsi optimal pada Android 12 ke atas karena adanya API Splash Screen baru.
- **Keamanan Firebase**: Melakukan audit dan perbaikan pada aturan keamanan (_Security Rules_) Firebase.

## Deskripsi Singkat

Minggu ini merupakan tahap transisi besar bagi aplikasi "MyNotes" dengan migrasi total sistem manajemen state ke **Flutter BLoC**. Fokus utama adalah memisahkan logika bisnis autentikasi dari lapisan antarmuka pengguna, sehingga aplikasi memiliki alur data yang lebih searah dan mudah didebug. Selain perbaikan arsitektur, aplikasi juga mendapatkan peningkatan dari sisi estetika dan profesionalisme dengan adanya splash screen, kustomisasi ikon, serta penanganan error yang lebih informatif bagi pengguna. Tahap penutup minggu ini melibatkan penguatan keamanan backend Firebase untuk memastikan data pengguna tetap terlindungi.

## Hasil Implementasi

Aplikasi kini telah menggunakan BLoC untuk seluruh proses autentikasi dan memiliki tampilan yang lebih matang untuk persiapan rilis:

<p align="left">
  <img src="https://github.com/user-attachments/assets/397b005e-8394-40d3-a64b-01a0ea20c521" width="250"/>
  <img src="https://github.com/user-attachments/assets/41b0df93-f402-4ae5-ae33-1e474375c75e" width="250"/>
  <img src="https://github.com/user-attachments/assets/4a624817-99af-4f6e-9477-a4b036aae6cf" width="250"/>
</p>
<p align="left">
  <img src="https://github.com/user-attachments/assets/7b8e868d-99b0-4385-a76e-091b992242e6" width="250"/>
  <img src="https://github.com/user-attachments/assets/20142140-fe1f-4df2-b1b6-408aa5e3e342" width="250"/>
  <img src="https://github.com/user-attachments/assets/9d5d6999-c5fc-40cd-a9e2-4666f7ec4d22" width="250"/>
</p>
<p align="left">
  <img src="https://github.com/user-attachments/assets/c8925db8-0348-430d-a2af-b58a0481b5bb" width="250"/>
  <img src="https://github.com/user-attachments/assets/a1cf0dd2-79f9-48b4-8a31-fdbbf4f0859c" width="250"/>
  <img src="https://github.com/user-attachments/assets/b9dd5d1f-6386-4043-ba40-310ce6f85d4e" width="250"/>
</p>
<p align="left">
  <img src="https://github.com/user-attachments/assets/26782478-d7d9-4781-b4fe-f60301992148" width="250"/>
  <img src="https://github.com/user-attachments/assets/26492702-618d-4a3a-b8e8-beb20079c2ea" width="250"/>
</p>

