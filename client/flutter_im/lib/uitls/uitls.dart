import 'package:date_format/date_format.dart';
import 'package:shared_preferences/shared_preferences.dart';

String UitlsFormatDate(DateTime date){

  return formatDate(date, [yyyy, '-', mm, '-', dd," ",HH, ':', nn, ':', ss]);

}

cleanToken()async{
  SharedPreferences prefs = await  SharedPreferences.getInstance();
  prefs.clear();
}