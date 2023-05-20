import 'package:lunar_date/lunar_date.dart';

void main(){
  // Implode date by separator
  String nowLunarDate = LunarDate().now('/');
  print(nowLunarDate);

  // Extract Year, Month and day from now function.
  List date = LunarDate().now();
  var y = date[0];
  var m = date[1];
  var d  = date[2];
  print('$y - $m - $d');

  // Convert Gregorian to lunar
  var g = LunarDate().gregorianToLunar(2023, 5, 20);
  print(g);
  // Convert Lunar TO Gregorian
  var l = LunarDate().lunarToGregorian(1444, 10, 29);
  print(l);

  // Check Leap Year Lunar Result bool
  print(LunarDate().isLeapYearL(1444));


  // Check Leap Year Gregorian Result bool
  print(LunarDate().isLeapYearG(2023));


}