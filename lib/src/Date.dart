class LunarDate {
  // Method now([String mode = '']) getting now arabic calendar
  dynamic now([String mod = '']) {
    DateTime date = DateTime.now();
    dynamic gY = date.year.toInt();
    dynamic gM = date.month.toInt();
    dynamic gD = date.day.toInt();
    return gregorianToLunar(gY, gM, gD, mod);
  }

  // Converting Lunar date (Calendar) to Gregorian Calendar with 4 parametr's
  dynamic lunarToGregorian(int lY, int lM, int lD, [String mod = '']) {
    List<int> monthDaysLunar = [
      0,
      30,
      29,
      30,
      29,
      30,
      29,
      30,
      29,
      30,
      29,
      30,
      29 + (isLeapYearL(lY) ? 1 : 0),
    ];
    if (monthDaysLunar[lM] < lD || lM > 12) return false;
    dynamic Leap = (isLeapYearL(lY) == true) ? 1 : 0;
    dynamic jd = ((11 * lY + 3) / 30).floor() +
        354 * lY +
        30 * lM -
        ((lM - 1) / 2).floor() +
        lD +
        1948440 -
        385 +
        Leap;
    if (jd > 2299160) {
      dynamic l = jd + 68569;
      dynamic n = ((4 * l) / 146097).floor();
      // l -= Math.round((146097 * n + 3) / 4);
      l -= ((146097 * n + 3) / 4).round();
      dynamic i = ((4000 * (l + 1)) / 1461001).floor();
      l -= ((1461 * i) / 4).floor() - 31;
      dynamic j = ((80 * l) / 2447).floor();
      dynamic D = l - ((2447 * j) / 80).floor();
      l = (j / 11).floor();
      dynamic M = j + 2 - 12 * l;
      dynamic Y = 100 * (n - 49) + i + l;
      if (mod.isEmpty) {
        return [Y, M, D];
      } else {
        return [Y, M, D].join(mod);
      }
    } else {
      dynamic j = jd + 1402;
      dynamic k = ((j - 1) / 1461).floor();
      dynamic l = j - 1461 * k;
      dynamic n = ((l - 1) / 365).floor() - (l / 1461).floor();
      dynamic i = l - 365 * n + 29;
      j = ((80 * i) / 2447).floor();
      dynamic D = i - ((2447 * j) / 80).floor();
      i = (j / 11).floor();
      dynamic Y = 4 * k + n + i - 4716;
      dynamic M = j + 2 - 12 * i;
      if (mod.isEmpty) {
        return [Y, M, D];
      } else {
        return [Y, M, D].join(mod);
      }
    }
  }

  // Converting Gregorian date (Calendar) to Lunar Calendar with 4 parametr's
  dynamic gregorianToLunar(int gY, int gM, int gD, [String mod = '']) {
    // List<String> dateParts = timestamp.toString().split(' ');

    // Pars Date Calendar
    DateTime dateTime = DateTime.parse(
        '${gY.toString().padLeft(4, '0')}-${gM.toString().padLeft(2, '0')}-${gD.toString().padLeft(2, '0')}');
    List<String> dateParts = dateTime.toString().split(' ');
    List<String> dateNumbers = dateParts[0].split('-');

    int d = int.parse(dateNumbers[2]);
    int m = int.parse(dateNumbers[1]);
    int y = int.parse(dateNumbers[0]);

    late int jd;
    // Validating Year Month and day
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
    // Calculated Calendar
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

  /// Configure for getting gregorianToLunar Date method.
  int ardInt(dynamic float) => (float < -0.0000001)
      ? (float - 0.0000001).ceil()
      : (float + 0.0000001).floor();

  // Check Leap Gregorian
  bool isLeapYearG(int year) {
    // Checking
    return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
  }

  // Check Leap Lunar
  bool isLeapYearL(int year) {
    // Checking
    return [2, 5, 7, 10, 13, 16, 18, 21, 24, 26, 29].contains(year % 30);
  }
}
