import 'dart:math';

class StringMatching {
  static int levenshteinDistance(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    s = s.toLowerCase().trim();
    t = t.toLowerCase().trim();

    List<int> v0 = List<int>.generate(t.length + 1, (i) => i);
    List<int> v1 = List<int>.filled(t.length + 1, 0);

    for (int i = 0; i < s.length; i++) {
      v1[0] = i + 1;
      for (int j = 0; j < t.length; j++) {
        int cost = (s[i] == t[j]) ? 0 : 1;
        v1[j + 1] = [v1[j] + 1, v0[j + 1] + 1, v0[j] + cost].reduce(min);
      }
      for (int j = 0; j < v0.length; j++) {
        v0[j] = v1[j];
      }
    }
    return v1[t.length];
  }

  /// mengecek apakah dua string bisa dianggap sama (dengan toleransi typo)
  static bool isMatch(String input, String target, {int threshold = 2}) {
    if (input.toLowerCase().trim().contains(target.toLowerCase().trim()) ||
        target.toLowerCase().trim().contains(input.toLowerCase().trim())) {
      return true;
    }

    int distance = levenshteinDistance(input, target);
    return distance <= threshold;
  }
}
