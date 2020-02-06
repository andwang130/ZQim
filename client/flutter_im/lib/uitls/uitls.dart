import 'package:date_format/date_format.dart';



String UitlsFormatDate(DateTime date){

  return formatDate(date, [yyyy, '-', mm, '-', dd," ",HH, ':', nn, ':', ss]);

}