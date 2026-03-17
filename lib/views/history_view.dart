import 'package:flutter/material.dart';
import '../themes.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MotifaTheme.backgroundWhite,
      appBar: AppBar(
        title: const Text(
          'RIWAYAT SCAN',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: MotifaTheme.backgroundWhite,
          ),
        ),
        backgroundColor: MotifaTheme.primaryBlue,
        iconTheme: const IconThemeData(color: MotifaTheme.backgroundWhite),
        scrolledUnderElevation: 0,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.0),
          child: Container(color: MotifaTheme.black, height: 3.0),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24.0),
        itemCount: 5, // data dummy
        separatorBuilder: (context, index) => const SizedBox(height: 24),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: MotifaTheme.backgroundWhite,
              border: MotifaTheme.brutalBorder,
              boxShadow: MotifaTheme.brutalShadowSmall,
            ),
            child: Row(
              children: [
                // gambar kecil
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: MotifaTheme.lightBlue,
                    border: Border(
                      right: BorderSide(color: MotifaTheme.black, width: 3),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.image,
                      size: 40,
                      color: MotifaTheme.black,
                    ),
                  ),
                ),
                // detail info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Batik Parang ${index + 1}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Asal: Yogyakarta',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: MotifaTheme.primaryBlue,
                            border: Border.all(color: MotifaTheme.black),
                          ),
                          child: const Text(
                            'Cocok 98%',
                            style: TextStyle(
                              color: MotifaTheme.backgroundWhite,
                              fontWeight: FontWeight.w900,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // panah aksi
                Container(
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: MotifaTheme.black,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
