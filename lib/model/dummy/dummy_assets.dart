
import 'package:cri_pat_5/constants/asset.dart';
import 'package:cri_pat_5/model/random.dart';

class DummyAssets {

  static final List<String> _munichBaseImg = List.generate(
      MQAssets.dummyMunichImageLastNr,
      (idx) => MQAssets.dummyMunichImage(idx+1));

  static String get randMunichImage =>
      _munichBaseImg[mqRand.nextInt(_munichBaseImg.length)];

}