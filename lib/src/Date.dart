class LunarDate {
  dynamic gregorianToLunar(int gY, int gM, int gD, [String mod = '']) {
    // List<String> dateParts = timestamp.toString().split(' ');

    DateTime dateTime = DateTime.parse(
        '${gY.toString().padLeft(4, '0')}-${gM.toString().padLeft(2, '0')}-${gD.toString().padLeft(2, '0')}');
    List<String> dateParts = dateTime.toString().split(' ');
    List<String> dateNumbers = dateParts[0].split('-');

    int d = int.parse(dateNumbers[2]);
    int m = int.parse(dateNumbers[1]);
    int y = int.parse(dateNumbers[0]);

    late int jd;
    if ((y > 1582) ||
        ((y == 1582) && (m > 10)) ||
        ((y == 1582) && (m == 10) && (d > 14))) {
      jd = ardInt((1461 * (y + 4800 + ardInt((m - 14) / 12)) ~/ 4));
      jd += ardInt((367 * (m - 2 - 12 * (ardInt((m - 14) / 12)))) ~/ 12);
      jd -= ardInt(
          (3 * (ardInt((y + 4900 + ardInt((m - 14) / 12)) ~/ 100))) ~/ 4);
      jd += d - 32076;
    } else {
      jd = 367 * y -
          ardInt((7 * (y + 5001 + ardInt((m - 9) / 7))) ~/ 4) +
          ardInt((275 * m) ~/ 9) +
          d +
          1729777;
    }
    int l = jd - 1948440 + 10632;
    int n = ardInt((l - 1) ~/ 10631);
    l = l - 10631 * n + 355; // Correction: 355 instead of 354
    int j = (ardInt((10985 - l) ~/ 5316)) * (ardInt((50 * l) ~/ 17719)) +
        (ardInt(l ~/ 5670)) * (ardInt((43 * l) ~/ 15238));
    l = l -
        (ardInt((30 - j) ~/ 15)) * (ardInt((17719 * j) ~/ 50)) -
        (ardInt(j ~/ 16)) * (ardInt((15238 * j) ~/ 43)) +
        29;
    m = ardInt((24 * l) ~/ 709);
    d = l - ardInt((709 * m) ~/ 24);
    y = 30 * n + j - 30;

    if (mod.isEmpty) {
      return [y, m, d];
    } else {
      return [y, m, d].join(mod);
    }
  }

  int ardInt(dynamic float) => (float < -0.0000001)
      ? (float - 0.0000001).ceil()
      : (float + 0.0000001).floor();
}

void main() {
  print(LunarDate().gregorianToLunar(2023, 05, 14));
}
