import 'package:cri_pat_5/model/random.dart';

class DummyNumbers {
  static int get getRandQuizSize => 4 + mqRand.nextInt(6);
}
