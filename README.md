# Tugas Minggu 3

## Ringkasan Materi & Implementasi

Pada minggu ketiga, tugas yang telah dilakukan meliputi:

- Implementasi penyimpanan lokal menggunakan SQLite
- Implementasi Create Notes (menambahkan catatan baru)
- Implementasi Read Notes (menampilkan daftar catatan)
- Implementasi Update Notes (memperbarui catatan)
- Implementasi Delete Notes (menghapus catatan)
- Proteksi NotesService berdasarkan pengguna yang sedang login

## Deskripsi Singkat

Pada minggu ini pengembangan difokuskan pada penyempurnaan fitur utama aplikasi Notes dengan mengimplementasikan sistem CRUD secara lengkap menggunakan SQLite sebagai penyimpanan lokal serta integrasi ke Cloud Firestore sebagai backend, sehingga data dapat dikelola secara fleksibel. Seluruh operasi tambah, baca, ubah, dan hapus catatan telah berjalan dengan dukungan stream untuk pembaruan real-time, serta layanan dibatasi agar hanya pengguna yang sedang login yang dapat mengakses data mereka sendiri sehingga keamanan dan struktur aplikasi menjadi lebih optimal.

## Hasil Implementasi

Seluruh fitur CRUD Notes telah berhasil berjalan dengan baik termasuk integrasi real-time dengan Cloud Firestore, dan aplikasi dapat digunakan untuk mengelola catatan secara penuh tanpa perlu memuat ulang halaman.
