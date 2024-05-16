import 'package:translator/translator.dart';

void trailing() async {
  final translator = GoogleTranslator();
  final input = "Hello";
  print('Translated: ${await input.translate(to: 'iw')}');
}


