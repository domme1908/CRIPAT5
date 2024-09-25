
import 'package:cri_pat_5/model/random.dart';

class DummyDates {

  static final List<DateTime> _dates = List.generate(30,
          (index) => DateTime(2020,
              mqRand.nextInt(12)+1, mqRand.nextInt(27)+1));

  static DateTime get getRandDate => _dates[mqRand.nextInt(_dates.length)];

}